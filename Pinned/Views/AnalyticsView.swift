import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject var travelData: TravelData
    @State private var selectedTab = 0
    
    var stats: TravelStats {
        travelData.stats
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Hero Stats
                    HeroStatsSection(stats: stats)
                    
                    // Travel Timeline
                    TimelineSection(stats: stats)
                    
                    // Monthly Trends
                    MonthlyTrendsSection(stats: stats)
                    
                    // Yearly Breakdown
                    YearlyBreakdownSection(stats: stats)
                    
                    // Travel Style Analysis
                    TravelStyleSection(stats: stats)
                    
                    // Fun Facts
                    FunFactsSection(stats: stats)
                    
                    // Places Lived
                    if !travelData.livedPlaces.isEmpty {
                        LivedPlacesSection(places: travelData.livedPlaces)
                    }
                    
                    // Top Rated Places
                    if !stats.topRatedPlaces.isEmpty {
                        TopRatedSection(places: stats.topRatedPlaces)
                    }
                }
                .padding(.bottom, 50)
            }
            .navigationTitle("Travel Analytics")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HeroStatsSection: View {
    let stats: TravelStats
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Your Travel Universe")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(hex: "FF0080"))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                AnalyticsStatCard(
                    value: "\(stats.totalCountries)",
                    label: "Countries",
                    icon: "globe",
                    color: Color(hex: "FF0080")
                )
                
                AnalyticsStatCard(
                    value: "\(stats.totalCities)",
                    label: "Cities",
                    icon: "building.2",
                    color: Color(hex: "0080FF")
                )
                
                AnalyticsStatCard(
                    value: "\(stats.continentCount)/7",
                    label: "Continents",
                    icon: "map",
                    color: Color(hex: "00FF80")
                )
                
                AnalyticsStatCard(
                    value: "\(stats.totalIslands)",
                    label: "Islands",
                    icon: "leaf",
                    color: Color(hex: "FF8000")
                )
            }
            .padding(.horizontal)
            
            // Distance Stats
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "airplane")
                        .font(.title2)
                        .foregroundColor(Color(hex: "FF0080"))
                    
                    Text("\(Int(stats.distanceTraveled)) km traveled")
                        .font(.system(size: 20, weight: .medium))
                }
                
                Text("That's \(String(format: "%.2f", stats.timesAroundWorld)) times around the world! 🌍")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                
                Text("Or \(String(format: "%.4f%%", stats.distanceToSun * 100)) of the way to the sun ☀️")
                    .font(.system(size: 12))
                    .foregroundColor(.gray.opacity(0.8))
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

struct TimelineSection: View {
    let stats: TravelStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Travel Timeline")
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal)
            
            VStack(spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Years of Travel")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(stats.yearsOfTravel) years")
                            .font(.title2.bold())
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Total Days")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(stats.totalDaysTravel) days")
                            .font(.title2.bold())
                    }
                }
                
                if let busiestYear = stats.busiestTravelYear {
                    HStack {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                        Text("Busiest year: \(busiestYear.year) with \(busiestYear.trips) trips")
                            .font(.system(size: 14, weight: .medium))
                    }
                }
                
                if let longestTrip = stats.longestTrip {
                    HStack {
                        Image(systemName: "timer")
                            .foregroundColor(Color(hex: "0080FF"))
                        Text("Longest trip: \(longestTrip.duration) days in \(longestTrip.name)")
                            .font(.system(size: 14, weight: .medium))
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

struct MonthlyTrendsSection: View {
    let stats: TravelStats
    
    var monthData: [(month: String, count: Int)] {
        let allMonths = ["January", "February", "March", "April", "May", "June", 
                        "July", "August", "September", "October", "November", "December"]
        
        return allMonths.map { month in
            let count = stats.monthsMostTraveled.first(where: { $0.month == month })?.count ?? 0
            return (month: String(month.prefix(3)), count: count)
        }
    }
    
    var maxCount: Int {
        monthData.map { $0.count }.max() ?? 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Monthly Travel Patterns")
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal)
            
            // Custom Bar Chart
            VStack(spacing: 0) {
                // Chart Area
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(monthData, id: \.month) { item in
                        VStack {
                            Spacer()
                            
                            // Bar
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "FF0080"), Color(hex: "0080FF")],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(height: max(5, CGFloat(item.count) / CGFloat(maxCount) * 150))
                            
                            // Month label
                            Text(item.month)
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .frame(height: 20)
                            
                            // Count label
                            if item.count > 0 {
                                Text("\(item.count)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 200)
                .padding(.horizontal)
            }
            
            if let topMonth = stats.monthsMostTraveled.first {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(Color(hex: "FF0080"))
                    Text("You travel most in \(topMonth.month) (\(topMonth.count) trips)")
                        .font(.system(size: 14, weight: .medium))
                }
                .padding(.horizontal)
            }
        }
    }
}

struct YearlyBreakdownSection: View {
    let stats: TravelStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Yearly Adventures")
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(stats.yearlyBreakdown, id: \.year) { yearData in
                        YearCard(
                            year: yearData.year,
                            trips: yearData.count,
                            countries: yearData.countries.count
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct YearCard: View {
    let year: Int
    let trips: Int
    let countries: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Text("\(year)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(hex: "FF0080"))
            
            VStack(spacing: 5) {
                HStack {
                    Image(systemName: "airplane")
                        .font(.caption)
                    Text("\(trips) trips")
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "globe")
                        .font(.caption)
                    Text("\(countries) countries")
                        .font(.caption)
                }
            }
            .foregroundColor(.gray)
        }
        .frame(width: 120)
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

struct TravelStyleSection: View {
    let stats: TravelStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Your Travel Style")
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal)
            
            // Trip Types
            if !stats.tripTypeBreakdown.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Trip Types")
                        .font(.headline)
                    
                    ForEach(stats.tripTypeBreakdown.prefix(5), id: \.type) { item in
                        HStack {
                            Text(item.type.rawValue)
                                .font(.system(size: 14, weight: .medium))
                            
                            Spacer()
                            
                            ProgressView(value: item.percentage, total: 100)
                                .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "FF0080")))
                                .frame(width: 100)
                            
                            Text("\(Int(item.percentage))%")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .frame(width: 40, alignment: .trailing)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            
            // Activities
            if !stats.favoriteActivities.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Top Activities")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(stats.favoriteActivities.prefix(8), id: \.activity) { item in
                                ActivityChip(
                                    activity: item.activity.rawValue,
                                    count: item.count
                                )
                            }
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            
            // Average Rating
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Average trip rating: \(String(format: "%.1f", stats.averageRating))/5")
                    .font(.system(size: 16, weight: .medium))
            }
            .padding(.horizontal)
        }
    }
}

struct ActivityChip: View {
    let activity: String
    let count: Int
    
    var body: some View {
        VStack(spacing: 5) {
            Text(activity)
                .font(.system(size: 12, weight: .medium))
            Text("×\(count)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            LinearGradient(
                colors: [Color(hex: "FF0080").opacity(0.2), Color(hex: "0080FF").opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }
}

struct FunFactsSection: View {
    let stats: TravelStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Fun Facts")
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                if let mostVisited = stats.mostVisitedCountry {
                    FunFactRow(
                        icon: "heart.fill",
                        fact: "You've visited \(mostVisited.country) the most (\(mostVisited.visits) times)",
                        color: .red
                    )
                }
                
                if !stats.favoriteCompanions.isEmpty, let topCompanion = stats.favoriteCompanions.first {
                    FunFactRow(
                        icon: "person.2.fill",
                        fact: "Your favorite travel buddy is \(topCompanion.companion) (\(topCompanion.trips) trips)",
                        color: Color(hex: "0080FF")
                    )
                }
                
                if stats.continentCount == 7 {
                    FunFactRow(
                        icon: "globe.americas.fill",
                        fact: "You've been to ALL 7 continents! 🎉",
                        color: .green
                    )
                }
                
                if stats.totalCountries >= 100 {
                    FunFactRow(
                        icon: "flag.fill",
                        fact: "Century Club member! 100+ countries visited",
                        color: .purple
                    )
                } else if stats.totalCountries >= 50 {
                    FunFactRow(
                        icon: "flag",
                        fact: "Half century! \(100 - stats.totalCountries) countries until the Century Club",
                        color: .orange
                    )
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

struct FunFactRow: View {
    let icon: String
    let fact: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(fact)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

struct LivedPlacesSection: View {
    let places: [LivedPlace]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Places You've Called Home")
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal)
            
            ForEach(places) { place in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(place.city), \(place.country)")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text(place.duration)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        if place.isPrimary {
                            Label("Primary Residence", systemImage: "house.fill")
                                .font(.caption)
                                .foregroundColor(Color(hex: "FF0080"))
                        }
                    }
                    
                    Spacer()
                    
                    Text("\(String(format: "%.1f", place.years)) years")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
    }
}

struct TopRatedSection: View {
    let places: [TravelRecord]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Your 5-Star Destinations")
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(places.prefix(10)) { place in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(place.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(place.country)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            
                            HStack(spacing: 2) {
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.caption2)
                                        .foregroundColor(.yellow)
                                }
                            }
                            
                            Text(place.visitDate.formatted(.dateTime.year().month()))
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding()
                        .frame(width: 150)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "FF0080"), Color(hex: "FF4080")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct AnalyticsStatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(TravelData())
}