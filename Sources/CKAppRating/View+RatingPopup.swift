import SwiftUI

public extension View {
    func presentRatingPopup(
        isPresented: Binding<Bool>,
        title: String? = nil,
        subtitle: String? = nil,
        ratingImage: RatingImage = .system(name: "star"),
        shouldRequestAppStoreReview: Bool = true,
        onRatingSelected: @escaping (Int) -> Void
    ) -> some View {
        self.overlay {
            if isPresented.wrappedValue {
                GeometryReader { geometry in
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                isPresented.wrappedValue = false
                            }
                        }
                        .zIndex(0)
                    
                    RatingPopupView(
                        title: title,
                        subtitle: subtitle,
                        ratingImage: ratingImage,
                        shouldRequestAppStoreReview: shouldRequestAppStoreReview,
                        onRatingSelected: { rating in
                            onRatingSelected(rating)
                            withAnimation {
                                isPresented.wrappedValue = false
                            }
                        }
                    )
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height / 2
                    )
                    .zIndex(1)
                }
                .transition(.scale(scale: 0.8).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented.wrappedValue)
    }
}

struct PopupModifier_Previews: PreviewProvider {
    static var previews: some View {
        Color.white
            .presentRatingPopup(
                isPresented: .constant(true)
            ) { _ in }
    }
} 
