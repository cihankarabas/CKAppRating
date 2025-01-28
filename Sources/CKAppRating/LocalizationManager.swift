import Foundation

public enum Language: String, Sendable {
    case english = "en"
    case turkish = "tr"
    case german = "de"
    case french = "fr"
    case spanish = "es"
    case chinese = "zh"
    
    public static var current: Language {
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        return Language(rawValue: languageCode) ?? .english
    }
}

public enum LocalizationKey: Sendable {
    case rateApp
    case rateAppDescription
    case submit
}

public actor LocalizationManager {
    private static let shared = LocalizationManager()
    private var customLocalizations: [LocalizationKey: [Language: String]] = [:]
    private var forcedLanguage: Language?
    
    private let defaultLocalizations: [LocalizationKey: [Language: String]] = [
        .rateApp: [
            .english: "Rate App",
            .turkish: "Uygulamayı Değerlendirin",
            .german: "App bewerten",
            .french: "Évaluer l'application",
            .spanish: "Calificar aplicación",
            .chinese: "评价应用"
        ],
        .rateAppDescription: [
            .english: "Tap the stars to rate your experience",
            .turkish: "Deneyiminizi puanlamak için yıldızlara dokunun",
            .german: "Tippen Sie auf die Sterne, um Ihre Erfahrung zu bewerten",
            .french: "Touchez les étoiles pour évaluer votre expérience",
            .spanish: "Toca las estrellas para calificar tu experiencia",
            .chinese: "点击星星为您的体验打分"
        ],
        .submit: [
            .english: "Submit",
            .turkish: "Gönder",
            .german: "Senden",
            .french: "Envoyer",
            .spanish: "Enviar",
            .chinese: "提交"
        ]
    ]
    
    public static func localizedString(_ key: LocalizationKey) async -> String {
        await shared.getString(for: key)
    }
    
    /// Belirli bir dili zorla kullan
    /// - Parameter language: Kullanılacak dil
    public static func forceLanguage(_ language: Language?) async {
        await shared.setForcedLanguage(language)
    }
    
    private func setForcedLanguage(_ language: Language?) {
        self.forcedLanguage = language
    }
    
    private func getCurrentLanguage() -> Language {
        if let forced = forcedLanguage {
            return forced
        }
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        return Language(rawValue: languageCode) ?? .english
    }
    
    private func getString(for key: LocalizationKey) -> String {
        // Önce özelleştirilmiş metinlere bak
        if let customTranslations = customLocalizations[key],
           let customText = customTranslations[getCurrentLanguage()] {
            return customText
        }
        
        // Özelleştirilmiş metin yoksa varsayılan metinleri kullan
        let translations = defaultLocalizations[key] ?? [:]
        return translations[getCurrentLanguage()] ?? translations[.english] ?? ""
    }
    
    /// Belirli bir anahtar için özelleştirilmiş metinleri ayarlar
    /// - Parameters:
    ///   - translations: Dil bazında özelleştirilmiş metinler
    ///   - key: Hangi metin türünün güncelleneceği
    public static func setCustomTranslations(_ translations: [Language: String], for key: LocalizationKey) async {
        await shared.setTranslations(translations, for: key)
    }
    
    private func setTranslations(_ translations: [Language: String], for key: LocalizationKey) {
        customLocalizations[key] = translations
    }
    
    /// Tüm özelleştirilmiş metinleri sıfırlar
    public static func resetToDefault() async {
        await shared.reset()
    }
    
    private func reset() {
        customLocalizations.removeAll()
    }
}

// Kullanım kolaylığı için extension
@frozen public struct LocalizedStrings {
    public static func localizedString(_ key: LocalizationKey) async -> String {
        await LocalizationManager.localizedString(key)
    }
    
    public static func setCustomTranslations(_ translations: [Language: String], for key: LocalizationKey) async {
        await LocalizationManager.setCustomTranslations(translations, for: key)
    }
    
    public static func resetToDefault() async {
        await LocalizationManager.resetToDefault()
    }
    
    public static func forceLanguage(_ language: Language?) async {
        await LocalizationManager.forceLanguage(language)
    }
} 