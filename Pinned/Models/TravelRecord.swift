import Foundation
import CoreLocation

// Detailed record for each place visited
struct TravelRecord: Identifiable, Codable {
    var id = UUID()
    let placeType: PlaceType
    let name: String
    let country: String
    let continent: String
    let coordinates: Coordinates
    let visitDate: Date
    let endDate: Date? // For trips with duration
    let rating: Int // 1-5
    let tripType: TripType
    let companions: [String]
    let budget: Double?
    let notes: String
    let photos: [String] // Photo IDs
    let weather: Weather?
    let activities: [Activity]
    let accommodation: String?
    let highlights: [String]
    let wouldRevisit: Bool
    let tags: [String]
    
    var duration: Int {
        guard let endDate = endDate else { return 1 }
        return Calendar.current.dateComponents([.day], from: visitDate, to: endDate).day ?? 1
    }
    
    var year: Int {
        Calendar.current.component(.year, from: visitDate)
    }
    
    var month: Int {
        Calendar.current.component(.month, from: visitDate)
    }
    
    var monthName: String {
        visitDate.formatted(.dateTime.month(.wide))
    }
    
    var season: Season {
        switch month {
        case 12, 1, 2: return .winter
        case 3, 4, 5: return .spring
        case 6, 7, 8: return .summer
        case 9, 10, 11: return .fall
        default: return .summer
        }
    }
}

enum PlaceType: String, Codable, CaseIterable {
    case country = "Country"
    case city = "City"
    case island = "Island"
    case region = "Region"
    case landmark = "Landmark"
}

enum TripType: String, Codable, CaseIterable {
    case leisure = "Leisure"
    case business = "Business"
    case adventure = "Adventure"
    case cultural = "Cultural"
    case beach = "Beach"
    case cityBreak = "City Break"
    case roadTrip = "Road Trip"
    case backpacking = "Backpacking"
    case luxury = "Luxury"
    case festival = "Festival"
    case wedding = "Wedding"
    case familyVisit = "Family Visit"
    case honeymoon = "Honeymoon"
    case solo = "Solo"
    case group = "Group"
    case couple = "Couple"
}

enum Weather: String, Codable, CaseIterable {
    case sunny = "Sunny"
    case rainy = "Rainy"
    case cloudy = "Cloudy"
    case snowy = "Snowy"
    case hot = "Hot"
    case cold = "Cold"
    case perfect = "Perfect"
    case mixed = "Mixed"
}

enum Activity: String, Codable, CaseIterable {
    case hiking = "Hiking"
    case swimming = "Swimming"
    case diving = "Diving"
    case skiing = "Skiing"
    case surfing = "Surfing"
    case sightseeing = "Sightseeing"
    case foodTour = "Food Tour"
    case museum = "Museum"
    case nightlife = "Nightlife"
    case shopping = "Shopping"
    case relaxing = "Relaxing"
    case photography = "Photography"
    case wildlife = "Wildlife"
    case culture = "Culture"
    case adventure = "Adventure"
    case wellness = "Wellness"
    case festival = "Festival"
    case sports = "Sports"
}

enum Season: String, CaseIterable {
    case spring = "Spring"
    case summer = "Summer"
    case fall = "Fall"
    case winter = "Winter"
}

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// Places where user has lived
struct LivedPlace: Identifiable, Codable {
    var id = UUID()
    let city: String
    let country: String
    let startDate: Date
    let endDate: Date?
    let isPrimary: Bool
    let notes: String
    
    var duration: String {
        let start = startDate.formatted(.dateTime.year().month())
        if let end = endDate {
            let endStr = end.formatted(.dateTime.year().month())
            return "\(start) - \(endStr)"
        } else {
            return "\(start) - Present"
        }
    }
    
    var years: Double {
        let end = endDate ?? Date()
        let days = Calendar.current.dateComponents([.day], from: startDate, to: end).day ?? 0
        return Double(days) / 365.25
    }
}

// Travel statistics aggregation
struct TravelStats {
    let records: [TravelRecord]
    let livedPlaces: [LivedPlace]
    
    // Basic counts
    var totalCountries: Int {
        Set(records.map { $0.country }).count
    }
    
    var totalCities: Int {
        records.filter { $0.placeType == .city }.count
    }
    
    var totalIslands: Int {
        records.filter { $0.placeType == .island }.count
    }
    
    var continentsVisited: Set<String> {
        Set(records.map { $0.continent })
    }
    
    var continentCount: Int {
        continentsVisited.count
    }
    
    // Time-based stats
    var totalDaysTravel: Int {
        records.reduce(0) { $0 + $1.duration }
    }
    
    var yearsOfTravel: Int {
        guard let firstTrip = records.min(by: { $0.visitDate < $1.visitDate }) else { return 0 }
        return Calendar.current.dateComponents([.year], from: firstTrip.visitDate, to: Date()).year ?? 0
    }
    
    var monthsMostTraveled: [(month: String, count: Int)] {
        let monthCounts = Dictionary(grouping: records) { $0.monthName }
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
        return monthCounts.map { (month: $0.key, count: $0.value) }
    }
    
    var yearlyBreakdown: [(year: Int, count: Int, countries: Set<String>)] {
        let grouped = Dictionary(grouping: records) { $0.year }
        return grouped.map { year, records in
            (year: year, 
             count: records.count,
             countries: Set(records.map { $0.country }))
        }.sorted { $0.year > $1.year }
    }
    
    // Travel style analysis
    var favoriteActivities: [(activity: Activity, count: Int)] {
        let allActivities = records.flatMap { $0.activities }
        let counts = Dictionary(allActivities.map { ($0, 1) }, uniquingKeysWith: +)
        return counts.sorted { $0.value > $1.value }.map { (activity: $0.key, count: $0.value) }
    }
    
    var tripTypeBreakdown: [(type: TripType, percentage: Double)] {
        let types = Dictionary(grouping: records) { $0.tripType }
        let total = Double(records.count)
        return types.map { type, records in
            (type: type, percentage: (Double(records.count) / total) * 100)
        }.sorted { $0.percentage > $1.percentage }
    }
    
    var averageRating: Double {
        guard !records.isEmpty else { return 0 }
        let totalRating = records.reduce(0) { $0 + $1.rating }
        return Double(totalRating) / Double(records.count)
    }
    
    var topRatedPlaces: [TravelRecord] {
        records.filter { $0.rating == 5 }.sorted { $0.visitDate > $1.visitDate }
    }
    
    // Fun statistics
    var distanceTraveled: Double {
        // Calculate total distance between all places visited
        var totalDistance: Double = 0
        let sortedRecords = records.sorted { $0.visitDate < $1.visitDate }
        
        for i in 1..<sortedRecords.count {
            let from = sortedRecords[i-1].coordinates.location
            let to = sortedRecords[i].coordinates.location
            let distance = from.distance(from: to) / 1000 // Convert to km
            totalDistance += distance
        }
        
        return totalDistance
    }
    
    var timesAroundWorld: Double {
        let earthCircumference = 40075.0 // km
        return distanceTraveled / earthCircumference
    }
    
    var distanceToSun: Double {
        let earthToSun = 149597870.7 // km
        return distanceTraveled / earthToSun
    }
    
    var monthsLivedAbroad: Int {
        let totalMonths = livedPlaces.reduce(0) { total, place in
            let end = place.endDate ?? Date()
            let months = Calendar.current.dateComponents([.month], from: place.startDate, to: end).month ?? 0
            return total + months
        }
        return totalMonths
    }
    
    // Unique insights
    var mostVisitedCountry: (country: String, visits: Int)? {
        let countryCounts = Dictionary(grouping: records) { $0.country }
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .first
        
        return countryCounts.map { (country: $0.key, visits: $0.value) }
    }
    
    var longestTrip: TravelRecord? {
        records.max { $0.duration < $1.duration }
    }
    
    var shortestTrip: TravelRecord? {
        records.min { $0.duration < $1.duration }
    }
    
    var busiestTravelYear: (year: Int, trips: Int)? {
        yearlyBreakdown.max { $0.count < $1.count }.map { (year: $0.year, trips: $0.count) }
    }
    
    var favoriteCompanions: [(companion: String, trips: Int)] {
        let allCompanions = records.flatMap { $0.companions }
        let counts = Dictionary(allCompanions.map { ($0, 1) }, uniquingKeysWith: +)
        return counts.sorted { $0.value > $1.value }.map { (companion: $0.key, trips: $0.value) }
    }
}

extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> Double {
        let earthRadius = 6371000.0 // meters
        let dLat = (from.latitude - self.latitude) * .pi / 180
        let dLon = (from.longitude - self.longitude) * .pi / 180
        let a = sin(dLat/2) * sin(dLat/2) +
                cos(self.latitude * .pi / 180) * cos(from.latitude * .pi / 180) *
                sin(dLon/2) * sin(dLon/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        return earthRadius * c
    }
}