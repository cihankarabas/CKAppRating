//
//  RatingImage.swift
//  AppRatingTest
//
//  Created by Cihan on 25.01.2025.
//

import SwiftUI

public enum RatingImage {
    case system(name: String) // SFSymbols kullanımı için
    case asset(name: String)  // Proje bundle'ındaki assetler için
    case custom(name: String) // Dışarıdan isimle gönderilen image'ler için
    
    // computed properties to generate the correct filled or open images
    func fillImage() -> Image {
        switch self {
        case .system(let name):
            return Image(systemName: name + ".fill")
        case .asset(let name):
            return Image(name + ".fill", bundle: .module)
        case .custom(let name):
            return Image(name + ".fill")
        }
    }

    func openImage() -> Image {
        switch self {
        case .system(let name):
            return Image(systemName: name)
        case .asset(let name):
            return Image(name, bundle: .module)
        case .custom(let name):
            return Image(name)
        }
    }
}
