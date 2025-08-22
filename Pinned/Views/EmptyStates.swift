import SwiftUI

struct EmptyStatesView: View {
    let state: EmptyState
    let action: (() -> Void)?
    
    enum EmptyState {
        case noTravelRecords
        case noVisitedCountries
        case noPhotos
        case noSearchResults
        case noInternetConnection
        case loadingError
        
        var title: String {
            switch self {
            case .noTravelRecords:
                return "No Travel Records Yet"
            case .noVisitedCountries:
                return "World Awaits You"
            case .noPhotos:
                return "No Travel Photos"
            case .noSearchResults:
                return "No Results Found"
            case .noInternetConnection:
                return "Connection Lost"
            case .loadingError:
                return "Something Went Wrong"
            }
        }
        
        var description: String {
            switch self {
            case .noTravelRecords:
                return "Start tracking your adventures by adding your first travel destination. Every journey begins with a single step!"
            case .noVisitedCountries:
                return "The world is full of amazing places waiting to be discovered. Add your first destination to start your travel journey."
            case .noPhotos:
                return "Capture your travel memories by adding photos to your destinations. Pictures tell the story of your adventures."
            case .noSearchResults:
                return "We couldn't find any destinations matching your search. Try adjusting your search terms or explore our suggestions."
            case .noInternetConnection:
                return "Please check your internet connection and try again. Some features may not work while offline."
            case .loadingError:
                return "We encountered an error while loading your data. Please try again or contact support if the problem persists."
            }
        }
        
        var systemImage: String {
            switch self {
            case .noTravelRecords:
                return "map"
            case .noVisitedCountries:
                return "globe.americas"
            case .noPhotos:
                return "photo.on.rectangle.angled"
            case .noSearchResults:
                return "magnifyingglass"
            case .noInternetConnection:
                return "wifi.slash"
            case .loadingError:
                return "exclamationmark.triangle"
            }
        }
        
        var actionTitle: String? {
            switch self {
            case .noTravelRecords:
                return "Add First Destination"
            case .noVisitedCountries:
                return "Explore Countries"
            case .noPhotos:
                return "Add Photos"
            case .noSearchResults:
                return "Clear Search"
            case .noInternetConnection:
                return "Try Again"
            case .loadingError:
                return "Retry"
            }
        }
        
        var primaryColor: Color {
            switch self {
            case .noInternetConnection, .loadingError:
                return .accessibleError
            default:
                return .accessiblePrimary
            }
        }
    }
    
    init(_ state: EmptyState, action: (() -> Void)? = nil) {
        self.state = state
        self.action = action
    }
    
    var body: some View {
        AccessibleEmptyState(
            title: state.title,
            description: state.description,
            systemImage: state.systemImage,
            actionTitle: state.actionTitle,
            action: action
        )
    }
}

struct LoadingStateView: View {
    let message: String
    let showProgress: Bool
    @State private var animationAmount = 1.0
    
    init(message: String = "Loading your travel data...", showProgress: Bool = true) {
        self.message = message
        self.showProgress = showProgress
    }
    
    var body: some View {
        VStack(spacing: 24) {
            if showProgress {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 4)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [Color.accessiblePrimary, Color.accessiblePrimary.opacity(0.3)],
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                        .rotationEffect(.degrees(animationAmount * 360))
                        .animation(
                            .linear(duration: 1.5).repeatForever(autoreverses: false),
                            value: animationAmount
                        )
                }
                .accessibilityLabel("Loading indicator")
            }
            
            VStack(spacing: 8) {
                Text(message)
                    .font(.accessibleHeadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("This may take a moment...")
                    .font(.accessibleCaption)
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(message + " This may take a moment")
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            animationAmount = 1.0
        }
    }
}

struct ErrorStateView: View {
    let error: Error
    let onRetry: (() -> Void)?
    let onDismiss: (() -> Void)?
    
    init(error: Error, onRetry: (() -> Void)? = nil, onDismiss: (() -> Void)? = nil) {
        self.error = error
        self.onRetry = onRetry
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.accessibleError)
                .accessibilityHidden(true)
            
            VStack(spacing: 12) {
                Text("Oops! Something went wrong")
                    .font(.accessibleTitle)
                    .multilineTextAlignment(.center)
                    .accessibleHeader(level: .h2)
                
                Text(error.localizedDescription)
                    .font(.accessibleBody)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("Error details: \(error.localizedDescription)")
            }
            
            VStack(spacing: 12) {
                if let onRetry = onRetry {
                    AccessibleButton("Try Again", systemImage: "arrow.clockwise") {
                        onRetry()
                    }
                }
                
                if let onDismiss = onDismiss {
                    AccessibleButton("Dismiss", style: .secondary) {
                        onDismiss()
                    }
                }
            }
            .padding(.horizontal, 40)
        }
        .padding(40)
        .accessibilityElement(children: .contain)
    }
}

struct NoDataPlaceholder: View {
    let title: String
    let systemImage: String
    let description: String
    let buttonTitle: String?
    let action: (() -> Void)?
    
    init(
        title: String,
        systemImage: String,
        description: String,
        buttonTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.systemImage = systemImage
        self.description = description
        self.buttonTitle = buttonTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: systemImage)
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.6))
                .accessibilityHidden(true)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .accessibleHeader(level: .h2)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .accessibilityLabel(description)
            }
            
            if let buttonTitle = buttonTitle, let action = action {
                AccessibleButton(buttonTitle) {
                    action()
                }
                .padding(.horizontal, 60)
            }
        }
        .padding(40)
        .accessibilityElement(children: .contain)
    }
}

struct PullToRefreshView<Content: View>: View {
    let content: Content
    let onRefresh: () async -> Void
    @State private var isRefreshing = false
    
    init(@ViewBuilder content: () -> Content, onRefresh: @escaping () async -> Void) {
        self.content = content()
        self.onRefresh = onRefresh
    }
    
    var body: some View {
        ScrollView {
            content
        }
        .refreshable {
            isRefreshing = true
            await onRefresh()
            isRefreshing = false
        }
        .accessibilityLabel("Pull to refresh content")
        .accessibilityHint("Swipe down to refresh the data")
    }
}

// MARK: - Search Empty State

struct SearchEmptyState: View {
    let searchQuery: String
    let onClearSearch: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
                .accessibilityHidden(true)
            
            VStack(spacing: 8) {
                Text("No results for \"\(searchQuery)\"")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .accessibleHeader(level: .h2)
                
                Text("Try searching for a different destination or check your spelling.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            AccessibleButton("Clear Search", style: .secondary) {
                onClearSearch()
            }
            .padding(.horizontal, 40)
        }
        .padding(40)
    }
}

// MARK: - Offline State

struct OfflineStateView: View {
    let onRetry: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 60))
                .foregroundColor(.orange)
                .accessibilityHidden(true)
            
            VStack(spacing: 12) {
                Text("You're Offline")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .accessibleHeader(level: .h2)
                
                Text("Some features may not be available while you're offline. Check your internet connection and try again.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let onRetry = onRetry {
                AccessibleButton("Try Again", systemImage: "arrow.clockwise") {
                    onRetry()
                }
                .padding(.horizontal, 40)
            }
        }
        .padding(40)
    }
}

#Preview {
    VStack(spacing: 20) {
        EmptyStatesView(.noTravelRecords) {
            print("Add destination tapped")
        }
        
        LoadingStateView(message: "Loading your adventures...")
        
        ErrorStateView(error: NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "This is a test error message"])) {
            print("Retry tapped")
        } onDismiss: {
            print("Dismiss tapped")
        }
    }
}