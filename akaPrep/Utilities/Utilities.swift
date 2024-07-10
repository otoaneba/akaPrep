//
//  Utilities.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/26/24.
//

import SwiftUI

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
