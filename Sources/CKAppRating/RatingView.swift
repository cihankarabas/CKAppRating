//
//  RatingView.swift
//  AppRatingTest
//
//  Created by Cihan on 25.01.2025.
//

import SwiftUI

/// A view of inline images that represents a rating.
/// Tapping on an image will change it from an unfilled to a filled version of the image.
///
/// The following example shows a RatingView view with a maximum rating of 10 red stars:
///
///     RatingView(maxRating: 10,
///              currentRating: $currentRating,
///              width: 20,
///              color: .red,
///              ratingImage: .system(name: "star"))
///
///
public struct RatingView: View {
    var maxRating: Int
    @Binding var currentRating: Int
    var width: Int
    var color: UIColor
    var ratingImage: RatingImage
    
    /// Only two required parameters are maxRating and the binding to currentRating.  All other parameters have default values
    /// - Parameters:
    ///   - maxRating: The maximum rating on the scale
    ///   - currentRating: A binding to the current rating variable
    ///   - width: The width of the image used for the rating  (Default - 20)
    ///   - color: The color of the image (Default - systemYellow)
    ///   - ratingImage: The image to be used for rating. Can be a system image (SF Symbols), 
    ///     an asset from the bundle, or a custom image. (Default - .system(name: "star"))
    ///     Examples:
    ///     - .system(name: "heart") for SF Symbols
    ///     - .asset(name: "baseball") for bundle assets
    ///     - .custom(name: "customStar") for custom images
    ///
    public init(
        maxRating: Int,
        currentRating: Binding<Int>,
        width: Int = 20,
        color: UIColor = .systemYellow,
        ratingImage: RatingImage = .system(name: "star")
    ) {
        self.maxRating = maxRating
        self._currentRating = currentRating
        self.width = width
        self.color = color
        self.ratingImage = ratingImage
    }

    public var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<maxRating, id: \.self) { rating in
                correctImage(for: rating)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: CGFloat(width), height: CGFloat(width))
                    .foregroundColor(Color(color))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            self.currentRating = rating + 1
                        }
                    }
            }
        }
        .frame(height: CGFloat(width))
    }
    
    func correctImage(for rating: Int) -> Image {
        if rating < currentRating {
            return ratingImage.fillImage()
        } else {
            return ratingImage.openImage()
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(maxRating: 5, currentRating: .constant(3))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
