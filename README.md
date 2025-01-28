# CKAppRating

CKAppRating is a modern and customizable rating/review component framework for iOS applications built with SwiftUI.

## Features

- 📱 Modern SwiftUI design
- ⭐️ Customizable rating icons (SF Symbols, Assets, or Custom)
- 🌈 Customizable colors and sizes
- 🌍 Multi-language support (English, Turkish, German, French, Spanish, Chinese)
- 📝 App Store review integration
- ✨ Beautiful animations
- 🎨 Light/Dark mode support

## Installation

### Swift Package Manager

1. Open your project in Xcode
2. Go to File > Add Packages...
3. Paste the following URL in the search bar:  https://github.com/yourusername/CKAppRating.git
4. Click Add Package


## Usage
### Basic Implementation

CKAppRating can be implemented in two ways: as a standalone rating view or as a popup rating dialog.

#### 1. Standalone Rating View

import SwiftUI
import CKAppRating
struct ContentView: View {
@State private var rating: Int = 0
    var body: some View {
        RatingView(
            maxRating: 5, // Maximum rating value
            currentRating: $rating, // Binding to store the rating
            width: 30, // Size of each star
            color: .systemYellow // Color of the stars
            )
    }
}


#### 2. Popup Rating Dialog

import SwiftUI
import CKAppRating
struct ContentView: View {
@State private var showRatingPopup = false
    var body: some View {
        Button("Rate Our App") {
            showRatingPopup = true
        }
        .presentRatingPopup(
            isPresented: $showRatingPopup // Controls popup visibility
        ) { rating in
            // Handle the rating value here
            print("User selected rating) stars") 
        } 
    } 
}
# CKAppRating
