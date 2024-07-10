//
//  SettingsViewModel.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/10/24.
//

import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var selectedColorScheme: ColorSchemeOption {
        didSet {
            UserDefaults.standard.set(selectedColorScheme.rawValue, forKey: "selectedColorScheme")
        }
    }
    
    init() {
        let savedScheme = UserDefaults.standard.string(forKey: "selectedColorScheme") ?? ColorSchemeOption.system.rawValue
        selectedColorScheme = ColorSchemeOption(rawValue: savedScheme) ?? .system
    }
    
    var colorScheme: ColorScheme? {
        switch selectedColorScheme {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
