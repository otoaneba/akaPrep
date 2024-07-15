//
//  Utilities.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/26/24.
//

import SwiftUI
import UIKit

struct DateUtils {
    static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

extension Color {
    static let customRed = Color(red: 193 / 255, green: 33 / 255, blue: 31 / 255)
}

struct KeyboardPreloader: UIViewRepresentable {
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        DispatchQueue.main.async {
            textField.becomeFirstResponder()
            textField.resignFirstResponder()
        }
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {}
}

public func preloadKeyboard() {
    // Create a hosting controller for the KeyboardPreloader view
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first {
        let hostingController = UIHostingController(rootView: KeyboardPreloader())
        window.addSubview(hostingController.view)
        hostingController.view.isHidden = true
    }
}
