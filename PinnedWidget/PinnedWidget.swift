import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TravelStatsEntry {
        TravelStatsEntry(date: Date(), stats: mockStats())
    }

    func getSnapshot(in context: Context, completion: @escaping (TravelStatsEntry) -> ()) {
        let entry = TravelStatsEntry(date: Date(), stats: loadStats())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [TravelStatsEntry] = []
        let stats = loadStats()
        
        // Generate a timeline consisting of entries an hour apart
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = TravelStatsEntry(date: entryDate, stats: stats)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func loadStats() -> TravelStats {
        // Load from shared UserDefaults
        if let sharedDefaults = UserDefaults(suiteName: "group.com.aethon.pinned"),
           let data = sharedDefaults.data(forKey: "widgetStats"),
           let stats = try? JSONDecoder().decode(TravelStats.self, from: data) {
            return stats
        }
        return mockStats()
    }
    
    func mockStats() -> TravelStats {
        TravelStats(
            countriesVisited: 12,
            continentsVisited: 3,
            worldPercentage: 6.1,
            totalTrips: 18,
            favoritCountry: "Japan",
            nextMilestone: "Visit 15 countries"
        )
    }
}

struct TravelStats: Codable {
    let countriesVisited: Int
    let continentsVisited: Int
    let worldPercentage: Double
    let totalTrips: Int
    let favoritCountry: String
    let nextMilestone: String
}

struct TravelStatsEntry: TimelineEntry {
    let date: Date
    let stats: TravelStats
}

struct PinnedWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallWidgetView(stats: entry.stats)
        case .systemMedium:
            MediumWidgetView(stats: entry.stats)
        case .systemLarge:
            LargeWidgetView(stats: entry.stats)
        case .accessoryCircular:
            CircularWidgetView(stats: entry.stats)
        case .accessoryRectangular:
            RectangularWidgetView(stats: entry.stats)
        case .accessoryInline:
            InlineWidgetView(stats: entry.stats)
        default:
            SmallWidgetView(stats: entry.stats)
        }
    }
}

// MARK: - Small Widget
struct SmallWidgetView: View {
    let stats: TravelStats
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(LinearGradient(
                    colors: [Color(hex: "FF0080"), Color(hex: "FF8C00")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            
            VStack(spacing: 12) {
                Image(systemName: "globe")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                
                VStack(spacing: 4) {
                    Text("\(stats.countriesVisited)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Countries")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Text("\(stats.worldPercentage, specifier: "%.1f")% explored")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

// MARK: - Medium Widget
struct MediumWidgetView: View {
    let stats: TravelStats
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(LinearGradient(
                    colors: [Color(hex: "FF0080"), Color(hex: "FF8C00")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            
            HStack(spacing: 20) {
                // Left side - Main stat
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "globe")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                    
                    Text("\(stats.countriesVisited)")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Countries Visited")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Text(stats.nextMilestone)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                // Right side - Additional stats
                VStack(alignment: .trailing, spacing: 16) {
                    StatRow(icon: "flag.fill", value: "\(stats.continentsVisited)/7", label: "Continents")
                    StatRow(icon: "airplane", value: "\(stats.totalTrips)", label: "Trips")
                    StatRow(icon: "heart.fill", value: stats.favoritCountry, label: "Favorite")
                }
            }
            .padding()
        }
    }
}

// MARK: - Large Widget
struct LargeWidgetView: View {
    let stats: TravelStats
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(LinearGradient(
                    colors: [Color(hex: "FF0080"), Color(hex: "FF8C00")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Image(systemName: "globe")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                    
                    Text("Travel Stats")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                
                // Main stats grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    LargeStatCard(icon: "flag.fill", value: "\(stats.countriesVisited)", label: "Countries", subtext: "\(stats.worldPercentage, specifier: "%.1f")% of world")
                    LargeStatCard(icon: "globe.americas.fill", value: "\(stats.continentsVisited)/7", label: "Continents", subtext: "Explored")
                    LargeStatCard(icon: "airplane", value: "\(stats.totalTrips)", label: "Total Trips", subtext: "Taken")
                    LargeStatCard(icon: "heart.fill", value: stats.favoritCountry, label: "Favorite", subtext: "Destination")
                }
                
                Spacer()
                
                // Next milestone
                HStack {
                    Image(systemName: "target")
                        .font(.system(size: 16))
                    Text("Next: \(stats.nextMilestone)")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
                
                // Progress visualization
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white)
                            .frame(width: geometry.size.width * (stats.worldPercentage / 100), height: 8)
                    }
                }
                .frame(height: 8)
            }
            .padding()
        }
    }
}

// MARK: - Lockscreen Widgets

struct CircularWidgetView: View {
    let stats: TravelStats
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 2) {
                Image(systemName: "globe")
                    .font(.system(size: 14))
                Text("\(stats.countriesVisited)")
                    .font(.system(size: 20, weight: .bold))
            }
        }
    }
}

struct RectangularWidgetView: View {
    let stats: TravelStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "globe")
                    .font(.system(size: 12))
                Text("\(stats.countriesVisited) countries")
                    .font(.system(size: 14, weight: .medium))
            }
            Text("\(stats.worldPercentage, specifier: "%.1f")% explored")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
    }
}

struct InlineWidgetView: View {
    let stats: TravelStats
    
    var body: some View {
        HStack {
            Image(systemName: "globe")
            Text("\(stats.countriesVisited) countries • \(stats.worldPercentage, specifier: "%.1f")%")
        }
    }
}

// MARK: - Helper Views

struct StatRow: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(value)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

struct LargeStatCard: View {
    let icon: String
    let value: String
    let label: String
    let subtext: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 2) {
                Text(label)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                
                Text(subtext)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
    }
}

// MARK: - Main Widget

@main
struct PinnedWidget: Widget {
    let kind: String = "PinnedWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PinnedWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Travel Stats")
        .description("Track your travel progress at a glance")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}

// MARK: - Preview

struct PinnedWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PinnedWidgetEntryView(entry: TravelStatsEntry(
                date: Date(),
                stats: TravelStats(
                    countriesVisited: 23,
                    continentsVisited: 4,
                    worldPercentage: 11.7,
                    totalTrips: 42,
                    favoritCountry: "Japan",
                    nextMilestone: "Visit 25 countries"
                )
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            PinnedWidgetEntryView(entry: TravelStatsEntry(
                date: Date(),
                stats: TravelStats(
                    countriesVisited: 23,
                    continentsVisited: 4,
                    worldPercentage: 11.7,
                    totalTrips: 42,
                    favoritCountry: "Japan",
                    nextMilestone: "Visit 25 countries"
                )
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            PinnedWidgetEntryView(entry: TravelStatsEntry(
                date: Date(),
                stats: TravelStats(
                    countriesVisited: 23,
                    continentsVisited: 4,
                    worldPercentage: 11.7,
                    totalTrips: 42,
                    favoritCountry: "Japan",
                    nextMilestone: "Visit 25 countries"
                )
            ))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}