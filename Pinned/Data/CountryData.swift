import Foundation

struct CountryData {
    static let countries = [
        "Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Argentina", "Armenia",
        "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados",
        "Belarus", "Belgium", "Belize", "Benin", "Bhutan", "Bolivia", "Bosnia and Herzegovina",
        "Botswana", "Brazil", "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia",
        "Cameroon", "Canada", "Cape Verde", "Central African Republic", "Chad", "Chile",
        "China", "Colombia", "Comoros", "Congo", "Costa Rica", "Croatia", "Cuba", "Cyprus",
        "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador",
        "Egypt", "El Salvador", "Estonia", "Ethiopia", "Fiji", "Finland", "France", "Gabon",
        "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Grenada", "Guatemala", "Guinea",
        "Guinea-Bissau", "Guyana", "Haiti", "Honduras", "Hungary", "Iceland", "India",
        "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan",
        "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Kosovo", "Kuwait", "Kyrgyzstan",
        "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein",
        "Lithuania", "Luxembourg", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives",
        "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius", "Mexico", "Micronesia",
        "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar",
        "Namibia", "Nauru", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger",
        "Nigeria", "North Korea", "Norway", "Oman", "Pakistan", "Palau", "Palestine",
        "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal",
        "Qatar", "Romania", "Russia", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia",
        "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Saudi Arabia", "Senegal",
        "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia",
        "Solomon Islands", "Somalia", "South Africa", "South Korea", "South Sudan", "Spain",
        "Sri Lanka", "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria",
        "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste", "Togo", "Tonga",
        "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda",
        "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "Uruguay",
        "Uzbekistan", "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "Yemen", "Zambia",
        "Zimbabwe"
    ]
    
    static let majorCities = [
        "Tokyo", "Delhi", "Shanghai", "São Paulo", "Mexico City", "Cairo", "Mumbai",
        "Beijing", "Dhaka", "Osaka", "New York", "Karachi", "Buenos Aires", "Istanbul",
        "Kolkata", "Manila", "Lagos", "Rio de Janeiro", "Tianjin", "Guangzhou", "Los Angeles",
        "Moscow", "Shenzhen", "Lahore", "Bangalore", "Paris", "Bogotá", "Jakarta", "Chennai",
        "Lima", "Bangkok", "Seoul", "Nagoya", "Hyderabad", "London", "Tehran", "Chicago",
        "Chengdu", "Nanjing", "Wuhan", "Ho Chi Minh City", "Luanda", "Ahmedabad", "Hong Kong",
        "Kuala Lumpur", "Xi'an", "Surat", "Dongguan", "Madrid", "Santiago", "Shenyang",
        "Baghdad", "Singapore", "Riyadh", "Yangon", "Alexandria", "Saint Petersburg",
        "Pune", "Ankara", "Harbin", "Hangzhou", "Sydney", "Melbourne", "Barcelona",
        "Johannesburg", "Berlin", "Toronto", "Miami", "San Francisco", "Boston", "Dubai",
        "Prague", "Amsterdam", "Vienna", "Budapest", "Warsaw", "Copenhagen", "Stockholm",
        "Rome", "Milan", "Naples", "Turin", "Athens", "Lisbon", "Edinburgh", "Dublin",
        "Zurich", "Geneva", "Brussels", "Munich", "Frankfurt", "Hamburg", "Oslo", "Helsinki",
        "Reykjavik", "Tel Aviv", "Jerusalem", "Beirut", "Damascus", "Amman", "Kuwait City",
        "Doha", "Abu Dhabi", "Muscat", "Cape Town", "Nairobi", "Casablanca", "Tunis",
        "Addis Ababa", "Dakar", "Accra", "Vancouver", "Montreal", "Calgary", "Havana",
        "Kingston", "Port-au-Prince", "Quito", "La Paz", "Montevideo", "Asunción"
    ]
    
    static let roastLines: [String: String] = [
        "Paris": "Paris? How original. Let me guess, you 'found yourself' at the Eiffel Tower?",
        "Bali": "Bali? Did you go for the culture or just the Instagram likes?",
        "Iceland": "Iceland? Blue Lagoon selfie incoming in 3... 2... 1...",
        "Dubai": "Dubai? Because nothing says authentic travel like a city built yesterday.",
        "London": "London? Revolutionary. Next you'll tell me you rode the London Eye.",
        "New York": "New York? Groundbreaking. Did you also discover pizza exists?",
        "Tokyo": "Tokyo? Let me guess, you ate sushi and felt cultured?",
        "Bangkok": "Bangkok? Pad Thai on Khao San Road doesn't count as authentic.",
        "Barcelona": "Barcelona? Sagrada Familia and sangria. How unexpected.",
        "Amsterdam": "Amsterdam? I'm sure you went for the 'museums'.",
        "Rome": "Rome? Threw a coin in the Trevi? How unique of you.",
        "Sydney": "Sydney? Opera House photo from the exact same angle as everyone else?",
        "Los Angeles": "LA? Traffic and overpriced smoothies. Living the dream.",
        "Miami": "Miami? Spring break never ended for you, huh?",
        "Las Vegas": "Vegas? What happens there apparently goes on Instagram.",
        "default": "Oh wow, so adventurous. I bet no one's ever been there before."
    ]
    
    static func getRoastForPlace(_ place: String) -> String {
        return roastLines[place] ?? roastLines["default"]!
    }
}