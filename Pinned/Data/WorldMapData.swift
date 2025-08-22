import SwiftUI

struct Country {
    let name: String
    let code: String
    let path: Path
    let center: CGPoint
}

struct WorldMapData {
    static let mapSize = CGSize(width: 1000, height: 500)
    
    // Simplified country paths - in a real app you'd load from GeoJSON
    static let countries: [Country] = [
        // North America
        Country(
            name: "United States",
            code: "US",
            path: Path { path in
                path.move(to: CGPoint(x: 200, y: 150))
                path.addLine(to: CGPoint(x: 350, y: 150))
                path.addLine(to: CGPoint(x: 350, y: 250))
                path.addLine(to: CGPoint(x: 200, y: 250))
                path.closeSubpath()
            },
            center: CGPoint(x: 275, y: 200)
        ),
        Country(
            name: "Canada",
            code: "CA",
            path: Path { path in
                path.move(to: CGPoint(x: 200, y: 50))
                path.addLine(to: CGPoint(x: 350, y: 50))
                path.addLine(to: CGPoint(x: 350, y: 150))
                path.addLine(to: CGPoint(x: 200, y: 150))
                path.closeSubpath()
            },
            center: CGPoint(x: 275, y: 100)
        ),
        Country(
            name: "Mexico",
            code: "MX",
            path: Path { path in
                path.move(to: CGPoint(x: 200, y: 250))
                path.addLine(to: CGPoint(x: 280, y: 250))
                path.addLine(to: CGPoint(x: 260, y: 320))
                path.addLine(to: CGPoint(x: 220, y: 320))
                path.closeSubpath()
            },
            center: CGPoint(x: 240, y: 285)
        ),
        
        // South America
        Country(
            name: "Brazil",
            code: "BR",
            path: Path { path in
                path.move(to: CGPoint(x: 320, y: 350))
                path.addLine(to: CGPoint(x: 420, y: 350))
                path.addLine(to: CGPoint(x: 420, y: 450))
                path.addLine(to: CGPoint(x: 320, y: 450))
                path.closeSubpath()
            },
            center: CGPoint(x: 370, y: 400)
        ),
        Country(
            name: "Argentina",
            code: "AR",
            path: Path { path in
                path.move(to: CGPoint(x: 300, y: 420))
                path.addLine(to: CGPoint(x: 340, y: 420))
                path.addLine(to: CGPoint(x: 320, y: 500))
                path.addLine(to: CGPoint(x: 310, y: 500))
                path.closeSubpath()
            },
            center: CGPoint(x: 320, y: 460)
        ),
        
        // Europe
        Country(
            name: "United Kingdom",
            code: "GB",
            path: Path { path in
                path.move(to: CGPoint(x: 480, y: 120))
                path.addLine(to: CGPoint(x: 500, y: 120))
                path.addLine(to: CGPoint(x: 500, y: 160))
                path.addLine(to: CGPoint(x: 480, y: 160))
                path.closeSubpath()
            },
            center: CGPoint(x: 490, y: 140)
        ),
        Country(
            name: "France",
            code: "FR",
            path: Path { path in
                path.move(to: CGPoint(x: 480, y: 160))
                path.addLine(to: CGPoint(x: 520, y: 160))
                path.addLine(to: CGPoint(x: 520, y: 200))
                path.addLine(to: CGPoint(x: 480, y: 200))
                path.closeSubpath()
            },
            center: CGPoint(x: 500, y: 180)
        ),
        Country(
            name: "Germany",
            code: "DE",
            path: Path { path in
                path.move(to: CGPoint(x: 520, y: 140))
                path.addLine(to: CGPoint(x: 560, y: 140))
                path.addLine(to: CGPoint(x: 560, y: 180))
                path.addLine(to: CGPoint(x: 520, y: 180))
                path.closeSubpath()
            },
            center: CGPoint(x: 540, y: 160)
        ),
        Country(
            name: "Italy",
            code: "IT",
            path: Path { path in
                path.move(to: CGPoint(x: 530, y: 180))
                path.addLine(to: CGPoint(x: 550, y: 180))
                path.addLine(to: CGPoint(x: 540, y: 220))
                path.addLine(to: CGPoint(x: 530, y: 220))
                path.closeSubpath()
            },
            center: CGPoint(x: 540, y: 200)
        ),
        Country(
            name: "Spain",
            code: "ES",
            path: Path { path in
                path.move(to: CGPoint(x: 460, y: 200))
                path.addLine(to: CGPoint(x: 500, y: 200))
                path.addLine(to: CGPoint(x: 500, y: 230))
                path.addLine(to: CGPoint(x: 460, y: 230))
                path.closeSubpath()
            },
            center: CGPoint(x: 480, y: 215)
        ),
        
        // Africa
        Country(
            name: "Egypt",
            code: "EG",
            path: Path { path in
                path.move(to: CGPoint(x: 570, y: 250))
                path.addLine(to: CGPoint(x: 620, y: 250))
                path.addLine(to: CGPoint(x: 620, y: 300))
                path.addLine(to: CGPoint(x: 570, y: 300))
                path.closeSubpath()
            },
            center: CGPoint(x: 595, y: 275)
        ),
        Country(
            name: "South Africa",
            code: "ZA",
            path: Path { path in
                path.move(to: CGPoint(x: 540, y: 430))
                path.addLine(to: CGPoint(x: 600, y: 430))
                path.addLine(to: CGPoint(x: 600, y: 480))
                path.addLine(to: CGPoint(x: 540, y: 480))
                path.closeSubpath()
            },
            center: CGPoint(x: 570, y: 455)
        ),
        
        // Asia
        Country(
            name: "China",
            code: "CN",
            path: Path { path in
                path.move(to: CGPoint(x: 700, y: 150))
                path.addLine(to: CGPoint(x: 850, y: 150))
                path.addLine(to: CGPoint(x: 850, y: 250))
                path.addLine(to: CGPoint(x: 700, y: 250))
                path.closeSubpath()
            },
            center: CGPoint(x: 775, y: 200)
        ),
        Country(
            name: "Japan",
            code: "JP",
            path: Path { path in
                path.move(to: CGPoint(x: 880, y: 180))
                path.addLine(to: CGPoint(x: 920, y: 180))
                path.addLine(to: CGPoint(x: 910, y: 230))
                path.addLine(to: CGPoint(x: 890, y: 230))
                path.closeSubpath()
            },
            center: CGPoint(x: 900, y: 205)
        ),
        Country(
            name: "India",
            code: "IN",
            path: Path { path in
                path.move(to: CGPoint(x: 680, y: 250))
                path.addLine(to: CGPoint(x: 740, y: 250))
                path.addLine(to: CGPoint(x: 710, y: 350))
                path.addLine(to: CGPoint(x: 680, y: 350))
                path.closeSubpath()
            },
            center: CGPoint(x: 710, y: 300)
        ),
        Country(
            name: "Thailand",
            code: "TH",
            path: Path { path in
                path.move(to: CGPoint(x: 750, y: 300))
                path.addLine(to: CGPoint(x: 780, y: 300))
                path.addLine(to: CGPoint(x: 770, y: 360))
                path.addLine(to: CGPoint(x: 760, y: 360))
                path.closeSubpath()
            },
            center: CGPoint(x: 765, y: 330)
        ),
        
        // Oceania
        Country(
            name: "Australia",
            code: "AU",
            path: Path { path in
                path.move(to: CGPoint(x: 800, y: 400))
                path.addLine(to: CGPoint(x: 900, y: 400))
                path.addLine(to: CGPoint(x: 900, y: 480))
                path.addLine(to: CGPoint(x: 800, y: 480))
                path.closeSubpath()
            },
            center: CGPoint(x: 850, y: 440)
        ),
        Country(
            name: "New Zealand",
            code: "NZ",
            path: Path { path in
                path.move(to: CGPoint(x: 920, y: 460))
                path.addLine(to: CGPoint(x: 950, y: 460))
                path.addLine(to: CGPoint(x: 940, y: 490))
                path.addLine(to: CGPoint(x: 930, y: 490))
                path.closeSubpath()
            },
            center: CGPoint(x: 935, y: 475)
        )
    ]
    
    static func country(at point: CGPoint) -> Country? {
        return countries.first { country in
            country.path.contains(point)
        }
    }
}