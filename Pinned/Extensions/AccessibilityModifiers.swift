import SwiftUI

// MARK: - Accessibility Modifiers

extension View {
    func accessibleButton(label: String, hint: String? = nil, traits: AccessibilityTraits = []) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(.isButton)
            .accessibilityAddTraits(traits)
    }
    
    func accessibleImage(label: String, decorative: Bool = false) -> some View {
        if decorative {
            return self.accessibilityHidden(true)
        } else {
            return self
                .accessibilityLabel(label)
                .accessibilityAddTraits(.isImage)
        }
    }
    
    func accessibleHeader(level: AccessibilityHeadingLevel = .h1) -> some View {
        self
            .accessibilityAddTraits(.isHeader)
            .accessibilityHeading(level)
    }
    
    func accessibleValue(_ value: String) -> some View {
        self.accessibilityValue(value)
    }
    
    func accessibleStaticText(_ text: String) -> some View {
        self
            .accessibilityLabel(text)
            .accessibilityAddTraits(.isStaticText)
    }
}

// MARK: - Dynamic Type Support

extension Font {
    static func scaledFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        return .system(size: size, weight: weight, design: design)
    }
    
    static let accessibleTitle = Font.title.weight(.bold)
    static let accessibleHeadline = Font.headline.weight(.semibold)
    static let accessibleBody = Font.body
    static let accessibleCaption = Font.caption
}

// MARK: - Color Accessibility

extension Color {
    // WCAG AA compliant colors
    static let accessiblePrimary = Color(red: 0.0, green: 0.4, blue: 0.8) // 4.5:1 contrast ratio
    static let accessibleSecondary = Color(red: 0.2, green: 0.2, blue: 0.2) // 7:1 contrast ratio
    static let accessibleSuccess = Color(red: 0.0, green: 0.6, blue: 0.0) // Success green
    static let accessibleError = Color(red: 0.8, green: 0.0, blue: 0.0) // Error red
    static let accessibleWarning = Color(red: 0.8, green: 0.6, blue: 0.0) // Warning orange
    
    static func accessible(light: Color, dark: Color, highContrast: Color? = nil) -> Color {
        return Color(UIColor { traitCollection in
            if traitCollection.accessibilityContrast == .high, let highContrast = highContrast {
                return UIColor(highContrast)
            } else if traitCollection.userInterfaceStyle == .dark {
                return UIColor(dark)
            } else {
                return UIColor(light)
            }
        })
    }
}

// MARK: - Accessible Components

struct AccessibleCard<Content: View>: View {
    let title: String
    let description: String?
    let content: Content
    let action: (() -> Void)?
    
    init(title: String, description: String? = nil, action: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.description = description
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue(description ?? "")
        .accessibilityAddTraits(action != nil ? .isButton : .isStaticText)
        .onTapGesture {
            action?()
        }
    }
}

struct AccessibleTextField: View {
    let title: String
    let prompt: String
    @Binding var text: String
    let isRequired: Bool
    let keyboardType: UIKeyboardType
    let contentType: UITextContentType?
    
    init(
        _ title: String,
        text: Binding<String>,
        prompt: String = "",
        isRequired: Bool = false,
        keyboardType: UIKeyboardType = .default,
        contentType: UITextContentType? = nil
    ) {
        self.title = title
        self._text = text
        self.prompt = prompt
        self.isRequired = isRequired
        self.keyboardType = keyboardType
        self.contentType = contentType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if isRequired {
                    Text("*")
                        .foregroundColor(.red)
                        .accessibilityLabel("required")
                }
            }
            
            TextField(prompt, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(keyboardType)
                .textContentType(contentType)
                .accessibilityLabel(title)
                .accessibilityHint(isRequired ? "Required field" : "Optional field")
        }
        .accessibilityElement(children: .contain)
    }
}

struct AccessibleButton: View {
    let title: String
    let systemImage: String?
    let style: ButtonStyle
    let action: () -> Void
    
    enum ButtonStyle {
        case primary, secondary, destructive
        
        var backgroundColor: Color {
            switch self {
            case .primary: return .accessiblePrimary
            case .secondary: return .clear
            case .destructive: return .accessibleError
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary: return .white
            case .secondary: return .accessiblePrimary
            case .destructive: return .white
            }
        }
    }
    
    init(_ title: String, systemImage: String? = nil, style: ButtonStyle = .primary, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .accessibilityHidden(true)
                }
                
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(style.foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(style.backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style == .secondary ? style.foregroundColor : Color.clear, lineWidth: 2)
            )
        }
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
        .buttonStyle(PlainButtonStyle())
    }
}

struct AccessibleRating: View {
    @Binding var rating: Int
    let maxRating: Int
    let label: String
    
    init(rating: Binding<Int>, maxRating: Int = 5, label: String = "Rating") {
        self._rating = rating
        self.maxRating = maxRating
        self.label = label
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.headline)
                .accessibleHeader(level: .h3)
            
            HStack(spacing: 4) {
                ForEach(1...maxRating, id: \.self) { index in
                    Button {
                        rating = index
                    } label: {
                        Image(systemName: index <= rating ? "star.fill" : "star")
                            .foregroundColor(index <= rating ? .yellow : .gray)
                            .font(.title2)
                    }
                    .accessibilityLabel("\(index) star\(index == 1 ? "" : "s")")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint(index <= rating ? "Selected" : "Tap to select")
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(label): \(rating) out of \(maxRating) stars")
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment:
                    if rating < maxRating {
                        rating += 1
                    }
                case .decrement:
                    if rating > 0 {
                        rating -= 1
                    }
                @unknown default:
                    break
                }
            }
        }
    }
}

struct AccessibleEmptyState: View {
    let title: String
    let description: String
    let systemImage: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        title: String,
        description: String,
        systemImage: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.systemImage = systemImage
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundColor(.gray)
                .accessibilityHidden(true)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.accessibleTitle)
                    .multilineTextAlignment(.center)
                    .accessibleHeader(level: .h2)
                
                Text(description)
                    .font(.accessibleBody)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel(description)
            }
            
            if let actionTitle = actionTitle, let action = action {
                AccessibleButton(actionTitle, action: action)
                    .padding(.horizontal, 40)
            }
        }
        .padding(40)
        .accessibilityElement(children: .contain)
    }
}

// MARK: - Loading State

struct AccessibleLoadingView: View {
    let message: String
    
    init(message: String = "Loading...") {
        self.message = message
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
                .accessibilityLabel("Loading")
            
            Text(message)
                .font(.accessibleBody)
                .foregroundColor(.secondary)
                .accessibilityLabel(message)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Loading: \(message)")
    }
}