import SwiftUI
import StoreKit

public struct RatingPopupView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var rating: Int = 0
    @State private var isAnimating = false
    @State private var localizedRateApp: String = ""
    @State private var localizedDescription: String = ""
    @State private var localizedSubmit: String = ""
    @State private var isTextLoaded = false
    
    let title: String?
    let subtitle: String?
    let ratingImage: RatingImage
    let onRatingSelected: (Int) -> Void
    let shouldRequestAppStoreReview: Bool
    
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        ratingImage: RatingImage = .system(name: "star"),
        shouldRequestAppStoreReview: Bool = true,
        onRatingSelected: @escaping (Int) -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.ratingImage = ratingImage
        self.shouldRequestAppStoreReview = shouldRequestAppStoreReview
        self.onRatingSelected = onRatingSelected
    }
    
    private func loadLocalizedStrings() async {
        localizedRateApp = await LocalizedStrings.localizedString(.rateApp)
        localizedDescription = await LocalizedStrings.localizedString(.rateAppDescription)
        localizedSubmit = await LocalizedStrings.localizedString(.submit)
        isTextLoaded = true
    }
    
    public var body: some View {
        Group {
            if isTextLoaded {
                VStack(spacing: 20) {
                    // Header
                    Text(title ?? localizedRateApp)
                        .font(.title2)
                        .bold()
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : 20)
                        .padding(.top)
                    
                    Text(subtitle ?? localizedDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : 20)
                    
                    // Rating View
                    RatingView(
                        maxRating: 5,
                        currentRating: $rating,
                        width: 35,
                        color: .systemYellow,
                        ratingImage: ratingImage
                    )
                    .padding(.vertical, 20)
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1 : 0.5)
                    
                    // Submit Button
                    if rating > 0 {
                        Button(action: submitRating) {
                            Text(localizedSubmit)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 20)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.top, 10)
                        .padding(.bottom)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .animation(.spring(), value: rating)
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(radius: 20)
                )
                .frame(width: min(UIScreen.main.bounds.width - 60, 340))
            } else {
                ProgressView()
                    .frame(width: min(UIScreen.main.bounds.width - 60, 340))
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(UIColor.systemBackground))
                            .shadow(radius: 20)
                    )
            }
        }
        .onAppear {
            Task {
                await loadLocalizedStrings()
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isAnimating = true
                }
            }
        }
    }
    
    private func submitRating() {
        // Önce rating'i callback ile gönder ve popup'ın kapanmasını sağla
        onRatingSelected(rating)
        
        // 4 ve 5 yıldız için App Store review isteği
        if shouldRequestAppStoreReview && rating >= 4 {
            if let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
}

// Preview Provider
struct RatingPopupView_Previews: PreviewProvider {
    static var previews: some View {
        Color.black.opacity(0.2)
            .overlay(
                RatingPopupView(onRatingSelected: { _ in })
            )
    }
} 