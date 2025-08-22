import SwiftUI
import MapKit

struct WorldMapView: View {
    @EnvironmentObject var travelData: TravelData
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 20.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 180)
    )
    @State private var selectedCountry: String?
    @State private var showingCountryDetail = false
    @State private var mapType: MKMapType = .standard
    @State private var annotations: [CountryAnnotation] = []
    
    var body: some View {
        ZStack {
            // Map View
            Map(coordinateRegion: $region, 
                interactionModes: .all,
                showsUserLocation: false,
                annotationItems: annotations) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    CountryPin(
                        country: annotation.country,
                        isVisited: travelData.visitedCountries.contains(annotation.country),
                        isSelected: selectedCountry == annotation.country
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedCountry = annotation.country
                            showingCountryDetail = true
                        }
                    }
                }
            }
            .ignoresSafeArea()
            
            // Overlay Controls
            VStack {
                // Top Bar
                HStack {
                    // Stats
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(travelData.visitedCountries.count) / 195")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        Text("Countries Visited")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    
                    Spacer()
                    
                    // Map Type Selector
                    Picker("Map Type", selection: $mapType) {
                        Text("Standard").tag(MKMapType.standard)
                        Text("Satellite").tag(MKMapType.satellite)
                        Text("Hybrid").tag(MKMapType.hybrid)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.9))
                    )
                }
                .padding()
                
                Spacer()
                
                // Bottom Controls
                HStack {
                    // Legend
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Circle()
                                .fill(Color(hex: "FF0080"))
                                .frame(width: 12, height: 12)
                            Text("Visited")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        HStack {
                            Circle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 12, height: 12)
                            Text("Not Visited")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.7))
                    )
                    
                    Spacer()
                    
                    // Zoom Controls
                    VStack(spacing: 0) {
                        Button(action: zoomIn) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                                .frame(width: 44, height: 44)
                        }
                        Divider()
                        Button(action: zoomOut) {
                            Image(systemName: "minus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                                .frame(width: 44, height: 44)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
                .padding()
            }
        }
        .onAppear {
            loadCountryAnnotations()
        }
        .sheet(isPresented: $showingCountryDetail) {
            if let country = selectedCountry {
                CountryDetailSheet(
                    country: country,
                    isVisited: travelData.visitedCountries.contains(country),
                    onAdd: { addCountry(country) }
                )
            }
        }
    }
    
    func loadCountryAnnotations() {
        annotations = WorldDatabase.countries.map { country in
            CountryAnnotation(
                country: country.name,
                coordinate: CLLocationCoordinate2D(
                    latitude: country.coordinates.latitude,
                    longitude: country.coordinates.longitude
                )
            )
        }
    }
    
    func zoomIn() {
        withAnimation {
            region.span.latitudeDelta /= 2
            region.span.longitudeDelta /= 2
        }
    }
    
    func zoomOut() {
        withAnimation {
            region.span.latitudeDelta = min(region.span.latitudeDelta * 2, 180)
            region.span.longitudeDelta = min(region.span.longitudeDelta * 2, 360)
        }
    }
    
    func addCountry(_ country: String) {
        travelData.addCountry(country)
        showingCountryDetail = false
        
        // Show celebration animation
        withAnimation(.spring()) {
            // Trigger confetti or celebration
        }
    }
}

struct CountryAnnotation: Identifiable {
    let id = UUID()
    let country: String
    let coordinate: CLLocationCoordinate2D
}

struct CountryPin: View {
    let country: String
    let isVisited: Bool
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            // Pin shape
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: isSelected ? 30 : 24))
                .foregroundColor(isVisited ? Color(hex: "FF0080") : Color.gray.opacity(0.6))
                .scaleEffect(isSelected ? 1.2 : 1.0)
                .animation(.spring(), value: isSelected)
            
            // Country flag or initial
            Text(String(country.prefix(2)))
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
        }
        .shadow(radius: isSelected ? 4 : 2)
    }
}

struct CountryDetailSheet: View {
    let country: String
    let isVisited: Bool
    let onAdd: () -> Void
    @Environment(\.dismiss) var dismiss
    @State private var showingAddForm = false
    
    var countryInfo: CountryInfo? {
        WorldDatabase.getCountryByName(country)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Country Header
                    VStack(spacing: 12) {
                        Text(country)
                            .font(.system(size: 32, weight: .bold))
                        
                        if let info = countryInfo {
                            Text(info.continent.rawValue)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        if isVisited {
                            Label("Visited", systemImage: "checkmark.circle.fill")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.top)
                    
                    // Country Info
                    if let info = countryInfo {
                        VStack(alignment: .leading, spacing: 16) {
                            InfoRow(label: "Capital", value: info.capital)
                            InfoRow(label: "Currency", value: info.currency)
                            InfoRow(label: "Language", value: info.languages.first ?? "Unknown")
                            
                            if !info.majorCities.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Major Cities")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(info.majorCities.prefix(5), id: \.self) { city in
                                                Text(city)
                                                    .font(.system(size: 14))
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .background(Color.gray.opacity(0.1))
                                                    .cornerRadius(15)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                    }
                    
                    // Action Button
                    if !isVisited {
                        Button(action: {
                            if showingAddForm {
                                // Go to full add form
                            } else {
                                onAdd()
                            }
                        }) {
                            Label("Mark as Visited", systemImage: "checkmark.circle")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "FF0080"))
                                .cornerRadius(12)
                        }
                        
                        Button("Add Detailed Trip Info") {
                            showingAddForm = true
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "FF0080"))
                    }
                    
                    // Travel Tips
                    if let roast = getCountryRoast(country) {
                        Text(roast)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func getCountryRoast(_ country: String) -> String? {
        let roasts: [String: String] = [
            "France": "Ah, France. Let me guess, Paris?",
            "Italy": "Pizza, pasta, and pretending to understand art.",
            "Japan": "Konnichiwa! Did you learn that from anime?",
            "United States": "Finally exploring your own backyard?",
            "Thailand": "Gap year vibes intensify.",
            "Australia": "Everything really is trying to kill you there.",
            "Iceland": "Blue Lagoon bath salts don't count as culture.",
            "Peru": "Machu Picchu at sunrise. How original.",
            "India": "Found yourself at an ashram yet?"
        ]
        return roasts[country]
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
        }
    }
}

#Preview {
    WorldMapView()
        .environmentObject(TravelData())
}