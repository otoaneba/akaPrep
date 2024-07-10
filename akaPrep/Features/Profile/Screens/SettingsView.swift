//
//  SettingsView.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/10/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Picker("Color Scheme", selection: $viewModel.selectedColorScheme) {
                        ForEach(ColorSchemeOption.allCases) { option in
                            Text(option.rawValue.capitalized).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
