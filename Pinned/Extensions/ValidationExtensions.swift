import Foundation

// MARK: - Input Validation

enum ValidationError: LocalizedError {
    case invalidDestination
    case invalidCountry
    case invalidBudget
    case invalidDateRange
    case invalidRating
    case emptyRequiredField(field: String)
    case stringTooLong(field: String, maxLength: Int)
    case stringTooShort(field: String, minLength: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidDestination:
            return "Please enter a valid destination name"
        case .invalidCountry:
            return "Please enter a valid country name"
        case .invalidBudget:
            return "Budget must be a positive number"
        case .invalidDateRange:
            return "End date must be after start date"
        case .invalidRating:
            return "Rating must be between 1 and 5"
        case .emptyRequiredField(let field):
            return "\(field) is required"
        case .stringTooLong(let field, let maxLength):
            return "\(field) must be \(maxLength) characters or less"
        case .stringTooShort(let field, let minLength):
            return "\(field) must be at least \(minLength) characters"
        }
    }
}

extension String {
    func isValidDestination() -> Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.count >= 2 && trimmed.count <= 100
    }
    
    func isValidCountry() -> Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.count >= 2 && trimmed.count <= 60
    }
    
    func sanitized() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\t", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
    }
    
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}

extension Double {
    func isValidBudget() -> Bool {
        return self >= 0 && self <= 1_000_000
    }
}

extension Int {
    func isValidRating() -> Bool {
        return self >= 1 && self <= 5
    }
}

extension Date {
    func isValidTravelDate() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let hundredYearsAgo = calendar.date(byAdding: .year, value: -100, to: now) ?? now
        let oneYearFromNow = calendar.date(byAdding: .year, value: 1, to: now) ?? now
        
        return self >= hundredYearsAgo && self <= oneYearFromNow
    }
}

// MARK: - TravelRecord Validation

extension TravelRecord {
    func validate() throws {
        // Validate destination
        if !name.isValidDestination() {
            throw ValidationError.invalidDestination
        }
        
        // Validate country
        if !country.isValidCountry() {
            throw ValidationError.invalidCountry
        }
        
        // Validate rating
        if !rating.isValidRating() {
            throw ValidationError.invalidRating
        }
        
        // Validate budget
        if let budget = budget, !budget.isValidBudget() {
            throw ValidationError.invalidBudget
        }
        
        // Validate date range
        if let endDate = endDate, endDate < visitDate {
            throw ValidationError.invalidDateRange
        }
        
        // Validate notes length
        if notes.count > 1000 {
            throw ValidationError.stringTooLong(field: "Notes", maxLength: 1000)
        }
        
        // Validate activities
        for activity in activities {
            if activity.count > 50 {
                throw ValidationError.stringTooLong(field: "Activity", maxLength: 50)
            }
        }
        
        // Validate companions
        for companion in companions {
            if companion.count > 50 {
                throw ValidationError.stringTooLong(field: "Companion", maxLength: 50)
            }
        }
    }
    
    func sanitized() -> TravelRecord {
        var sanitized = self
        sanitized.name = name.sanitized()
        sanitized.country = country.sanitized()
        sanitized.notes = notes.sanitized()
        sanitized.activities = activities.map { $0.sanitized() }.filter { !$0.isEmpty }
        sanitized.companions = companions.map { $0.sanitized() }.filter { !$0.isEmpty }
        sanitized.highlights = highlights.map { $0.sanitized() }.filter { !$0.isEmpty }
        
        return sanitized
    }
}