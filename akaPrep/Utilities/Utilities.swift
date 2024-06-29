//
//  Utilities.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/26/24.
//

import Foundation

struct DateUtils {
    static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
