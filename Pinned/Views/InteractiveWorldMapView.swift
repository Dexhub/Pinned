import SwiftUI
import MapKit

struct InteractiveWorldMapView: View {
    @EnvironmentObject var travelData: TravelData
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 150, longitudeDelta: 300)
    )
    @State private var selectedCountry: String?
    @State private var showingDetail = false
    @State private var mapType: MKMapType = .mutedStandard
    
    let visitedColor = Color(hex: "FF0080")
    
    var body: some View {
        ZStack {
            // Native Map with overlays
            Map(coordinateRegion: $region,
                interactionModes: [.zoom, .pan],
                showsUserLocation: false,
                userTrackingMode: .none,
                annotationItems: createAnnotations()) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    MapCountryPin(
                        name: item.name,
                        isVisited: item.isVisited,
                        flag: item.flag
                    )
                    .onTapGesture {
                        selectedCountry = item.name
                        showingDetail = true
                    }
                }
            }
            .preferredColorScheme(.light)
            .ignoresSafeArea()
            
            // Gradient overlay for ocean effect
            LinearGradient(
                colors: [Color.clear, Color(hex: "E3F2FD").opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)
            
            // UI Overlay
            VStack {
                // Top controls
                HStack {
                    // Stats display
                    HStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("\(travelData.visitedCountries.count)")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(visitedColor)
                            Text("of 195 countries")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Divider()
                            .frame(height: 40)
                        
                        VStack(alignment: .leading) {
                            Text("\(Int(travelData.worldPercentage()))%")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(Color(hex: "45B7D1"))
                            Text("world coverage")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                    
                    Spacer()
                    
                    // Map controls
                    VStack(spacing: 0) {
                        Button(action: zoomIn) {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.gray)
                                .frame(width: 44, height: 44)
                        }
                        
                        Divider()
                        
                        Button(action: zoomOut) {
                            Image(systemName: "minus")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.gray)
                                .frame(width: 44, height: 44)
                        }
                        
                        Divider()
                        
                        Button(action: resetView) {
                            Image(systemName: "globe")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.gray)
                                .frame(width: 44, height: 44)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding()
                
                Spacer()
                
                // Bottom legend
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(visitedColor)
                            Text("Visited")
                                .font(.system(size: 14, weight: .medium))
                        }
                        
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.gray.opacity(0.5))
                            Text("Not Visited")
                                .font(.system(size: 14, weight: .medium))
                        }
                        
                        Divider()
                            .frame(height: 20)
                        
                        Text("Tap a country to mark as visited")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.95))
                            .shadow(radius: 5)
                    )
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingDetail) {
            if let country = selectedCountry {
                CountryDetailSheet(
                    country: country,
                    isVisited: travelData.visitedCountries.contains(country),
                    onAdd: {
                        travelData.addCountry(country)
                        showingDetail = false
                    }
                )
            }
        }
    }
    
    func createAnnotations() -> [MapPin] {
        WorldDatabase.countries.map { country in
            MapPin(
                name: country.name,
                coordinate: country.coordinates,
                isVisited: travelData.visitedCountries.contains(country.name),
                flag: getFlag(for: country.code)
            )
        }
    }
    
    func getFlag(for code: String) -> String {
        let base: UInt32 = 127397
        var flag = ""
        for scalar in code.unicodeScalars {
            flag.unicodeScalars.append(UnicodeScalar(base + scalar.value)!)
        }
        return flag
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
    
    func resetView() {
        withAnimation {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 150, longitudeDelta: 300)
            )
        }
    }
}

struct MapPin: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let isVisited: Bool
    let flag: String
}

struct MapCountryPin: View {
    let name: String
    let isVisited: Bool
    let flag: String
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                if isVisited {
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "FF0080"))
                        .background(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 20, height: 20)
                        )
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.6))
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
            }
            .shadow(radius: 3)
            
            // Show flag for visited countries
            if isVisited {
                Text(flag)
                    .font(.system(size: 20))
            }
        }
    }
}

#Preview {
    InteractiveWorldMapView()
        .environmentObject(TravelData())
}