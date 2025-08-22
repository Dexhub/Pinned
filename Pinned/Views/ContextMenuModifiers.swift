import SwiftUI
import MapKit

// MARK: - Country Preview
struct CountryPreviewView: View {
    let country: String
    let isVisited: Bool
    @EnvironmentObject var travelData: TravelData
    
    var countryInfo: CountryInfo? {
        WorldDatabase.getCountryByName(country)
    }
    
    var visitCount: Int {
        travelData.travelRecords.filter { $0.country == country }.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(country)
                        .font(.system(size: 24, weight: .bold))
                    
                    if let info = countryInfo {
                        HStack {
                            Text(info.continent.rawValue)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            
                            Text("•")
                                .foregroundColor(.secondary)
                            
                            Text(info.capital)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                if isVisited {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.green)
                }
            }
            
            // Quick Stats
            if isVisited {
                HStack(spacing: 20) {
                    VStack(spacing: 4) {
                        Text("\(visitCount)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "FF0080"))
                        Text("Visits")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if let lastVisit = travelData.travelRecords
                        .filter({ $0.country == country })
                        .sorted(by: { $0.visitDate > $1.visitDate })
                        .first {
                        
                        VStack(spacing: 4) {
                            Text(lastVisit.visitDate.formatted(.dateTime.month().year()))
                                .font(.system(size: 14, weight: .medium))
                            Text("Last Visit")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            
            // Fun Fact
            if let fact = getCountryFact(country) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Fun Fact", systemImage: "lightbulb.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "0080FF"))
                    
                    Text(fact)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(hex: "0080FF").opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding()
        .frame(width: 300)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 10)
    }
    
    func getCountryFact(_ country: String) -> String? {
        let facts: [String: String] = [
            "Japan": "Has over 6,800 islands, but only 430 are inhabited",
            "Iceland": "Has no mosquitoes due to its climate",
            "Australia": "Has more than 10,000 beaches",
            "Brazil": "Is home to 60% of the Amazon rainforest",
            "Canada": "Has more lakes than the rest of the world combined",
            "Italy": "Has more UNESCO World Heritage sites than any other country",
            "India": "Is the world's largest democracy",
            "Norway": "Has the world's longest road tunnel at 24.5 km",
            "Egypt": "The Great Pyramid was the tallest building for 3,800 years",
            "New Zealand": "Has more sheep than people (5:1 ratio)"
        ]
        return facts[country]
    }
}

// MARK: - Travel Record Preview
struct TravelRecordPreviewView: View {
    let record: TravelRecord
    @State private var showingFullImage = false
    @State private var selectedPhoto: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.name)
                        .font(.system(size: 20, weight: .bold))
                    
                    HStack {
                        Text(record.country)
                        Text("•")
                        Text(record.visitDate.formatted(.dateTime.month().day().year()))
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Rating
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < record.rating ? "star.fill" : "star")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "FFD700"))
                    }
                }
            }
            
            // Quick Info
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                InfoPill(icon: "calendar", text: "\(record.duration) days")
                InfoPill(icon: "person.2.fill", text: record.companions.isEmpty ? "Solo" : "\(record.companions.count) companions")
                InfoPill(icon: "cloud.sun.fill", text: record.weather?.rawValue ?? "Unknown")
                InfoPill(icon: "airplane", text: record.tripType.rawValue)
            }
            
            // Notes Preview
            if !record.notes.isEmpty {
                Text(record.notes)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // Photos Preview
            if !record.photos.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(record.photos.prefix(3), id: \.self) { photoId in
                            // Placeholder for actual photos
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                )
                        }
                        
                        if record.photos.count > 3 {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 60, height: 60)
                                
                                Text("+\(record.photos.count - 3)")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .frame(width: 320)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

struct InfoPill: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "FF0080"))
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}

// MARK: - Context Menu Actions
struct CountryContextMenu: ViewModifier {
    let country: String
    let isVisited: Bool
    let onAdd: () -> Void
    let onShowDetails: () -> Void
    let onShare: () -> Void
    
    func body(content: Content) -> some View {
        content
            .contextMenu {
                if !isVisited {
                    Button(action: onAdd) {
                        Label("Mark as Visited", systemImage: "checkmark.circle")
                    }
                }
                
                Button(action: onShowDetails) {
                    Label("View Details", systemImage: "info.circle")
                }
                
                if isVisited {
                    Button(action: onShare) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
                
                if let countryInfo = WorldDatabase.getCountryByName(country) {
                    Divider()
                    
                    Menu {
                        ForEach(countryInfo.majorCities.prefix(5), id: \.self) { city in
                            Button(city) {
                                // Add city action
                            }
                        }
                    } label: {
                        Label("Popular Cities", systemImage: "building.2")
                    }
                }
            } preview: {
                CountryPreviewView(country: country, isVisited: isVisited)
            }
    }
}

struct TravelRecordContextMenu: ViewModifier {
    let record: TravelRecord
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onShare: () -> Void
    let onDuplicate: () -> Void
    
    func body(content: Content) -> some View {
        content
            .contextMenu {
                Button(action: onEdit) {
                    Label("Edit", systemImage: "pencil")
                }
                
                Button(action: onShare) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                
                Button(action: onDuplicate) {
                    Label("Duplicate", systemImage: "doc.on.doc")
                }
                
                Divider()
                
                Button(role: .destructive, action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
            } preview: {
                TravelRecordPreviewView(record: record)
            }
    }
}

// MARK: - View Extensions
extension View {
    func countryContextMenu(
        country: String,
        isVisited: Bool,
        onAdd: @escaping () -> Void,
        onShowDetails: @escaping () -> Void,
        onShare: @escaping () -> Void
    ) -> some View {
        modifier(CountryContextMenu(
            country: country,
            isVisited: isVisited,
            onAdd: onAdd,
            onShowDetails: onShowDetails,
            onShare: onShare
        ))
    }
    
    func travelRecordContextMenu(
        record: TravelRecord,
        onEdit: @escaping () -> Void,
        onDelete: @escaping () -> Void,
        onShare: @escaping () -> Void,
        onDuplicate: @escaping () -> Void
    ) -> some View {
        modifier(TravelRecordContextMenu(
            record: record,
            onEdit: onEdit,
            onDelete: onDelete,
            onShare: onShare,
            onDuplicate: onDuplicate
        ))
    }
}