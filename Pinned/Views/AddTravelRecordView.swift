import SwiftUI
import MapKit

struct AddTravelRecordView: View {
    @EnvironmentObject var travelData: TravelData
    @Environment(\.dismiss) var dismiss
    
    // Basic Info
    @State private var placeName = ""
    @State private var placeType: PlaceType = .city
    @State private var selectedCountry = ""
    @State private var searchingCountry = ""
    
    // Dates
    @State private var visitDate = Date()
    @State private var hasEndDate = false
    @State private var endDate = Date().addingTimeInterval(24 * 60 * 60) // Tomorrow
    
    // Details
    @State private var rating = 3
    @State private var tripType: TripType = .leisure
    @State private var weather: Weather = .sunny
    @State private var budget: String = ""
    @State private var accommodation = ""
    
    // Activities
    @State private var selectedActivities: Set<Activity> = []
    
    // People
    @State private var companions: [String] = []
    @State private var newCompanion = ""
    
    // Notes
    @State private var notes = ""
    @State private var highlights: [String] = []
    @State private var newHighlight = ""
    @State private var wouldRevisit = true
    
    // Tags
    @State private var tags: [String] = []
    @State private var newTag = ""
    
    @State private var currentSection = 0
    
    var filteredCountries: [String] {
        if searchingCountry.isEmpty {
            return WorldDatabase.countries.map { $0.name }.sorted()
        }
        return WorldDatabase.countries
            .map { $0.name }
            .filter { $0.localizedCaseInsensitiveContains(searchingCountry) }
            .sorted()
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress Bar
                ProgressView(value: Double(currentSection + 1), total: 6)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "FF0080")))
                    .padding()
                
                TabView(selection: $currentSection) {
                    // Section 1: Basic Info
                    BasicInfoSection(
                        placeName: $placeName,
                        placeType: $placeType,
                        selectedCountry: $selectedCountry,
                        searchingCountry: $searchingCountry,
                        filteredCountries: filteredCountries
                    )
                    .tag(0)
                    
                    // Section 2: Dates & Duration
                    DatesSection(
                        visitDate: $visitDate,
                        hasEndDate: $hasEndDate,
                        endDate: $endDate
                    )
                    .tag(1)
                    
                    // Section 3: Trip Details
                    TripDetailsSection(
                        rating: $rating,
                        tripType: $tripType,
                        weather: $weather,
                        budget: $budget,
                        accommodation: $accommodation
                    )
                    .tag(2)
                    
                    // Section 4: Activities
                    ActivitiesSection(
                        selectedActivities: $selectedActivities
                    )
                    .tag(3)
                    
                    // Section 5: People & Notes
                    PeopleNotesSection(
                        companions: $companions,
                        newCompanion: $newCompanion,
                        notes: $notes,
                        highlights: $highlights,
                        newHighlight: $newHighlight,
                        wouldRevisit: $wouldRevisit
                    )
                    .tag(4)
                    
                    // Section 6: Tags & Review
                    TagsReviewSection(
                        tags: $tags,
                        newTag: $newTag,
                        record: previewRecord
                    )
                    .tag(5)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Navigation Buttons
                HStack {
                    if currentSection > 0 {
                        Button(action: previousSection) {
                            Label("Back", systemImage: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                        }
                    }
                    
                    Spacer()
                    
                    if currentSection < 5 {
                        Button(action: nextSection) {
                            Label("Next", systemImage: "chevron.right")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .disabled(!canProceed)
                    } else {
                        Button(action: saveRecord) {
                            Text("Save Trip")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(Color(hex: "FF0080"))
                                .cornerRadius(25)
                        }
                        .disabled(!isValid)
                    }
                }
                .padding()
            }
            .navigationTitle("Add Travel Record")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var canProceed: Bool {
        switch currentSection {
        case 0:
            return !placeName.isEmpty && !selectedCountry.isEmpty
        default:
            return true
        }
    }
    
    var isValid: Bool {
        !placeName.isEmpty && !selectedCountry.isEmpty
    }
    
    var previewRecord: TravelRecord {
        guard let countryInfo = WorldDatabase.getCountryByName(selectedCountry) else {
            return TravelRecord(
                placeType: placeType,
                name: placeName,
                country: selectedCountry,
                continent: "Unknown",
                coordinates: Coordinates(latitude: 0, longitude: 0),
                visitDate: visitDate,
                endDate: hasEndDate ? endDate : nil,
                rating: rating,
                tripType: tripType,
                companions: companions,
                budget: Double(budget),
                notes: notes,
                photos: [],
                weather: weather,
                activities: Array(selectedActivities),
                accommodation: accommodation.isEmpty ? nil : accommodation,
                highlights: highlights,
                wouldRevisit: wouldRevisit,
                tags: tags
            )
        }
        
        return TravelRecord(
            placeType: placeType,
            name: placeName,
            country: selectedCountry,
            continent: countryInfo.continent.rawValue,
            coordinates: Coordinates(
                latitude: countryInfo.coordinates.latitude,
                longitude: countryInfo.coordinates.longitude
            ),
            visitDate: visitDate,
            endDate: hasEndDate ? endDate : nil,
            rating: rating,
            tripType: tripType,
            companions: companions,
            budget: Double(budget),
            notes: notes,
            photos: [],
            weather: weather,
            activities: Array(selectedActivities),
            accommodation: accommodation.isEmpty ? nil : accommodation,
            highlights: highlights,
            wouldRevisit: wouldRevisit,
            tags: tags
        )
    }
    
    func previousSection() {
        withAnimation {
            currentSection -= 1
        }
    }
    
    func nextSection() {
        withAnimation {
            currentSection += 1
        }
    }
    
    func saveRecord() {
        travelData.addTravelRecord(previewRecord)
        dismiss()
    }
}

// MARK: - Section Views

struct BasicInfoSection: View {
    @Binding var placeName: String
    @Binding var placeType: PlaceType
    @Binding var selectedCountry: String
    @Binding var searchingCountry: String
    let filteredCountries: [String]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Where did you go?")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    // Place Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Place Name")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        TextField("e.g., Paris, Bali, Tokyo", text: $placeName)
                            .font(.system(size: 16))
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    
                    // Place Type
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Picker("Place Type", selection: $placeType) {
                            ForEach(PlaceType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Country
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Country")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        TextField("Search country...", text: $searchingCountry)
                            .font(.system(size: 16))
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        
                        if !searchingCountry.isEmpty {
                            ScrollView {
                                VStack(spacing: 0) {
                                    ForEach(filteredCountries.prefix(5), id: \.self) { country in
                                        Button(action: {
                                            selectedCountry = country
                                            searchingCountry = ""
                                        }) {
                                            HStack {
                                                Text(country)
                                                    .foregroundColor(.primary)
                                                Spacer()
                                            }
                                            .padding()
                                        }
                                        Divider()
                                    }
                                }
                            }
                            .frame(maxHeight: 200)
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(10)
                        }
                        
                        if !selectedCountry.isEmpty {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(selectedCountry)
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .padding(.top, 5)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
            .padding(.top)
        }
    }
}

struct DatesSection: View {
    @Binding var visitDate: Date
    @Binding var hasEndDate: Bool
    @Binding var endDate: Date
    
    var duration: Int {
        if hasEndDate {
            return Calendar.current.dateComponents([.day], from: visitDate, to: endDate).day ?? 0
        }
        return 1
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("When did you visit?")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    // Start Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Visit Date")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        DatePicker("", selection: $visitDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .accentColor(Color(hex: "FF0080"))
                    }
                    
                    // Multi-day trip toggle
                    Toggle("Multi-day trip", isOn: $hasEndDate)
                        .font(.system(size: 16, weight: .medium))
                        .onChange(of: hasEndDate) { enabled in
                            if enabled && endDate < visitDate {
                                endDate = visitDate.addingTimeInterval(24 * 60 * 60) // Add 1 day
                            }
                        }
                    
                    if hasEndDate {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("End Date")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            DatePicker("", selection: $endDate, in: visitDate..., displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .accentColor(Color(hex: "0080FF"))
                                .onChange(of: visitDate) { newVisitDate in
                                    if endDate < newVisitDate {
                                        endDate = newVisitDate.addingTimeInterval(24 * 60 * 60)
                                    }
                                }
                        }
                        
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(Color(hex: "FF0080"))
                            Text("Trip duration: \(duration) days")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
            .padding(.top)
        }
    }
}

struct TripDetailsSection: View {
    @Binding var rating: Int
    @Binding var tripType: TripType
    @Binding var weather: Weather
    @Binding var budget: String
    @Binding var accommodation: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Trip Details")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    // Rating
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rating")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 10) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .font(.title2)
                                    .foregroundColor(star <= rating ? .yellow : .gray.opacity(0.3))
                                    .onTapGesture {
                                        rating = star
                                    }
                            }
                        }
                    }
                    
                    // Trip Type
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Trip Type")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                            ForEach(TripType.allCases, id: \.self) { type in
                                Button(action: { tripType = type }) {
                                    Text(type.rawValue)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(tripType == type ? .white : .primary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(tripType == type ? Color(hex: "FF0080") : Color.gray.opacity(0.1))
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                    
                    // Weather
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weather")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Picker("Weather", selection: $weather) {
                            ForEach(Weather.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Budget
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Budget (Optional)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        TextField("Total spent in USD", text: $budget)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 16))
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    
                    // Accommodation
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Where did you stay?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        TextField("Hotel name, Airbnb, etc.", text: $accommodation)
                            .font(.system(size: 16))
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
            .padding(.top)
        }
    }
}

struct ActivitiesSection: View {
    @Binding var selectedActivities: Set<Activity>
    
    let activityCategories: [(name: String, activities: [Activity])] = [
        ("Adventure", [.hiking, .diving, .skiing, .surfing, .wildlife, .adventure]),
        ("Culture", [.sightseeing, .museum, .culture, .foodTour, .festival]),
        ("Relaxation", [.swimming, .relaxing, .wellness, .shopping]),
        ("Other", [.nightlife, .photography, .sports])
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("What did you do?")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(activityCategories, id: \.name) { category in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(category.name)
                                .font(.headline)
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                                ForEach(category.activities, id: \.self) { activity in
                                    Button(action: {
                                        if selectedActivities.contains(activity) {
                                            selectedActivities.remove(activity)
                                        } else {
                                            selectedActivities.insert(activity)
                                        }
                                    }) {
                                        Text(activity.rawValue)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(selectedActivities.contains(activity) ? .white : .primary)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(selectedActivities.contains(activity) ? Color(hex: "FF0080") : Color.gray.opacity(0.1))
                                            .cornerRadius(20)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                if !selectedActivities.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Selected: \(selectedActivities.count)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Text(selectedActivities.map { $0.rawValue }.sorted().joined(separator: ", "))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
                
                Spacer(minLength: 100)
            }
            .padding(.top)
        }
    }
}

struct PeopleNotesSection: View {
    @Binding var companions: [String]
    @Binding var newCompanion: String
    @Binding var notes: String
    @Binding var highlights: [String]
    @Binding var newHighlight: String
    @Binding var wouldRevisit: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("People & Memories")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    // Companions
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Who did you travel with?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        HStack {
                            TextField("Add companion", text: $newCompanion)
                                .font(.system(size: 16))
                            
                            Button(action: {
                                if !newCompanion.isEmpty {
                                    companions.append(newCompanion)
                                    newCompanion = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color(hex: "FF0080"))
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        
                        if !companions.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(companions, id: \.self) { companion in
                                        HStack {
                                            Text(companion)
                                            Button(action: {
                                                companions.removeAll { $0 == companion }
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(15)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Highlights
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Trip Highlights")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        HStack {
                            TextField("Add highlight", text: $newHighlight)
                                .font(.system(size: 16))
                            
                            Button(action: {
                                if !newHighlight.isEmpty {
                                    highlights.append(newHighlight)
                                    newHighlight = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color(hex: "FF0080"))
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        
                        ForEach(highlights, id: \.self) { highlight in
                            HStack {
                                Text("• \(highlight)")
                                    .font(.system(size: 14))
                                Spacer()
                                Button(action: {
                                    highlights.removeAll { $0 == highlight }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    
                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        TextEditor(text: $notes)
                            .font(.system(size: 16))
                            .frame(minHeight: 100)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    
                    // Would Revisit
                    Toggle("Would you go back?", isOn: $wouldRevisit)
                        .font(.system(size: 16, weight: .medium))
                }
                .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
            .padding(.top)
        }
    }
}

struct TagsReviewSection: View {
    @Binding var tags: [String]
    @Binding var newTag: String
    let record: TravelRecord
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Tags & Review")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.horizontal)
                
                // Tags
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add Tags")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    HStack {
                        TextField("Add tag", text: $newTag)
                            .font(.system(size: 16))
                        
                        Button(action: {
                            if !newTag.isEmpty {
                                tags.append(newTag)
                                newTag = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color(hex: "FF0080"))
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    if !tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(tags, id: \.self) { tag in
                                    HStack {
                                        Text("#\(tag)")
                                        Button(action: {
                                            tags.removeAll { $0 == tag }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(15)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Review Summary
                VStack(alignment: .leading, spacing: 15) {
                    Text("Review Your Trip")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(Color(hex: "FF0080"))
                            Text("\(record.name), \(record.country)")
                                .font(.system(size: 16, weight: .medium))
                        }
                        
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(Color(hex: "0080FF"))
                            Text(record.visitDate.formatted(.dateTime.month().day().year()))
                            if let endDate = record.endDate {
                                Text("- \(endDate.formatted(.dateTime.month().day().year()))")
                            }
                        }
                        .font(.system(size: 14))
                        
                        HStack {
                            ForEach(0..<5) { star in
                                Image(systemName: star < record.rating ? "star.fill" : "star")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                            }
                            
                            Spacer()
                            
                            Text(record.tripType.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                        
                        if !record.activities.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(record.activities, id: \.self) { activity in
                                        Text(activity.rawValue)
                                            .font(.caption)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color(hex: "FF0080").opacity(0.1))
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
            .padding(.top)
        }
    }
}

#Preview {
    AddTravelRecordView()
        .environmentObject(TravelData())
}