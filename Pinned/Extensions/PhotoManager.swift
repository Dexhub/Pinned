import SwiftUI
import PhotosUI
import AVFoundation

@MainActor
class PhotoManager: ObservableObject {
    @Published var selectedImages: [UIImage] = []
    @Published var photoItems: [PhotosPickerItem] = []
    @Published var isShowingCamera = false
    @Published var isShowingPhotoPicker = false
    @Published var capturedImage: UIImage?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let maxPhotos = 10
    private let maxImageSize: CGFloat = 1024
    
    func requestPhotoLibraryPermission() async -> Bool {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            return true
        case .notDetermined:
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            return newStatus == .authorized || newStatus == .limited
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }
    
    func requestCameraPermission() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }
    
    func loadPhotos() async {
        guard !photoItems.isEmpty else { return }
        
        isLoading = true
        var loadedImages: [UIImage] = []
        
        for item in photoItems {
            do {
                guard let data = try await item.loadTransferable(type: Data.self),
                      let image = UIImage(data: data) else {
                    continue
                }
                
                let resizedImage = await resizeImage(image, to: maxImageSize)
                loadedImages.append(resizedImage)
                
                if loadedImages.count >= maxPhotos {
                    break
                }
            } catch {
                print("Error loading photo: \(error)")
                errorMessage = "Failed to load some photos"
            }
        }
        
        selectedImages = loadedImages
        isLoading = false
    }
    
    func addCapturedImage(_ image: UIImage) async {
        let resizedImage = await resizeImage(image, to: maxImageSize)
        
        if selectedImages.count < maxPhotos {
            selectedImages.append(resizedImage)
        } else {
            errorMessage = "Maximum of \(maxPhotos) photos allowed"
        }
    }
    
    func removeImage(at index: Int) {
        guard index < selectedImages.count else { return }
        selectedImages.remove(at: index)
    }
    
    func savePhotosToDocuments() async -> [String] {
        var photoURLs: [String] = []
        
        for (index, image) in selectedImages.enumerated() {
            if let url = await saveImageToDocuments(image, filename: "photo_\(UUID().uuidString)_\(index).jpg") {
                photoURLs.append(url)
            }
        }
        
        return photoURLs
    }
    
    func loadImagesFromURLs(_ urls: [String]) async -> [UIImage] {
        var images: [UIImage] = []
        
        for urlString in urls {
            if let image = await loadImageFromDocuments(urlString) {
                images.append(image)
            }
        }
        
        return images
    }
    
    func deletePhotosFromDocuments(_ urls: [String]) async {
        for urlString in urls {
            await deleteImageFromDocuments(urlString)
        }
    }
    
    // MARK: - Private Methods
    
    private func resizeImage(_ image: UIImage, to maxSize: CGFloat) async -> UIImage {
        let size = image.size
        let ratio = min(maxSize / size.width, maxSize / size.height)
        
        if ratio >= 1.0 {
            return image // No need to resize
        }
        
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
                image.draw(in: CGRect(origin: .zero, size: newSize))
                let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
                UIGraphicsEndImageContext()
                
                continuation.resume(returning: newImage)
            }
        }
    }
    
    private func saveImageToDocuments(_ image: UIImage, filename: String) async -> String? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let fileURL = documentsDirectory.appendingPathComponent(filename)
                
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    continuation.resume(returning: nil)
                    return
                }
                
                do {
                    try imageData.write(to: fileURL)
                    continuation.resume(returning: fileURL.lastPathComponent)
                } catch {
                    print("Error saving image: \(error)")
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    private func loadImageFromDocuments(_ filename: String) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let fileURL = documentsDirectory.appendingPathComponent(filename)
                
                guard let imageData = try? Data(contentsOf: fileURL),
                      let image = UIImage(data: imageData) else {
                    continuation.resume(returning: nil)
                    return
                }
                
                continuation.resume(returning: image)
            }
        }
    }
    
    private func deleteImageFromDocuments(_ filename: String) async {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    continuation.resume()
                    return
                }
                
                let fileURL = documentsDirectory.appendingPathComponent(filename)
                
                try? FileManager.default.removeItem(at: fileURL)
                continuation.resume()
            }
        }
    }
    
    func clearSelection() {
        selectedImages.removeAll()
        photoItems.removeAll()
        capturedImage = nil
        errorMessage = nil
    }
}

// MARK: - Camera View

struct CameraView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var capturedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.capturedImage = image
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

// MARK: - Photo Selection View

struct PhotoSelectionView: View {
    @StateObject private var photoManager = PhotoManager()
    @Binding var selectedPhotos: [String]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                if photoManager.isLoading {
                    VStack {
                        ProgressView()
                        Text("Loading photos...")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                            ForEach(Array(photoManager.selectedImages.enumerated()), id: \.offset) { index, image in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(8)
                                    
                                    Button {
                                        photoManager.removeImage(at: index)
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .background(Color.white, in: Circle())
                                    }
                                    .offset(x: 8, y: -8)
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                // Action buttons
                HStack(spacing: 16) {
                    PhotosPicker(
                        selection: $photoManager.photoItems,
                        maxSelectionCount: 10
                    ) {
                        Label("Photo Library", systemImage: "photo.on.rectangle.angled")
                    }
                    .buttonStyle(.bordered)
                    .onChange(of: photoManager.photoItems) { _, _ in
                        Task {
                            await photoManager.loadPhotos()
                        }
                    }
                    
                    Button {
                        Task {
                            if await photoManager.requestCameraPermission() {
                                photoManager.isShowingCamera = true
                            }
                        }
                    } label: {
                        Label("Camera", systemImage: "camera")
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .navigationTitle("Add Photos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        Task {
                            let urls = await photoManager.savePhotosToDocuments()
                            selectedPhotos = urls
                            dismiss()
                        }
                    }
                    .disabled(photoManager.selectedImages.isEmpty)
                }
            }
            .sheet(isPresented: $photoManager.isShowingCamera) {
                CameraView(isPresented: $photoManager.isShowingCamera, capturedImage: $photoManager.capturedImage)
            }
            .onChange(of: photoManager.capturedImage) { _, newImage in
                if let image = newImage {
                    Task {
                        await photoManager.addCapturedImage(image)
                        photoManager.capturedImage = nil
                    }
                }
            }
        }
        .task {
            _ = await photoManager.requestPhotoLibraryPermission()
        }
    }
}