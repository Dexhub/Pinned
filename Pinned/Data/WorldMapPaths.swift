import SwiftUI

extension WorldMapData {
    // More detailed country paths with realistic shapes
    static let detailedCountries: [Country] = [
        // North America
        Country(
            name: "United States",
            code: "US",
            path: Path { path in
                // Mainland US shape
                path.move(to: CGPoint(x: 150, y: 180))
                path.addCurve(to: CGPoint(x: 320, y: 170),
                            control1: CGPoint(x: 200, y: 160),
                            control2: CGPoint(x: 280, y: 165))
                path.addLine(to: CGPoint(x: 340, y: 200))
                path.addCurve(to: CGPoint(x: 300, y: 280),
                            control1: CGPoint(x: 340, y: 240),
                            control2: CGPoint(x: 320, y: 270))
                path.addLine(to: CGPoint(x: 250, y: 280))
                path.addCurve(to: CGPoint(x: 150, y: 250),
                            control1: CGPoint(x: 200, y: 280),
                            control2: CGPoint(x: 160, y: 270))
                path.closeSubpath()
                
                // Alaska
                path.move(to: CGPoint(x: 80, y: 100))
                path.addLine(to: CGPoint(x: 120, y: 100))
                path.addLine(to: CGPoint(x: 120, y: 140))
                path.addLine(to: CGPoint(x: 80, y: 140))
                path.closeSubpath()
            },
            center: CGPoint(x: 245, y: 225)
        ),
        
        Country(
            name: "Canada",
            code: "CA",
            path: Path { path in
                path.move(to: CGPoint(x: 80, y: 50))
                path.addCurve(to: CGPoint(x: 350, y: 60),
                            control1: CGPoint(x: 150, y: 40),
                            control2: CGPoint(x: 280, y: 50))
                path.addLine(to: CGPoint(x: 340, y: 170))
                path.addLine(to: CGPoint(x: 150, y: 180))
                path.addLine(to: CGPoint(x: 120, y: 140))
                path.addCurve(to: CGPoint(x: 80, y: 50),
                            control1: CGPoint(x: 100, y: 100),
                            control2: CGPoint(x: 85, y: 70))
                path.closeSubpath()
            },
            center: CGPoint(x: 215, y: 110)
        ),
        
        Country(
            name: "Mexico",
            code: "MX",
            path: Path { path in
                path.move(to: CGPoint(x: 180, y: 280))
                path.addLine(to: CGPoint(x: 250, y: 280))
                path.addLine(to: CGPoint(x: 240, y: 340))
                path.addCurve(to: CGPoint(x: 200, y: 360),
                            control1: CGPoint(x: 235, y: 350),
                            control2: CGPoint(x: 220, y: 360))
                path.addLine(to: CGPoint(x: 180, y: 340))
                path.closeSubpath()
            },
            center: CGPoint(x: 215, y: 320)
        ),
        
        // Europe
        Country(
            name: "United Kingdom",
            code: "GB",
            path: Path { path in
                path.move(to: CGPoint(x: 480, y: 120))
                path.addCurve(to: CGPoint(x: 495, y: 110),
                            control1: CGPoint(x: 485, y: 115),
                            control2: CGPoint(x: 490, y: 110))
                path.addLine(to: CGPoint(x: 500, y: 160))
                path.addCurve(to: CGPoint(x: 485, y: 165),
                            control1: CGPoint(x: 498, y: 163),
                            control2: CGPoint(x: 490, y: 165))
                path.addLine(to: CGPoint(x: 480, y: 140))
                path.closeSubpath()
            },
            center: CGPoint(x: 490, y: 140)
        ),
        
        Country(
            name: "France",
            code: "FR",
            path: Path { path in
                path.move(to: CGPoint(x: 485, y: 165))
                path.addLine(to: CGPoint(x: 520, y: 160))
                path.addCurve(to: CGPoint(x: 525, y: 200),
                            control1: CGPoint(x: 525, y: 175),
                            control2: CGPoint(x: 525, y: 190))
                path.addLine(to: CGPoint(x: 490, y: 205))
                path.addCurve(to: CGPoint(x: 480, y: 180),
                            control1: CGPoint(x: 485, y: 200),
                            control2: CGPoint(x: 480, y: 190))
                path.closeSubpath()
            },
            center: CGPoint(x: 502, y: 182)
        ),
        
        Country(
            name: "Spain",
            code: "ES",
            path: Path { path in
                path.move(to: CGPoint(x: 460, y: 200))
                path.addLine(to: CGPoint(x: 490, y: 205))
                path.addLine(to: CGPoint(x: 485, y: 230))
                path.addCurve(to: CGPoint(x: 455, y: 225),
                            control1: CGPoint(x: 475, y: 230),
                            control2: CGPoint(x: 465, y: 228))
                path.closeSubpath()
            },
            center: CGPoint(x: 472, y: 215)
        ),
        
        Country(
            name: "Germany",
            code: "DE",
            path: Path { path in
                path.move(to: CGPoint(x: 520, y: 140))
                path.addLine(to: CGPoint(x: 550, y: 135))
                path.addLine(to: CGPoint(x: 555, y: 175))
                path.addLine(to: CGPoint(x: 525, y: 180))
                path.addLine(to: CGPoint(x: 520, y: 160))
                path.closeSubpath()
            },
            center: CGPoint(x: 537, y: 157)
        ),
        
        Country(
            name: "Italy",
            code: "IT",
            path: Path { path in
                path.move(to: CGPoint(x: 525, y: 180))
                path.addLine(to: CGPoint(x: 540, y: 175))
                path.addCurve(to: CGPoint(x: 545, y: 220),
                            control1: CGPoint(x: 542, y: 190),
                            control2: CGPoint(x: 545, y: 210))
                path.addLine(to: CGPoint(x: 535, y: 225))
                path.addCurve(to: CGPoint(x: 525, y: 200),
                            control1: CGPoint(x: 530, y: 220),
                            control2: CGPoint(x: 525, y: 210))
                path.closeSubpath()
            },
            center: CGPoint(x: 535, y: 200)
        ),
        
        Country(
            name: "Greece",
            code: "GR",
            path: Path { path in
                path.move(to: CGPoint(x: 560, y: 210))
                path.addLine(to: CGPoint(x: 575, y: 208))
                path.addCurve(to: CGPoint(x: 580, y: 230),
                            control1: CGPoint(x: 578, y: 215),
                            control2: CGPoint(x: 580, y: 225))
                path.addLine(to: CGPoint(x: 565, y: 235))
                path.closeSubpath()
            },
            center: CGPoint(x: 570, y: 221)
        ),
        
        // South America
        Country(
            name: "Brazil",
            code: "BR",
            path: Path { path in
                path.move(to: CGPoint(x: 280, y: 380))
                path.addCurve(to: CGPoint(x: 380, y: 360),
                            control1: CGPoint(x: 320, y: 360),
                            control2: CGPoint(x: 360, y: 360))
                path.addCurve(to: CGPoint(x: 400, y: 450),
                            control1: CGPoint(x: 400, y: 380),
                            control2: CGPoint(x: 400, y: 420))
                path.addLine(to: CGPoint(x: 320, y: 480))
                path.addCurve(to: CGPoint(x: 280, y: 420),
                            control1: CGPoint(x: 290, y: 470),
                            control2: CGPoint(x: 280, y: 440))
                path.closeSubpath()
            },
            center: CGPoint(x: 340, y: 420)
        ),
        
        Country(
            name: "Argentina",
            code: "AR",
            path: Path { path in
                path.move(to: CGPoint(x: 300, y: 460))
                path.addLine(to: CGPoint(x: 340, y: 450))
                path.addCurve(to: CGPoint(x: 320, y: 550),
                            control1: CGPoint(x: 335, y: 480),
                            control2: CGPoint(x: 325, y: 520))
                path.addLine(to: CGPoint(x: 310, y: 550))
                path.closeSubpath()
            },
            center: CGPoint(x: 320, y: 500)
        ),
        
        Country(
            name: "Peru",
            code: "PE",
            path: Path { path in
                path.move(to: CGPoint(x: 260, y: 400))
                path.addLine(to: CGPoint(x: 290, y: 395))
                path.addLine(to: CGPoint(x: 285, y: 430))
                path.addLine(to: CGPoint(x: 255, y: 425))
                path.closeSubpath()
            },
            center: CGPoint(x: 272, y: 412)
        ),
        
        // Africa
        Country(
            name: "Egypt",
            code: "EG",
            path: Path { path in
                path.move(to: CGPoint(x: 570, y: 260))
                path.addLine(to: CGPoint(x: 610, y: 255))
                path.addLine(to: CGPoint(x: 615, y: 300))
                path.addLine(to: CGPoint(x: 575, y: 305))
                path.closeSubpath()
            },
            center: CGPoint(x: 592, y: 280)
        ),
        
        Country(
            name: "South Africa",
            code: "ZA",
            path: Path { path in
                path.move(to: CGPoint(x: 540, y: 480))
                path.addCurve(to: CGPoint(x: 590, y: 475),
                            control1: CGPoint(x: 560, y: 475),
                            control2: CGPoint(x: 580, y: 475))
                path.addCurve(to: CGPoint(x: 595, y: 520),
                            control1: CGPoint(x: 595, y: 490),
                            control2: CGPoint(x: 595, y: 510))
                path.addLine(to: CGPoint(x: 545, y: 525))
                path.closeSubpath()
            },
            center: CGPoint(x: 567, y: 500)
        ),
        
        Country(
            name: "Morocco",
            code: "MA",
            path: Path { path in
                path.move(to: CGPoint(x: 470, y: 250))
                path.addLine(to: CGPoint(x: 500, y: 245))
                path.addLine(to: CGPoint(x: 505, y: 280))
                path.addLine(to: CGPoint(x: 475, y: 285))
                path.closeSubpath()
            },
            center: CGPoint(x: 487, y: 265)
        ),
        
        Country(
            name: "Kenya",
            code: "KE",
            path: Path { path in
                path.move(to: CGPoint(x: 590, y: 380))
                path.addLine(to: CGPoint(x: 615, y: 378))
                path.addLine(to: CGPoint(x: 618, y: 405))
                path.addLine(to: CGPoint(x: 593, y: 408))
                path.closeSubpath()
            },
            center: CGPoint(x: 604, y: 393)
        ),
        
        // Asia
        Country(
            name: "China",
            code: "CN",
            path: Path { path in
                path.move(to: CGPoint(x: 680, y: 150))
                path.addCurve(to: CGPoint(x: 850, y: 140),
                            control1: CGPoint(x: 750, y: 140),
                            control2: CGPoint(x: 820, y: 140))
                path.addCurve(to: CGPoint(x: 870, y: 250),
                            control1: CGPoint(x: 870, y: 180),
                            control2: CGPoint(x: 870, y: 220))
                path.addLine(to: CGPoint(x: 700, y: 260))
                path.addCurve(to: CGPoint(x: 680, y: 200),
                            control1: CGPoint(x: 685, y: 240),
                            control2: CGPoint(x: 680, y: 220))
                path.closeSubpath()
            },
            center: CGPoint(x: 775, y: 200)
        ),
        
        Country(
            name: "Japan",
            code: "JP",
            path: Path { path in
                path.move(to: CGPoint(x: 890, y: 170))
                path.addCurve(to: CGPoint(x: 910, y: 165),
                            control1: CGPoint(x: 895, y: 165),
                            control2: CGPoint(x: 905, y: 165))
                path.addCurve(to: CGPoint(x: 915, y: 220),
                            control1: CGPoint(x: 915, y: 180),
                            control2: CGPoint(x: 915, y: 200))
                path.addLine(to: CGPoint(x: 895, y: 225))
                path.closeSubpath()
            },
            center: CGPoint(x: 902, y: 195)
        ),
        
        Country(
            name: "India",
            code: "IN",
            path: Path { path in
                path.move(to: CGPoint(x: 680, y: 260))
                path.addLine(to: CGPoint(x: 730, y: 255))
                path.addCurve(to: CGPoint(x: 720, y: 340),
                            control1: CGPoint(x: 735, y: 290),
                            control2: CGPoint(x: 730, y: 320))
                path.addLine(to: CGPoint(x: 690, y: 345))
                path.addCurve(to: CGPoint(x: 680, y: 300),
                            control1: CGPoint(x: 682, y: 330),
                            control2: CGPoint(x: 680, y: 315))
                path.closeSubpath()
            },
            center: CGPoint(x: 705, y: 300)
        ),
        
        Country(
            name: "Thailand",
            code: "TH",
            path: Path { path in
                path.move(to: CGPoint(x: 760, y: 300))
                path.addLine(to: CGPoint(x: 780, y: 298))
                path.addCurve(to: CGPoint(x: 775, y: 350),
                            control1: CGPoint(x: 782, y: 320),
                            control2: CGPoint(x: 780, y: 340))
                path.addLine(to: CGPoint(x: 765, y: 352))
                path.closeSubpath()
            },
            center: CGPoint(x: 770, y: 325)
        ),
        
        Country(
            name: "Indonesia",
            code: "ID",
            path: Path { path in
                // Main islands simplified
                path.move(to: CGPoint(x: 780, y: 380))
                path.addLine(to: CGPoint(x: 850, y: 375))
                path.addLine(to: CGPoint(x: 855, y: 395))
                path.addLine(to: CGPoint(x: 785, y: 400))
                path.closeSubpath()
            },
            center: CGPoint(x: 817, y: 387)
        ),
        
        // Oceania
        Country(
            name: "Australia",
            code: "AU",
            path: Path { path in
                path.move(to: CGPoint(x: 800, y: 440))
                path.addCurve(to: CGPoint(x: 900, y: 430),
                            control1: CGPoint(x: 840, y: 430),
                            control2: CGPoint(x: 880, y: 430))
                path.addCurve(to: CGPoint(x: 910, y: 500),
                            control1: CGPoint(x: 910, y: 450),
                            control2: CGPoint(x: 910, y: 480))
                path.addLine(to: CGPoint(x: 810, y: 510))
                path.addCurve(to: CGPoint(x: 800, y: 470),
                            control1: CGPoint(x: 802, y: 495),
                            control2: CGPoint(x: 800, y: 480))
                path.closeSubpath()
            },
            center: CGPoint(x: 855, y: 470)
        ),
        
        Country(
            name: "New Zealand",
            code: "NZ",
            path: Path { path in
                path.move(to: CGPoint(x: 930, y: 490))
                path.addCurve(to: CGPoint(x: 945, y: 485),
                            control1: CGPoint(x: 935, y: 485),
                            control2: CGPoint(x: 940, y: 485))
                path.addLine(to: CGPoint(x: 950, y: 520))
                path.addLine(to: CGPoint(x: 935, y: 525))
                path.closeSubpath()
            },
            center: CGPoint(x: 940, y: 505)
        ),
        
        // More European countries
        Country(
            name: "Portugal",
            code: "PT",
            path: Path { path in
                path.move(to: CGPoint(x: 450, y: 200))
                path.addLine(to: CGPoint(x: 460, y: 200))
                path.addLine(to: CGPoint(x: 455, y: 225))
                path.addLine(to: CGPoint(x: 445, y: 225))
                path.closeSubpath()
            },
            center: CGPoint(x: 452, y: 212)
        ),
        
        Country(
            name: "Netherlands",
            code: "NL",
            path: Path { path in
                path.move(to: CGPoint(x: 515, y: 125))
                path.addLine(to: CGPoint(x: 525, y: 123))
                path.addLine(to: CGPoint(x: 527, y: 138))
                path.addLine(to: CGPoint(x: 517, y: 140))
                path.closeSubpath()
            },
            center: CGPoint(x: 521, y: 131)
        ),
        
        Country(
            name: "Belgium",
            code: "BE",
            path: Path { path in
                path.move(to: CGPoint(x: 510, y: 140))
                path.addLine(to: CGPoint(x: 520, y: 138))
                path.addLine(to: CGPoint(x: 522, y: 150))
                path.addLine(to: CGPoint(x: 512, y: 152))
                path.closeSubpath()
            },
            center: CGPoint(x: 516, y: 145)
        ),
        
        Country(
            name: "Switzerland",
            code: "CH",
            path: Path { path in
                path.move(to: CGPoint(x: 520, y: 175))
                path.addLine(to: CGPoint(x: 535, y: 173))
                path.addLine(to: CGPoint(x: 537, y: 185))
                path.addLine(to: CGPoint(x: 522, y: 187))
                path.closeSubpath()
            },
            center: CGPoint(x: 528, y: 180)
        ),
        
        Country(
            name: "Austria",
            code: "AT",
            path: Path { path in
                path.move(to: CGPoint(x: 535, y: 173))
                path.addLine(to: CGPoint(x: 555, y: 170))
                path.addLine(to: CGPoint(x: 557, y: 182))
                path.addLine(to: CGPoint(x: 537, y: 185))
                path.closeSubpath()
            },
            center: CGPoint(x: 546, y: 177)
        ),
        
        Country(
            name: "Poland",
            code: "PL",
            path: Path { path in
                path.move(to: CGPoint(x: 550, y: 130))
                path.addLine(to: CGPoint(x: 575, y: 128))
                path.addLine(to: CGPoint(x: 578, y: 155))
                path.addLine(to: CGPoint(x: 553, y: 157))
                path.closeSubpath()
            },
            center: CGPoint(x: 564, y: 142)
        ),
        
        Country(
            name: "Czech Republic",
            code: "CZ",
            path: Path { path in
                path.move(to: CGPoint(x: 535, y: 155))
                path.addLine(to: CGPoint(x: 553, y: 153))
                path.addLine(to: CGPoint(x: 555, y: 165))
                path.addLine(to: CGPoint(x: 537, y: 167))
                path.closeSubpath()
            },
            center: CGPoint(x: 545, y: 160)
        ),
        
        Country(
            name: "Norway",
            code: "NO",
            path: Path { path in
                path.move(to: CGPoint(x: 510, y: 60))
                path.addCurve(to: CGPoint(x: 530, y: 55),
                            control1: CGPoint(x: 515, y: 55),
                            control2: CGPoint(x: 525, y: 55))
                path.addLine(to: CGPoint(x: 535, y: 110))
                path.addLine(to: CGPoint(x: 515, y: 115))
                path.closeSubpath()
            },
            center: CGPoint(x: 522, y: 85)
        ),
        
        Country(
            name: "Sweden",
            code: "SE",
            path: Path { path in
                path.move(to: CGPoint(x: 530, y: 70))
                path.addLine(to: CGPoint(x: 550, y: 65))
                path.addLine(to: CGPoint(x: 555, y: 120))
                path.addLine(to: CGPoint(x: 535, y: 125))
                path.closeSubpath()
            },
            center: CGPoint(x: 542, y: 95)
        ),
        
        Country(
            name: "Finland",
            code: "FI",
            path: Path { path in
                path.move(to: CGPoint(x: 550, y: 60))
                path.addLine(to: CGPoint(x: 570, y: 58))
                path.addLine(to: CGPoint(x: 575, y: 100))
                path.addLine(to: CGPoint(x: 555, y: 105))
                path.closeSubpath()
            },
            center: CGPoint(x: 562, y: 80)
        ),
        
        Country(
            name: "Denmark",
            code: "DK",
            path: Path { path in
                path.move(to: CGPoint(x: 520, y: 115))
                path.addLine(to: CGPoint(x: 535, y: 113))
                path.addLine(to: CGPoint(x: 537, y: 125))
                path.addLine(to: CGPoint(x: 522, y: 127))
                path.closeSubpath()
            },
            center: CGPoint(x: 528, y: 120)
        ),
        
        // More Asian countries
        Country(
            name: "South Korea",
            code: "KR",
            path: Path { path in
                path.move(to: CGPoint(x: 870, y: 180))
                path.addLine(to: CGPoint(x: 885, y: 178))
                path.addLine(to: CGPoint(x: 887, y: 200))
                path.addLine(to: CGPoint(x: 872, y: 202))
                path.closeSubpath()
            },
            center: CGPoint(x: 878, y: 190)
        ),
        
        Country(
            name: "Vietnam",
            code: "VN",
            path: Path { path in
                path.move(to: CGPoint(x: 770, y: 280))
                path.addLine(to: CGPoint(x: 785, y: 278))
                path.addCurve(to: CGPoint(x: 780, y: 340),
                            control1: CGPoint(x: 787, y: 300),
                            control2: CGPoint(x: 785, y: 330))
                path.addLine(to: CGPoint(x: 772, y: 342))
                path.closeSubpath()
            },
            center: CGPoint(x: 777, y: 310)
        ),
        
        Country(
            name: "Philippines",
            code: "PH",
            path: Path { path in
                path.move(to: CGPoint(x: 840, y: 320))
                path.addLine(to: CGPoint(x: 855, y: 318))
                path.addLine(to: CGPoint(x: 857, y: 345))
                path.addLine(to: CGPoint(x: 842, y: 347))
                path.closeSubpath()
            },
            center: CGPoint(x: 848, y: 332)
        ),
        
        Country(
            name: "Malaysia",
            code: "MY",
            path: Path { path in
                path.move(to: CGPoint(x: 770, y: 370))
                path.addLine(to: CGPoint(x: 810, y: 368))
                path.addLine(to: CGPoint(x: 812, y: 380))
                path.addLine(to: CGPoint(x: 772, y: 382))
                path.closeSubpath()
            },
            center: CGPoint(x: 791, y: 375)
        ),
        
        Country(
            name: "Singapore",
            code: "SG",
            path: Path { path in
                path.addEllipse(in: CGRect(x: 784, y: 384, width: 6, height: 6))
            },
            center: CGPoint(x: 787, y: 387)
        ),
        
        // Middle East
        Country(
            name: "Turkey",
            code: "TR",
            path: Path { path in
                path.move(to: CGPoint(x: 580, y: 200))
                path.addLine(to: CGPoint(x: 630, y: 195))
                path.addLine(to: CGPoint(x: 635, y: 215))
                path.addLine(to: CGPoint(x: 585, y: 220))
                path.closeSubpath()
            },
            center: CGPoint(x: 607, y: 207)
        ),
        
        Country(
            name: "Israel",
            code: "IL",
            path: Path { path in
                path.move(to: CGPoint(x: 585, y: 250))
                path.addLine(to: CGPoint(x: 592, y: 248))
                path.addLine(to: CGPoint(x: 594, y: 265))
                path.addLine(to: CGPoint(x: 587, y: 267))
                path.closeSubpath()
            },
            center: CGPoint(x: 590, y: 257)
        ),
        
        Country(
            name: "United Arab Emirates",
            code: "AE",
            path: Path { path in
                path.move(to: CGPoint(x: 630, y: 280))
                path.addLine(to: CGPoint(x: 650, y: 278))
                path.addLine(to: CGPoint(x: 652, y: 295))
                path.addLine(to: CGPoint(x: 632, y: 297))
                path.closeSubpath()
            },
            center: CGPoint(x: 641, y: 287)
        ),
        
        // Africa additions
        Country(
            name: "Nigeria",
            code: "NG",
            path: Path { path in
                path.move(to: CGPoint(x: 510, y: 350))
                path.addLine(to: CGPoint(x: 535, y: 348))
                path.addLine(to: CGPoint(x: 537, y: 375))
                path.addLine(to: CGPoint(x: 512, y: 377))
                path.closeSubpath()
            },
            center: CGPoint(x: 523, y: 362)
        ),
        
        Country(
            name: "Ethiopia",
            code: "ET",
            path: Path { path in
                path.move(to: CGPoint(x: 600, y: 340))
                path.addLine(to: CGPoint(x: 625, y: 338))
                path.addLine(to: CGPoint(x: 627, y: 365))
                path.addLine(to: CGPoint(x: 602, y: 367))
                path.closeSubpath()
            },
            center: CGPoint(x: 613, y: 352)
        ),
        
        Country(
            name: "Tanzania",
            code: "TZ",
            path: Path { path in
                path.move(to: CGPoint(x: 590, y: 400))
                path.addLine(to: CGPoint(x: 615, y: 398))
                path.addLine(to: CGPoint(x: 617, y: 425))
                path.addLine(to: CGPoint(x: 592, y: 427))
                path.closeSubpath()
            },
            center: CGPoint(x: 603, y: 412)
        ),
        
        // South America additions
        Country(
            name: "Colombia",
            code: "CO",
            path: Path { path in
                path.move(to: CGPoint(x: 250, y: 360))
                path.addLine(to: CGPoint(x: 280, y: 358))
                path.addLine(to: CGPoint(x: 282, y: 385))
                path.addLine(to: CGPoint(x: 252, y: 387))
                path.closeSubpath()
            },
            center: CGPoint(x: 266, y: 372)
        ),
        
        Country(
            name: "Chile",
            code: "CL",
            path: Path { path in
                path.move(to: CGPoint(x: 290, y: 450))
                path.addLine(to: CGPoint(x: 300, y: 448))
                path.addCurve(to: CGPoint(x: 295, y: 540),
                            control1: CGPoint(x: 298, y: 480),
                            control2: CGPoint(x: 296, y: 520))
                path.addLine(to: CGPoint(x: 285, y: 542))
                path.closeSubpath()
            },
            center: CGPoint(x: 292, y: 495)
        ),
        
        Country(
            name: "Venezuela",
            code: "VE",
            path: Path { path in
                path.move(to: CGPoint(x: 270, y: 340))
                path.addLine(to: CGPoint(x: 300, y: 338))
                path.addLine(to: CGPoint(x: 302, y: 360))
                path.addLine(to: CGPoint(x: 272, y: 362))
                path.closeSubpath()
            },
            center: CGPoint(x: 286, y: 350)
        ),
        
        // Russia (simplified)
        Country(
            name: "Russia",
            code: "RU",
            path: Path { path in
                path.move(to: CGPoint(x: 570, y: 60))
                path.addLine(to: CGPoint(x: 900, y: 50))
                path.addLine(to: CGPoint(x: 920, y: 150))
                path.addLine(to: CGPoint(x: 590, y: 160))
                path.closeSubpath()
            },
            center: CGPoint(x: 745, y: 105)
        ),
        
        // Iceland
        Country(
            name: "Iceland",
            code: "IS",
            path: Path { path in
                path.move(to: CGPoint(x: 450, y: 80))
                path.addEllipse(in: CGRect(x: 445, y: 75, width: 20, height: 15))
            },
            center: CGPoint(x: 455, y: 82)
        )
    ]
}