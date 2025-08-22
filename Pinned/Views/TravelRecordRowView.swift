import SwiftUI

struct TravelRecordRowView: View {
    let record: TravelRecord
    let onEdit: () -> Void
    let onDelete: () -> Void
    @State private var showingDeleteAlert = false
    @State private var showingEditSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with destination and country
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .accessibleHeader(level: .h3)
                    
                    Text(record.country)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Rating
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= record.rating ? "star.fill" : "star")
                            .foregroundColor(star <= record.rating ? .yellow : .gray)
                            .font(.caption)
                    }
                }
                .accessibilityLabel("Rating: \(record.rating) out of 5 stars")
            }
            
            // Date and duration
            VStack(alignment: .leading, spacing: 4) {
                Text(formatDateRange())
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if !record.notes.isEmpty {
                    Text(record.notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            // Tags and budget
            HStack {
                if !record.activities.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(Array(record.activities.prefix(3)), id: \.self) { activity in
                            Text(activity)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                        }
                        
                        if record.activities.count > 3 {
                            Text("+\(record.activities.count - 3)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                if let budget = record.budget {
                    Text("$\(Int(budget))")
                        .font(.caption)
                        .foregroundColor(.green)
                        .accessibilityLabel("Budget: \(Int(budget)) dollars")
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .contextMenu {
            Button {
                showingEditSheet = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                showingDeleteAlert = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityDescription)
        .accessibilityHint("Double tap for options, or use context menu")
        .alert("Delete Travel Record?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("This will permanently delete your trip to \(record.name). This action cannot be undone.")
        }
        .sheet(isPresented: $showingEditSheet) {
            EditTravelRecordView(record: record) { updatedRecord in
                // Handle the updated record
                showingEditSheet = false
            } onCancel: {
                showingEditSheet = false
            }
        }
    }
    
    private func formatDateRange() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        if let endDate = record.endDate {
            let duration = Calendar.current.dateComponents([.day], from: record.visitDate, to: endDate).day ?? 0
            if duration > 0 {
                return "\(formatter.string(from: record.visitDate)) - \(formatter.string(from: endDate)) (\(duration + 1) days)"
            }
        }
        
        return formatter.string(from: record.visitDate)
    }
    
    private var accessibilityDescription: String {
        var description = "\(record.name), \(record.country)"
        description += ", rated \(record.rating) out of 5 stars"
        description += ", visited on \(formatDateRange())"
        
        if !record.notes.isEmpty {
            description += ", notes: \(record.notes)"
        }
        
        if let budget = record.budget {
            description += ", budget: \(Int(budget)) dollars"
        }
        
        return description
    }
}

struct EditTravelRecordView: View {
    @State private var editedRecord: TravelRecord
    let onSave: (TravelRecord) -> Void
    let onCancel: () -> Void
    
    @State private var showingPhotoPicker = false
    @State private var selectedPhotos: [String] = []
    
    init(record: TravelRecord, onSave: @escaping (TravelRecord) -> Void, onCancel: @escaping () -> Void) {
        self._editedRecord = State(initialValue: record)
        self.onSave = onSave
        self.onCancel = onCancel
        self._selectedPhotos = State(initialValue: record.photos)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    AccessibleTextField("Destination", text: $editedRecord.name, isRequired: true)
                    AccessibleTextField("Country", text: $editedRecord.country, isRequired: true)
                    
                    DatePicker("Start Date", selection: $editedRecord.visitDate, displayedComponents: .date)
                        .accessibilityLabel("Visit start date")
                    
                    if editedRecord.endDate != nil {
                        DatePicker("End Date", selection: Binding(
                            get: { editedRecord.endDate ?? editedRecord.visitDate },
                            set: { editedRecord.endDate = $0 }
                        ), displayedComponents: .date)
                        .accessibilityLabel("Visit end date")
                    }
                    
                    Toggle("Multi-day trip", isOn: Binding(
                        get: { editedRecord.endDate != nil },
                        set: { isOn in
                            if isOn {
                                editedRecord.endDate = Calendar.current.date(byAdding: .day, value: 1, to: editedRecord.visitDate)
                            } else {
                                editedRecord.endDate = nil
                            }
                        }
                    ))
                    .accessibilityLabel("Toggle multi-day trip")
                }
                
                Section(header: Text("Rating & Review")) {
                    AccessibleRating(rating: Binding(
                        get: { editedRecord.rating },
                        set: { editedRecord.rating = $0 }
                    ))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                        
                        TextEditor(text: $editedRecord.notes)
                            .frame(minHeight: 80)
                            .accessibilityLabel("Trip notes")
                            .accessibilityHint("Enter any notes about your trip")
                    }
                }
                
                Section(header: Text("Trip Details")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Budget (Optional)")
                            .font(.headline)
                        
                        HStack {
                            Text("$")
                            TextField("0", value: Binding(
                                get: { editedRecord.budget ?? 0 },
                                set: { editedRecord.budget = $0 > 0 ? $0 : nil }
                            ), format: .number)
                            .keyboardType(.decimalPad)
                            .accessibilityLabel("Trip budget in dollars")
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weather")
                            .font(.headline)
                        
                        TextField("Sunny, Rainy, etc.", text: Binding(
                            get: { editedRecord.weather ?? "" },
                            set: { editedRecord.weather = $0.isEmpty ? nil : $0 }
                        ))
                        .accessibilityLabel("Weather during trip")
                    }
                }
                
                Section(header: Text("Activities & Companions")) {
                    EditableTagsView(
                        title: "Activities",
                        tags: $editedRecord.activities,
                        placeholder: "Add activity"
                    )
                    
                    EditableTagsView(
                        title: "Travel Companions",
                        tags: $editedRecord.companions,
                        placeholder: "Add companion"
                    )
                    
                    EditableTagsView(
                        title: "Highlights",
                        tags: $editedRecord.highlights,
                        placeholder: "Add highlight"
                    )
                }
                
                Section(header: Text("Photos")) {
                    if selectedPhotos.isEmpty {
                        Button("Add Photos") {
                            showingPhotoPicker = true
                        }
                        .accessibilityLabel("Add photos to this trip")
                    } else {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                            ForEach(selectedPhotos, id: \.self) { photoURL in
                                AsyncImage(url: URL(fileURLWithPath: photoURL)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                }
                                .frame(width: 80, height: 80)
                                .clipped()
                                .cornerRadius(8)
                                .accessibilityLabel("Trip photo")
                            }
                        }
                        
                        Button("Add More Photos") {
                            showingPhotoPicker = true
                        }
                        .accessibilityLabel("Add more photos")
                    }
                }
            }
            .navigationTitle("Edit Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .accessibilityLabel("Cancel editing")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        editedRecord.photos = selectedPhotos
                        onSave(editedRecord)
                    }
                    .accessibilityLabel("Save changes")
                    .disabled(editedRecord.name.isEmpty || editedRecord.country.isEmpty)
                }
            }
            .sheet(isPresented: $showingPhotoPicker) {
                PhotoSelectionView(selectedPhotos: $selectedPhotos)
            }
        }
    }
}

struct EditableTagsView: View {
    let title: String
    @Binding var tags: [String]
    let placeholder: String
    
    @State private var newTag = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .accessibleHeader(level: .h4)
            
            // Existing tags
            if !tags.isEmpty {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), alignment: .leading, spacing: 8) {
                    ForEach(Array(tags.enumerated()), id: \.offset) { index, tag in
                        HStack {
                            Text(tag)
                                .font(.caption)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Button {
                                tags.remove(at: index)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                            .accessibilityLabel("Remove \(tag)")
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(16)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(tag), removable")
                    }
                }
            }
            
            // Add new tag
            HStack {
                TextField(placeholder, text: $newTag)
                    .focused($isTextFieldFocused)
                    .onSubmit {
                        addTag()
                    }
                    .accessibilityLabel("Add new \(title.lowercased())")
                
                Button("Add") {
                    addTag()
                }
                .disabled(newTag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .accessibilityLabel("Add \(newTag.isEmpty ? "new item" : newTag)")
            }
        }
    }
    
    private func addTag() {
        let trimmed = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty && !tags.contains(trimmed) {
            tags.append(trimmed)
            newTag = ""
        }
    }
}

#Preview {
    TravelRecordRowView(
        record: TravelRecord(
            placeType: .city,
            name: "Paris",
            country: "France",
            continent: "Europe",
            coordinates: Coordinates(latitude: 48.8566, longitude: 2.3522),
            visitDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            rating: 5,
            tripType: .leisure,
            companions: ["Partner", "Friend"],
            budget: 1200,
            notes: "Amazing city with incredible food and culture!",
            photos: [],
            weather: "Sunny",
            activities: ["Museums", "Restaurants", "Walking"],
            accommodation: nil,
            highlights: ["Eiffel Tower", "Louvre", "Seine River"],
            wouldRevisit: true,
            tags: []
        ),
        onEdit: { print("Edit tapped") },
        onDelete: { print("Delete tapped") }
    )
    .padding()
}