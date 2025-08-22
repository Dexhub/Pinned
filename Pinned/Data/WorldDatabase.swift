import Foundation
import CoreLocation

struct CountryInfo {
    let name: String
    let code: String
    let continent: Continent
    let capital: String
    let majorCities: [String]
    let coordinates: CLLocationCoordinate2D
    let currency: String
    let languages: [String]
    let population: Int
    let area: Double // in km²
    let timezone: String
    let hasIslands: Bool
}

enum Continent: String, CaseIterable {
    case northAmerica = "North America"
    case southAmerica = "South America"
    case europe = "Europe"
    case africa = "Africa"
    case asia = "Asia"
    case oceania = "Oceania"
    case antarctica = "Antarctica"
    
    var emoji: String {
        switch self {
        case .northAmerica: return "🌎"
        case .southAmerica: return "🌎"
        case .europe: return "🌍"
        case .africa: return "🌍"
        case .asia: return "🌏"
        case .oceania: return "🌏"
        case .antarctica: return "🧊"
        }
    }
}

struct WorldDatabase {
    static let countries: [CountryInfo] = [
        // North America
        CountryInfo(name: "United States", code: "US", continent: .northAmerica,
                   capital: "Washington D.C.", 
                   majorCities: ["New York", "Los Angeles", "Chicago", "Houston", "Phoenix", "Philadelphia", "San Antonio", "San Diego", "Dallas", "San Jose", "Austin", "Jacksonville", "San Francisco", "Seattle", "Denver", "Boston", "Miami", "Atlanta", "Las Vegas", "Portland"],
                   coordinates: CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129),
                   currency: "USD", languages: ["English"], population: 331002651, area: 9833517,
                   timezone: "Multiple", hasIslands: true),
        
        CountryInfo(name: "Canada", code: "CA", continent: .northAmerica,
                   capital: "Ottawa",
                   majorCities: ["Toronto", "Montreal", "Vancouver", "Calgary", "Edmonton", "Ottawa", "Winnipeg", "Quebec City", "Hamilton", "Halifax"],
                   coordinates: CLLocationCoordinate2D(latitude: 56.1304, longitude: -106.3468),
                   currency: "CAD", languages: ["English", "French"], population: 37742154, area: 9984670,
                   timezone: "Multiple", hasIslands: true),
        
        CountryInfo(name: "Mexico", code: "MX", continent: .northAmerica,
                   capital: "Mexico City",
                   majorCities: ["Mexico City", "Guadalajara", "Monterrey", "Puebla", "Tijuana", "León", "Juárez", "Zapopan", "Mérida", "Cancún", "Playa del Carmen", "Puerto Vallarta", "Oaxaca", "San Miguel de Allende"],
                   coordinates: CLLocationCoordinate2D(latitude: 23.6345, longitude: -102.5528),
                   currency: "MXN", languages: ["Spanish"], population: 128932753, area: 1964375,
                   timezone: "Multiple", hasIslands: true),
        
        // Europe
        CountryInfo(name: "United Kingdom", code: "GB", continent: .europe,
                   capital: "London",
                   majorCities: ["London", "Birmingham", "Glasgow", "Liverpool", "Manchester", "Sheffield", "Leeds", "Edinburgh", "Bristol", "Cardiff", "Belfast", "Newcastle", "Brighton", "Oxford", "Cambridge", "Bath", "York"],
                   coordinates: CLLocationCoordinate2D(latitude: 55.3781, longitude: -3.4360),
                   currency: "GBP", languages: ["English"], population: 67886011, area: 242495,
                   timezone: "GMT", hasIslands: true),
        
        CountryInfo(name: "France", code: "FR", continent: .europe,
                   capital: "Paris",
                   majorCities: ["Paris", "Marseille", "Lyon", "Toulouse", "Nice", "Nantes", "Strasbourg", "Montpellier", "Bordeaux", "Lille", "Rennes", "Reims", "Cannes", "Avignon", "Versailles"],
                   coordinates: CLLocationCoordinate2D(latitude: 46.2276, longitude: 2.2137),
                   currency: "EUR", languages: ["French"], population: 65273511, area: 643801,
                   timezone: "CET", hasIslands: true),
        
        CountryInfo(name: "Germany", code: "DE", continent: .europe,
                   capital: "Berlin",
                   majorCities: ["Berlin", "Hamburg", "Munich", "Cologne", "Frankfurt", "Stuttgart", "Düsseldorf", "Dortmund", "Essen", "Leipzig", "Dresden", "Heidelberg", "Nuremberg"],
                   coordinates: CLLocationCoordinate2D(latitude: 51.1657, longitude: 10.4515),
                   currency: "EUR", languages: ["German"], population: 83783942, area: 357022,
                   timezone: "CET", hasIslands: true),
        
        CountryInfo(name: "Italy", code: "IT", continent: .europe,
                   capital: "Rome",
                   majorCities: ["Rome", "Milan", "Naples", "Turin", "Florence", "Venice", "Bologna", "Genoa", "Palermo", "Verona", "Pisa", "Amalfi", "Cinque Terre", "Como", "Siena"],
                   coordinates: CLLocationCoordinate2D(latitude: 41.8719, longitude: 12.5674),
                   currency: "EUR", languages: ["Italian"], population: 60461826, area: 301340,
                   timezone: "CET", hasIslands: true),
        
        CountryInfo(name: "Spain", code: "ES", continent: .europe,
                   capital: "Madrid",
                   majorCities: ["Madrid", "Barcelona", "Valencia", "Seville", "Zaragoza", "Málaga", "Bilbao", "Granada", "Palma", "San Sebastián", "Córdoba", "Ibiza", "Toledo", "Santander"],
                   coordinates: CLLocationCoordinate2D(latitude: 40.4637, longitude: -3.7492),
                   currency: "EUR", languages: ["Spanish"], population: 46754778, area: 505370,
                   timezone: "CET", hasIslands: true),
        
        CountryInfo(name: "Portugal", code: "PT", continent: .europe,
                   capital: "Lisbon",
                   majorCities: ["Lisbon", "Porto", "Faro", "Coimbra", "Braga", "Funchal", "Sintra", "Lagos", "Cascais", "Évora"],
                   coordinates: CLLocationCoordinate2D(latitude: 39.3999, longitude: -8.2245),
                   currency: "EUR", languages: ["Portuguese"], population: 10196709, area: 92090,
                   timezone: "WET", hasIslands: true),
        
        CountryInfo(name: "Netherlands", code: "NL", continent: .europe,
                   capital: "Amsterdam",
                   majorCities: ["Amsterdam", "Rotterdam", "The Hague", "Utrecht", "Eindhoven", "Groningen", "Maastricht", "Delft", "Haarlem", "Nijmegen"],
                   coordinates: CLLocationCoordinate2D(latitude: 52.1326, longitude: 5.2913),
                   currency: "EUR", languages: ["Dutch"], population: 17134872, area: 41543,
                   timezone: "CET", hasIslands: false),
        
        CountryInfo(name: "Belgium", code: "BE", continent: .europe,
                   capital: "Brussels",
                   majorCities: ["Brussels", "Antwerp", "Ghent", "Bruges", "Liège", "Leuven", "Namur", "Mechelen"],
                   coordinates: CLLocationCoordinate2D(latitude: 50.5039, longitude: 4.4699),
                   currency: "EUR", languages: ["Dutch", "French", "German"], population: 11589623, area: 30528,
                   timezone: "CET", hasIslands: false),
        
        CountryInfo(name: "Switzerland", code: "CH", continent: .europe,
                   capital: "Bern",
                   majorCities: ["Zurich", "Geneva", "Basel", "Bern", "Lausanne", "Lucerne", "Interlaken", "Zermatt", "St. Moritz", "Lugano"],
                   coordinates: CLLocationCoordinate2D(latitude: 46.8182, longitude: 8.2275),
                   currency: "CHF", languages: ["German", "French", "Italian", "Romansh"], population: 8654622, area: 41277,
                   timezone: "CET", hasIslands: false),
        
        CountryInfo(name: "Austria", code: "AT", continent: .europe,
                   capital: "Vienna",
                   majorCities: ["Vienna", "Graz", "Linz", "Salzburg", "Innsbruck", "Klagenfurt", "Villach", "Hallstatt"],
                   coordinates: CLLocationCoordinate2D(latitude: 47.5162, longitude: 14.5501),
                   currency: "EUR", languages: ["German"], population: 9006398, area: 83879,
                   timezone: "CET", hasIslands: false),
        
        CountryInfo(name: "Greece", code: "GR", continent: .europe,
                   capital: "Athens",
                   majorCities: ["Athens", "Thessaloniki", "Patras", "Heraklion", "Rhodes", "Mykonos", "Santorini", "Corfu", "Chania", "Zakynthos"],
                   coordinates: CLLocationCoordinate2D(latitude: 39.0742, longitude: 21.8243),
                   currency: "EUR", languages: ["Greek"], population: 10423054, area: 131957,
                   timezone: "EET", hasIslands: true),
        
        CountryInfo(name: "Poland", code: "PL", continent: .europe,
                   capital: "Warsaw",
                   majorCities: ["Warsaw", "Kraków", "Łódź", "Wrocław", "Poznań", "Gdańsk", "Szczecin", "Lublin", "Katowice", "Białystok"],
                   coordinates: CLLocationCoordinate2D(latitude: 51.9194, longitude: 19.1451),
                   currency: "PLN", languages: ["Polish"], population: 37846611, area: 312685,
                   timezone: "CET", hasIslands: false),
        
        CountryInfo(name: "Czech Republic", code: "CZ", continent: .europe,
                   capital: "Prague",
                   majorCities: ["Prague", "Brno", "Ostrava", "Plzeň", "České Budějovice", "Karlovy Vary", "Český Krumlov"],
                   coordinates: CLLocationCoordinate2D(latitude: 49.8175, longitude: 15.4730),
                   currency: "CZK", languages: ["Czech"], population: 10708981, area: 78867,
                   timezone: "CET", hasIslands: false),
        
        CountryInfo(name: "Hungary", code: "HU", continent: .europe,
                   capital: "Budapest",
                   majorCities: ["Budapest", "Debrecen", "Szeged", "Miskolc", "Pécs", "Győr", "Eger"],
                   coordinates: CLLocationCoordinate2D(latitude: 47.1625, longitude: 19.5033),
                   currency: "HUF", languages: ["Hungarian"], population: 9660351, area: 93028,
                   timezone: "CET", hasIslands: false),
        
        CountryInfo(name: "Norway", code: "NO", continent: .europe,
                   capital: "Oslo",
                   majorCities: ["Oslo", "Bergen", "Trondheim", "Stavanger", "Tromsø", "Ålesund", "Fredrikstad", "Drammen"],
                   coordinates: CLLocationCoordinate2D(latitude: 60.4720, longitude: 8.4689),
                   currency: "NOK", languages: ["Norwegian"], population: 5421241, area: 323802,
                   timezone: "CET", hasIslands: true),
        
        CountryInfo(name: "Sweden", code: "SE", continent: .europe,
                   capital: "Stockholm",
                   majorCities: ["Stockholm", "Gothenburg", "Malmö", "Uppsala", "Västerås", "Örebro", "Linköping"],
                   coordinates: CLLocationCoordinate2D(latitude: 60.1282, longitude: 18.6435),
                   currency: "SEK", languages: ["Swedish"], population: 10099265, area: 450295,
                   timezone: "CET", hasIslands: true),
        
        CountryInfo(name: "Denmark", code: "DK", continent: .europe,
                   capital: "Copenhagen",
                   majorCities: ["Copenhagen", "Aarhus", "Odense", "Aalborg", "Esbjerg", "Randers", "Kolding"],
                   coordinates: CLLocationCoordinate2D(latitude: 56.2639, longitude: 9.5018),
                   currency: "DKK", languages: ["Danish"], population: 5792202, area: 43094,
                   timezone: "CET", hasIslands: true),
        
        CountryInfo(name: "Finland", code: "FI", continent: .europe,
                   capital: "Helsinki",
                   majorCities: ["Helsinki", "Espoo", "Tampere", "Vantaa", "Oulu", "Turku", "Jyväskylä", "Rovaniemi"],
                   coordinates: CLLocationCoordinate2D(latitude: 61.9241, longitude: 25.7482),
                   currency: "EUR", languages: ["Finnish", "Swedish"], population: 5540720, area: 338145,
                   timezone: "EET", hasIslands: true),
        
        CountryInfo(name: "Iceland", code: "IS", continent: .europe,
                   capital: "Reykjavik",
                   majorCities: ["Reykjavik", "Kópavogur", "Hafnarfjörður", "Akureyri", "Keflavík", "Selfoss"],
                   coordinates: CLLocationCoordinate2D(latitude: 64.9631, longitude: -19.0208),
                   currency: "ISK", languages: ["Icelandic"], population: 341243, area: 103000,
                   timezone: "GMT", hasIslands: true),
        
        CountryInfo(name: "Ireland", code: "IE", continent: .europe,
                   capital: "Dublin",
                   majorCities: ["Dublin", "Cork", "Galway", "Limerick", "Waterford", "Kilkenny", "Killarney"],
                   coordinates: CLLocationCoordinate2D(latitude: 53.1424, longitude: -7.6921),
                   currency: "EUR", languages: ["English", "Irish"], population: 4937786, area: 70273,
                   timezone: "GMT", hasIslands: true),
        
        CountryInfo(name: "Croatia", code: "HR", continent: .europe,
                   capital: "Zagreb",
                   majorCities: ["Zagreb", "Split", "Dubrovnik", "Rijeka", "Zadar", "Pula", "Hvar", "Rovinj"],
                   coordinates: CLLocationCoordinate2D(latitude: 45.1000, longitude: 15.2000),
                   currency: "HRK", languages: ["Croatian"], population: 4105267, area: 56594,
                   timezone: "CET", hasIslands: true),
        
        CountryInfo(name: "Serbia", code: "RS", continent: .europe,
                   capital: "Belgrade",
                   majorCities: ["Belgrade", "Novi Sad", "Niš", "Kragujevac", "Subotica"],
                   coordinates: CLLocationCoordinate2D(latitude: 44.0165, longitude: 21.0059),
                   currency: "RSD", languages: ["Serbian"], population: 8737371, area: 77474,
                   timezone: "CET", hasIslands: false),
        
        CountryInfo(name: "Romania", code: "RO", continent: .europe,
                   capital: "Bucharest",
                   majorCities: ["Bucharest", "Cluj-Napoca", "Timișoara", "Iași", "Constanța", "Brașov", "Sibiu"],
                   coordinates: CLLocationCoordinate2D(latitude: 45.9432, longitude: 24.9668),
                   currency: "RON", languages: ["Romanian"], population: 19237691, area: 238391,
                   timezone: "EET", hasIslands: false),
        
        CountryInfo(name: "Bulgaria", code: "BG", continent: .europe,
                   capital: "Sofia",
                   majorCities: ["Sofia", "Plovdiv", "Varna", "Burgas", "Ruse", "Stara Zagora"],
                   coordinates: CLLocationCoordinate2D(latitude: 42.7339, longitude: 25.4858),
                   currency: "BGN", languages: ["Bulgarian"], population: 6948445, area: 110879,
                   timezone: "EET", hasIslands: false),
        
        CountryInfo(name: "Ukraine", code: "UA", continent: .europe,
                   capital: "Kyiv",
                   majorCities: ["Kyiv", "Kharkiv", "Odesa", "Dnipro", "Donetsk", "Zaporizhzhia", "Lviv"],
                   coordinates: CLLocationCoordinate2D(latitude: 48.3794, longitude: 31.1656),
                   currency: "UAH", languages: ["Ukrainian"], population: 43733762, area: 603550,
                   timezone: "EET", hasIslands: false),
        
        CountryInfo(name: "Russia", code: "RU", continent: .europe,
                   capital: "Moscow",
                   majorCities: ["Moscow", "Saint Petersburg", "Novosibirsk", "Yekaterinburg", "Nizhny Novgorod", "Kazan", "Samara", "Sochi", "Vladivostok"],
                   coordinates: CLLocationCoordinate2D(latitude: 61.5240, longitude: 105.3188),
                   currency: "RUB", languages: ["Russian"], population: 145934462, area: 17098242,
                   timezone: "Multiple", hasIslands: true),
        
        // Asia
        CountryInfo(name: "China", code: "CN", continent: .asia,
                   capital: "Beijing",
                   majorCities: ["Beijing", "Shanghai", "Guangzhou", "Shenzhen", "Chengdu", "Hong Kong", "Xi'an", "Hangzhou", "Chongqing", "Wuhan", "Suzhou", "Nanjing", "Tianjin", "Harbin", "Guilin"],
                   coordinates: CLLocationCoordinate2D(latitude: 35.8617, longitude: 104.1954),
                   currency: "CNY", languages: ["Chinese"], population: 1439323776, area: 9596960,
                   timezone: "CST", hasIslands: true),
        
        CountryInfo(name: "Japan", code: "JP", continent: .asia,
                   capital: "Tokyo",
                   majorCities: ["Tokyo", "Osaka", "Kyoto", "Yokohama", "Nagoya", "Sapporo", "Kobe", "Fukuoka", "Hiroshima", "Sendai", "Nara", "Kamakura", "Nikko", "Hakone"],
                   coordinates: CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529),
                   currency: "JPY", languages: ["Japanese"], population: 126476461, area: 377975,
                   timezone: "JST", hasIslands: true),
        
        CountryInfo(name: "South Korea", code: "KR", continent: .asia,
                   capital: "Seoul",
                   majorCities: ["Seoul", "Busan", "Incheon", "Daegu", "Daejeon", "Gwangju", "Jeju City", "Gyeongju"],
                   coordinates: CLLocationCoordinate2D(latitude: 35.9078, longitude: 127.7669),
                   currency: "KRW", languages: ["Korean"], population: 51269185, area: 100210,
                   timezone: "KST", hasIslands: true),
        
        CountryInfo(name: "India", code: "IN", continent: .asia,
                   capital: "New Delhi",
                   majorCities: ["Mumbai", "Delhi", "Bangalore", "Hyderabad", "Chennai", "Kolkata", "Ahmedabad", "Pune", "Jaipur", "Goa", "Kerala", "Agra", "Varanasi", "Udaipur", "Rishikesh"],
                   coordinates: CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629),
                   currency: "INR", languages: ["Hindi", "English"], population: 1380004385, area: 3287263,
                   timezone: "IST", hasIslands: true),
        
        CountryInfo(name: "Thailand", code: "TH", continent: .asia,
                   capital: "Bangkok",
                   majorCities: ["Bangkok", "Chiang Mai", "Phuket", "Pattaya", "Krabi", "Koh Samui", "Ayutthaya", "Hua Hin", "Koh Phi Phi", "Pai", "Koh Tao", "Chiang Rai"],
                   coordinates: CLLocationCoordinate2D(latitude: 15.8700, longitude: 100.9925),
                   currency: "THB", languages: ["Thai"], population: 69799978, area: 513120,
                   timezone: "ICT", hasIslands: true),
        
        CountryInfo(name: "Vietnam", code: "VN", continent: .asia,
                   capital: "Hanoi",
                   majorCities: ["Ho Chi Minh City", "Hanoi", "Da Nang", "Hoi An", "Nha Trang", "Hue", "Ha Long", "Sapa", "Phu Quoc", "Da Lat"],
                   coordinates: CLLocationCoordinate2D(latitude: 14.0583, longitude: 108.2772),
                   currency: "VND", languages: ["Vietnamese"], population: 97338579, area: 331212,
                   timezone: "ICT", hasIslands: true),
        
        CountryInfo(name: "Indonesia", code: "ID", continent: .asia,
                   capital: "Jakarta",
                   majorCities: ["Jakarta", "Bali", "Yogyakarta", "Bandung", "Surabaya", "Medan", "Lombok", "Gili Islands", "Ubud", "Seminyak", "Nusa Dua", "Flores"],
                   coordinates: CLLocationCoordinate2D(latitude: -0.7893, longitude: 113.9213),
                   currency: "IDR", languages: ["Indonesian"], population: 273523615, area: 1904569,
                   timezone: "Multiple", hasIslands: true),
        
        CountryInfo(name: "Malaysia", code: "MY", continent: .asia,
                   capital: "Kuala Lumpur",
                   majorCities: ["Kuala Lumpur", "George Town", "Malacca", "Ipoh", "Johor Bahru", "Kota Kinabalu", "Langkawi", "Cameron Highlands"],
                   coordinates: CLLocationCoordinate2D(latitude: 4.2105, longitude: 101.9758),
                   currency: "MYR", languages: ["Malay"], population: 32365999, area: 329847,
                   timezone: "MYT", hasIslands: true),
        
        CountryInfo(name: "Singapore", code: "SG", continent: .asia,
                   capital: "Singapore",
                   majorCities: ["Singapore", "Sentosa", "Jurong", "Woodlands", "Tampines"],
                   coordinates: CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198),
                   currency: "SGD", languages: ["English", "Malay", "Chinese", "Tamil"], population: 5850342, area: 728,
                   timezone: "SGT", hasIslands: true),
        
        CountryInfo(name: "Philippines", code: "PH", continent: .asia,
                   capital: "Manila",
                   majorCities: ["Manila", "Cebu City", "Davao City", "Boracay", "Palawan", "Siargao", "Bohol", "El Nido", "Coron"],
                   coordinates: CLLocationCoordinate2D(latitude: 12.8797, longitude: 121.7740),
                   currency: "PHP", languages: ["Filipino", "English"], population: 109581078, area: 300000,
                   timezone: "PHT", hasIslands: true),
        
        CountryInfo(name: "Turkey", code: "TR", continent: .asia,
                   capital: "Ankara",
                   majorCities: ["Istanbul", "Ankara", "Izmir", "Antalya", "Bursa", "Bodrum", "Cappadocia", "Pamukkale", "Ephesus", "Fethiye"],
                   coordinates: CLLocationCoordinate2D(latitude: 38.9637, longitude: 35.2433),
                   currency: "TRY", languages: ["Turkish"], population: 84339067, area: 783562,
                   timezone: "TRT", hasIslands: true),
        
        CountryInfo(name: "Israel", code: "IL", continent: .asia,
                   capital: "Jerusalem",
                   majorCities: ["Tel Aviv", "Jerusalem", "Haifa", "Eilat", "Nazareth", "Bethlehem", "Dead Sea", "Masada"],
                   coordinates: CLLocationCoordinate2D(latitude: 31.0461, longitude: 34.8516),
                   currency: "ILS", languages: ["Hebrew", "Arabic"], population: 8655535, area: 20770,
                   timezone: "IST", hasIslands: false),
        
        CountryInfo(name: "United Arab Emirates", code: "AE", continent: .asia,
                   capital: "Abu Dhabi",
                   majorCities: ["Dubai", "Abu Dhabi", "Sharjah", "Ajman", "Ras Al Khaimah", "Fujairah", "Al Ain"],
                   coordinates: CLLocationCoordinate2D(latitude: 23.4241, longitude: 53.8478),
                   currency: "AED", languages: ["Arabic"], population: 9890402, area: 83600,
                   timezone: "GST", hasIslands: true),
        
        CountryInfo(name: "Saudi Arabia", code: "SA", continent: .asia,
                   capital: "Riyadh",
                   majorCities: ["Riyadh", "Jeddah", "Mecca", "Medina", "Dammam", "Al Khobar"],
                   coordinates: CLLocationCoordinate2D(latitude: 23.8859, longitude: 45.0792),
                   currency: "SAR", languages: ["Arabic"], population: 34813871, area: 2149690,
                   timezone: "AST", hasIslands: true),
        
        CountryInfo(name: "Iran", code: "IR", continent: .asia,
                   capital: "Tehran",
                   majorCities: ["Tehran", "Isfahan", "Shiraz", "Mashhad", "Tabriz", "Yazd", "Kerman"],
                   coordinates: CLLocationCoordinate2D(latitude: 32.4279, longitude: 53.6880),
                   currency: "IRR", languages: ["Persian"], population: 83992949, area: 1648195,
                   timezone: "IRST", hasIslands: true),
        
        CountryInfo(name: "Pakistan", code: "PK", continent: .asia,
                   capital: "Islamabad",
                   majorCities: ["Karachi", "Lahore", "Islamabad", "Faisalabad", "Rawalpindi", "Multan"],
                   coordinates: CLLocationCoordinate2D(latitude: 30.3753, longitude: 69.3451),
                   currency: "PKR", languages: ["Urdu", "English"], population: 220892340, area: 796095,
                   timezone: "PKT", hasIslands: false),
        
        CountryInfo(name: "Bangladesh", code: "BD", continent: .asia,
                   capital: "Dhaka",
                   majorCities: ["Dhaka", "Chittagong", "Khulna", "Rajshahi", "Sylhet", "Cox's Bazar"],
                   coordinates: CLLocationCoordinate2D(latitude: 23.6850, longitude: 90.3563),
                   currency: "BDT", languages: ["Bengali"], population: 164689383, area: 147570,
                   timezone: "BST", hasIslands: true),
        
        CountryInfo(name: "Sri Lanka", code: "LK", continent: .asia,
                   capital: "Colombo",
                   majorCities: ["Colombo", "Kandy", "Galle", "Sigiriya", "Ella", "Mirissa", "Nuwara Eliya"],
                   coordinates: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
                   currency: "LKR", languages: ["Sinhala", "Tamil"], population: 21413249, area: 65610,
                   timezone: "SLST", hasIslands: true),
        
        CountryInfo(name: "Nepal", code: "NP", continent: .asia,
                   capital: "Kathmandu",
                   majorCities: ["Kathmandu", "Pokhara", "Patan", "Bhaktapur", "Lumbini", "Chitwan"],
                   coordinates: CLLocationCoordinate2D(latitude: 28.3949, longitude: 84.1240),
                   currency: "NPR", languages: ["Nepali"], population: 29136808, area: 147181,
                   timezone: "NPT", hasIslands: false),
        
        CountryInfo(name: "Myanmar", code: "MM", continent: .asia,
                   capital: "Naypyidaw",
                   majorCities: ["Yangon", "Mandalay", "Naypyidaw", "Bagan", "Inle Lake", "Ngapali"],
                   coordinates: CLLocationCoordinate2D(latitude: 21.9162, longitude: 95.9560),
                   currency: "MMK", languages: ["Burmese"], population: 54409800, area: 676578,
                   timezone: "MMT", hasIslands: true),
        
        CountryInfo(name: "Cambodia", code: "KH", continent: .asia,
                   capital: "Phnom Penh",
                   majorCities: ["Phnom Penh", "Siem Reap", "Sihanoukville", "Battambang", "Kampot", "Kep"],
                   coordinates: CLLocationCoordinate2D(latitude: 12.5657, longitude: 104.9910),
                   currency: "KHR", languages: ["Khmer"], population: 16718965, area: 181035,
                   timezone: "ICT", hasIslands: true),
        
        CountryInfo(name: "Laos", code: "LA", continent: .asia,
                   capital: "Vientiane",
                   majorCities: ["Vientiane", "Luang Prabang", "Pakse", "Vang Vieng", "Savannakhet"],
                   coordinates: CLLocationCoordinate2D(latitude: 19.8563, longitude: 102.4955),
                   currency: "LAK", languages: ["Lao"], population: 7275560, area: 236800,
                   timezone: "ICT", hasIslands: false),
        
        // Africa
        CountryInfo(name: "Egypt", code: "EG", continent: .africa,
                   capital: "Cairo",
                   majorCities: ["Cairo", "Alexandria", "Giza", "Luxor", "Aswan", "Sharm El Sheikh", "Hurghada", "Dahab"],
                   coordinates: CLLocationCoordinate2D(latitude: 26.8206, longitude: 30.8025),
                   currency: "EGP", languages: ["Arabic"], population: 102334404, area: 1001450,
                   timezone: "EET", hasIslands: true),
        
        CountryInfo(name: "South Africa", code: "ZA", continent: .africa,
                   capital: "Pretoria",
                   majorCities: ["Cape Town", "Johannesburg", "Durban", "Pretoria", "Port Elizabeth", "Kruger", "Stellenbosch", "Hermanus"],
                   coordinates: CLLocationCoordinate2D(latitude: -30.5595, longitude: 22.9375),
                   currency: "ZAR", languages: ["English", "Afrikaans", "Zulu"], population: 59308690, area: 1219090,
                   timezone: "SAST", hasIslands: true),
        
        CountryInfo(name: "Morocco", code: "MA", continent: .africa,
                   capital: "Rabat",
                   majorCities: ["Marrakech", "Casablanca", "Fez", "Rabat", "Chefchaouen", "Essaouira", "Tangier", "Agadir"],
                   coordinates: CLLocationCoordinate2D(latitude: 31.7917, longitude: -7.0926),
                   currency: "MAD", languages: ["Arabic", "Berber"], population: 36910560, area: 446550,
                   timezone: "WET", hasIslands: false),
        
        CountryInfo(name: "Kenya", code: "KE", continent: .africa,
                   capital: "Nairobi",
                   majorCities: ["Nairobi", "Mombasa", "Kisumu", "Nakuru", "Malindi", "Lamu", "Diani Beach"],
                   coordinates: CLLocationCoordinate2D(latitude: -0.0236, longitude: 37.9062),
                   currency: "KES", languages: ["English", "Swahili"], population: 53771296, area: 580367,
                   timezone: "EAT", hasIslands: true),
        
        CountryInfo(name: "Tanzania", code: "TZ", continent: .africa,
                   capital: "Dodoma",
                   majorCities: ["Dar es Salaam", "Arusha", "Dodoma", "Mwanza", "Zanzibar", "Stone Town", "Moshi"],
                   coordinates: CLLocationCoordinate2D(latitude: -6.3690, longitude: 34.8888),
                   currency: "TZS", languages: ["Swahili", "English"], population: 59734218, area: 947303,
                   timezone: "EAT", hasIslands: true),
        
        CountryInfo(name: "Ethiopia", code: "ET", continent: .africa,
                   capital: "Addis Ababa",
                   majorCities: ["Addis Ababa", "Gondar", "Lalibela", "Bahir Dar", "Harar", "Axum"],
                   coordinates: CLLocationCoordinate2D(latitude: 9.1450, longitude: 40.4897),
                   currency: "ETB", languages: ["Amharic"], population: 114963588, area: 1104300,
                   timezone: "EAT", hasIslands: false),
        
        CountryInfo(name: "Nigeria", code: "NG", continent: .africa,
                   capital: "Abuja",
                   majorCities: ["Lagos", "Abuja", "Kano", "Ibadan", "Port Harcourt", "Benin City"],
                   coordinates: CLLocationCoordinate2D(latitude: 9.0820, longitude: 8.6753),
                   currency: "NGN", languages: ["English"], population: 206139589, area: 923768,
                   timezone: "WAT", hasIslands: true),
        
        CountryInfo(name: "Ghana", code: "GH", continent: .africa,
                   capital: "Accra",
                   majorCities: ["Accra", "Kumasi", "Tamale", "Cape Coast", "Takoradi"],
                   coordinates: CLLocationCoordinate2D(latitude: 7.9465, longitude: -1.0232),
                   currency: "GHS", languages: ["English"], population: 31072940, area: 238533,
                   timezone: "GMT", hasIslands: true),
        
        CountryInfo(name: "Tunisia", code: "TN", continent: .africa,
                   capital: "Tunis",
                   majorCities: ["Tunis", "Sousse", "Hammamet", "Djerba", "Monastir", "Sidi Bou Said"],
                   coordinates: CLLocationCoordinate2D(latitude: 33.8869, longitude: 9.5375),
                   currency: "TND", languages: ["Arabic"], population: 11818619, area: 163610,
                   timezone: "CET", hasIslands: true),
        
        CountryInfo(name: "Uganda", code: "UG", continent: .africa,
                   capital: "Kampala",
                   majorCities: ["Kampala", "Entebbe", "Jinja", "Mbarara", "Gulu"],
                   coordinates: CLLocationCoordinate2D(latitude: 1.3733, longitude: 32.2903),
                   currency: "UGX", languages: ["English", "Swahili"], population: 45741007, area: 241038,
                   timezone: "EAT", hasIslands: true),
        
        // South America
        CountryInfo(name: "Brazil", code: "BR", continent: .southAmerica,
                   capital: "Brasília",
                   majorCities: ["São Paulo", "Rio de Janeiro", "Salvador", "Brasília", "Fortaleza", "Belo Horizonte", "Manaus", "Recife", "Porto Alegre", "Florianópolis", "Foz do Iguaçu", "Paraty", "Buzios"],
                   coordinates: CLLocationCoordinate2D(latitude: -14.2350, longitude: -51.9253),
                   currency: "BRL", languages: ["Portuguese"], population: 212559417, area: 8514877,
                   timezone: "Multiple", hasIslands: true),
        
        CountryInfo(name: "Argentina", code: "AR", continent: .southAmerica,
                   capital: "Buenos Aires",
                   majorCities: ["Buenos Aires", "Córdoba", "Rosario", "Mendoza", "Bariloche", "Ushuaia", "El Calafate", "Salta", "Mar del Plata"],
                   coordinates: CLLocationCoordinate2D(latitude: -38.4161, longitude: -63.6167),
                   currency: "ARS", languages: ["Spanish"], population: 45195774, area: 2780400,
                   timezone: "ART", hasIslands: true),
        
        CountryInfo(name: "Peru", code: "PE", continent: .southAmerica,
                   capital: "Lima",
                   majorCities: ["Lima", "Cusco", "Arequipa", "Puno", "Iquitos", "Trujillo", "Huacachina", "Máncora"],
                   coordinates: CLLocationCoordinate2D(latitude: -9.1900, longitude: -75.0152),
                   currency: "PEN", languages: ["Spanish"], population: 32971854, area: 1285216,
                   timezone: "PET", hasIslands: true),
        
        CountryInfo(name: "Colombia", code: "CO", continent: .southAmerica,
                   capital: "Bogotá",
                   majorCities: ["Bogotá", "Medellín", "Cartagena", "Cali", "Barranquilla", "Santa Marta", "San Andrés"],
                   coordinates: CLLocationCoordinate2D(latitude: 4.5709, longitude: -74.2973),
                   currency: "COP", languages: ["Spanish"], population: 50882891, area: 1141748,
                   timezone: "COT", hasIslands: true),
        
        CountryInfo(name: "Chile", code: "CL", continent: .southAmerica,
                   capital: "Santiago",
                   majorCities: ["Santiago", "Valparaíso", "Concepción", "La Serena", "Pucón", "Puerto Varas", "San Pedro de Atacama", "Easter Island"],
                   coordinates: CLLocationCoordinate2D(latitude: -35.6751, longitude: -71.5430),
                   currency: "CLP", languages: ["Spanish"], population: 19116201, area: 756102,
                   timezone: "CLT", hasIslands: true),
        
        CountryInfo(name: "Venezuela", code: "VE", continent: .southAmerica,
                   capital: "Caracas",
                   majorCities: ["Caracas", "Maracaibo", "Valencia", "Barquisimeto", "Margarita Island", "Los Roques"],
                   coordinates: CLLocationCoordinate2D(latitude: 6.4238, longitude: -66.5897),
                   currency: "VES", languages: ["Spanish"], population: 28435940, area: 912050,
                   timezone: "VET", hasIslands: true),
        
        CountryInfo(name: "Ecuador", code: "EC", continent: .southAmerica,
                   capital: "Quito",
                   majorCities: ["Quito", "Guayaquil", "Cuenca", "Galápagos", "Baños", "Montañita", "Mindo"],
                   coordinates: CLLocationCoordinate2D(latitude: -1.8312, longitude: -78.1834),
                   currency: "USD", languages: ["Spanish"], population: 17643054, area: 283561,
                   timezone: "ECT", hasIslands: true),
        
        CountryInfo(name: "Bolivia", code: "BO", continent: .southAmerica,
                   capital: "La Paz",
                   majorCities: ["La Paz", "Santa Cruz", "Cochabamba", "Sucre", "Uyuni", "Copacabana"],
                   coordinates: CLLocationCoordinate2D(latitude: -16.2902, longitude: -63.5887),
                   currency: "BOB", languages: ["Spanish"], population: 11673021, area: 1098581,
                   timezone: "BOT", hasIslands: false),
        
        CountryInfo(name: "Paraguay", code: "PY", continent: .southAmerica,
                   capital: "Asunción",
                   majorCities: ["Asunción", "Ciudad del Este", "Encarnación", "Pedro Juan Caballero"],
                   coordinates: CLLocationCoordinate2D(latitude: -23.4425, longitude: -58.4438),
                   currency: "PYG", languages: ["Spanish", "Guaraní"], population: 7132538, area: 406752,
                   timezone: "PYT", hasIslands: false),
        
        CountryInfo(name: "Uruguay", code: "UY", continent: .southAmerica,
                   capital: "Montevideo",
                   majorCities: ["Montevideo", "Punta del Este", "Colonia del Sacramento", "La Paloma", "Cabo Polonio"],
                   coordinates: CLLocationCoordinate2D(latitude: -32.5228, longitude: -55.7658),
                   currency: "UYU", languages: ["Spanish"], population: 3473730, area: 176215,
                   timezone: "UYT", hasIslands: true),
        
        // Oceania
        CountryInfo(name: "Australia", code: "AU", continent: .oceania,
                   capital: "Canberra",
                   majorCities: ["Sydney", "Melbourne", "Brisbane", "Perth", "Adelaide", "Gold Coast", "Cairns", "Hobart", "Darwin", "Byron Bay", "Uluru", "Great Barrier Reef"],
                   coordinates: CLLocationCoordinate2D(latitude: -25.2744, longitude: 133.7751),
                   currency: "AUD", languages: ["English"], population: 25499884, area: 7692024,
                   timezone: "Multiple", hasIslands: true),
        
        CountryInfo(name: "New Zealand", code: "NZ", continent: .oceania,
                   capital: "Wellington",
                   majorCities: ["Auckland", "Wellington", "Christchurch", "Queenstown", "Rotorua", "Dunedin", "Napier", "Nelson", "Milford Sound"],
                   coordinates: CLLocationCoordinate2D(latitude: -40.9006, longitude: 174.8860),
                   currency: "NZD", languages: ["English", "Māori"], population: 4822233, area: 268838,
                   timezone: "NZST", hasIslands: true),
        
        CountryInfo(name: "Fiji", code: "FJ", continent: .oceania,
                   capital: "Suva",
                   majorCities: ["Suva", "Nadi", "Lautoka", "Labasa", "Coral Coast", "Mamanuca Islands"],
                   coordinates: CLLocationCoordinate2D(latitude: -16.5782, longitude: 179.4143),
                   currency: "FJD", languages: ["English", "Fijian", "Hindi"], population: 896445, area: 18274,
                   timezone: "FJT", hasIslands: true),
        
        CountryInfo(name: "Papua New Guinea", code: "PG", continent: .oceania,
                   capital: "Port Moresby",
                   majorCities: ["Port Moresby", "Lae", "Mount Hagen", "Madang", "Wewak"],
                   coordinates: CLLocationCoordinate2D(latitude: -6.3150, longitude: 143.9555),
                   currency: "PGK", languages: ["English", "Tok Pisin", "Hiri Motu"], population: 8947024, area: 462840,
                   timezone: "PGT", hasIslands: true),
        
        // Caribbean & Central America
        CountryInfo(name: "Costa Rica", code: "CR", continent: .northAmerica,
                   capital: "San José",
                   majorCities: ["San José", "Tamarindo", "Manuel Antonio", "Monteverde", "La Fortuna", "Puerto Viejo", "Jacó"],
                   coordinates: CLLocationCoordinate2D(latitude: 9.7489, longitude: -83.7534),
                   currency: "CRC", languages: ["Spanish"], population: 5094118, area: 51100,
                   timezone: "CST", hasIslands: true),
        
        CountryInfo(name: "Panama", code: "PA", continent: .northAmerica,
                   capital: "Panama City",
                   majorCities: ["Panama City", "Bocas del Toro", "Boquete", "San Blas Islands", "David"],
                   coordinates: CLLocationCoordinate2D(latitude: 8.5380, longitude: -80.7821),
                   currency: "PAB", languages: ["Spanish"], population: 4314767, area: 75420,
                   timezone: "EST", hasIslands: true),
        
        CountryInfo(name: "Guatemala", code: "GT", continent: .northAmerica,
                   capital: "Guatemala City",
                   majorCities: ["Guatemala City", "Antigua", "Flores", "Panajachel", "Quetzaltenango"],
                   coordinates: CLLocationCoordinate2D(latitude: 15.7835, longitude: -90.2308),
                   currency: "GTQ", languages: ["Spanish"], population: 17915568, area: 108889,
                   timezone: "CST", hasIslands: false),
        
        CountryInfo(name: "Cuba", code: "CU", continent: .northAmerica,
                   capital: "Havana",
                   majorCities: ["Havana", "Varadero", "Trinidad", "Santiago de Cuba", "Viñales", "Cienfuegos"],
                   coordinates: CLLocationCoordinate2D(latitude: 21.5218, longitude: -77.7812),
                   currency: "CUP", languages: ["Spanish"], population: 11326616, area: 110860,
                   timezone: "CST", hasIslands: true),
        
        CountryInfo(name: "Jamaica", code: "JM", continent: .northAmerica,
                   capital: "Kingston",
                   majorCities: ["Kingston", "Montego Bay", "Ocho Rios", "Negril", "Port Antonio"],
                   coordinates: CLLocationCoordinate2D(latitude: 18.1096, longitude: -77.2975),
                   currency: "JMD", languages: ["English"], population: 2961167, area: 10991,
                   timezone: "EST", hasIslands: true),
        
        CountryInfo(name: "Dominican Republic", code: "DO", continent: .northAmerica,
                   capital: "Santo Domingo",
                   majorCities: ["Santo Domingo", "Punta Cana", "Puerto Plata", "La Romana", "Samaná"],
                   coordinates: CLLocationCoordinate2D(latitude: 18.7357, longitude: -70.1627),
                   currency: "DOP", languages: ["Spanish"], population: 10847910, area: 48670,
                   timezone: "AST", hasIslands: true),
        
        CountryInfo(name: "Bahamas", code: "BS", continent: .northAmerica,
                   capital: "Nassau",
                   majorCities: ["Nassau", "Freeport", "Exuma", "Eleuthera", "Abaco"],
                   coordinates: CLLocationCoordinate2D(latitude: 25.0343, longitude: -77.3963),
                   currency: "BSD", languages: ["English"], population: 393244, area: 13880,
                   timezone: "EST", hasIslands: true),
        
        CountryInfo(name: "Barbados", code: "BB", continent: .northAmerica,
                   capital: "Bridgetown",
                   majorCities: ["Bridgetown", "Speightstown", "Oistins", "Holetown"],
                   coordinates: CLLocationCoordinate2D(latitude: 13.1939, longitude: -59.5432),
                   currency: "BBD", languages: ["English"], population: 287375, area: 430,
                   timezone: "AST", hasIslands: true),
        
        // More countries to reach 195...
        CountryInfo(name: "Malta", code: "MT", continent: .europe,
                   capital: "Valletta",
                   majorCities: ["Valletta", "Sliema", "St. Julian's", "Mdina", "Gozo"],
                   coordinates: CLLocationCoordinate2D(latitude: 35.9375, longitude: 14.3754),
                   currency: "EUR", languages: ["Maltese", "English"], population: 441543, area: 316,
                   timezone: "CET", hasIslands: true),
        
        CountryInfo(name: "Luxembourg", code: "LU", continent: .europe,
                   capital: "Luxembourg City",
                   majorCities: ["Luxembourg City", "Esch-sur-Alzette", "Dudelange"],
                   coordinates: CLLocationCoordinate2D(latitude: 49.8153, longitude: 6.1296),
                   currency: "EUR", languages: ["Luxembourgish", "French", "German"], population: 625978, area: 2586,
                   timezone: "CET", hasIslands: false),
        
        CountryInfo(name: "Cyprus", code: "CY", continent: .europe,
                   capital: "Nicosia",
                   majorCities: ["Nicosia", "Limassol", "Larnaca", "Paphos", "Ayia Napa"],
                   coordinates: CLLocationCoordinate2D(latitude: 35.1264, longitude: 33.4299),
                   currency: "EUR", languages: ["Greek", "Turkish"], population: 1207359, area: 9251,
                   timezone: "EET", hasIslands: true),
        
        CountryInfo(name: "Estonia", code: "EE", continent: .europe,
                   capital: "Tallinn",
                   majorCities: ["Tallinn", "Tartu", "Narva", "Pärnu"],
                   coordinates: CLLocationCoordinate2D(latitude: 58.5953, longitude: 25.0136),
                   currency: "EUR", languages: ["Estonian"], population: 1326535, area: 45228,
                   timezone: "EET", hasIslands: true),
        
        CountryInfo(name: "Latvia", code: "LV", continent: .europe,
                   capital: "Riga",
                   majorCities: ["Riga", "Daugavpils", "Liepāja", "Jelgava", "Jūrmala"],
                   coordinates: CLLocationCoordinate2D(latitude: 56.8796, longitude: 24.6032),
                   currency: "EUR", languages: ["Latvian"], population: 1886198, area: 64589,
                   timezone: "EET", hasIslands: true),
        
        CountryInfo(name: "Lithuania", code: "LT", continent: .europe,
                   capital: "Vilnius",
                   majorCities: ["Vilnius", "Kaunas", "Klaipėda", "Šiauliai", "Panevėžys"],
                   coordinates: CLLocationCoordinate2D(latitude: 55.1694, longitude: 23.8813),
                   currency: "EUR", languages: ["Lithuanian"], population: 2722289, area: 65300,
                   timezone: "EET", hasIslands: false),
        
        CountryInfo(name: "Slovenia", code: "SI", continent: .europe,
                   capital: "Ljubljana",
                   majorCities: ["Ljubljana", "Maribor", "Bled", "Piran", "Kranj"],
                   coordinates: CLLocationCoordinate2D(latitude: 46.1512, longitude: 14.9955),
                   currency: "EUR", languages: ["Slovenian"], population: 2078938, area: 20273,
                   timezone: "CET", hasIslands: false),
        
        CountryInfo(name: "Slovakia", code: "SK", continent: .europe,
                   capital: "Bratislava",
                   majorCities: ["Bratislava", "Košice", "Prešov", "Žilina", "Nitra"],
                   coordinates: CLLocationCoordinate2D(latitude: 48.6690, longitude: 19.6990),
                   currency: "EUR", languages: ["Slovak"], population: 5459642, area: 49035,
                   timezone: "CET", hasIslands: false)
    ] + WorldDatabase.additionalCountries
    
    static func getCountryByName(_ name: String) -> CountryInfo? {
        return countries.first { $0.name.lowercased() == name.lowercased() }
    }
    
    static func getCountriesByContinent(_ continent: Continent) -> [CountryInfo] {
        return countries.filter { $0.continent == continent }
    }
    
    static func getAllCities() -> [String] {
        return countries.flatMap { $0.majorCities }
    }
}