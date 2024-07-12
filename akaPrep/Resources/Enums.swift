//
//  Enums.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/2/24.
//

import Foundation

public enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}

public enum WorkSchedule: String, CaseIterable {
    case fullTime = "Full-time"
    case partTime = "Part-time"
    case freelance = "Freelance"
    case unemployed = "Unemployed"
}

public enum Frequency: String, CaseIterable {
    case daily
    case weekly
    case monthly
}

enum ColorSchemeOption: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    var id: String { self.rawValue }
}

public enum ToastState: String, CaseIterable {
    case listLiked = "List saved successfully!"
    case listUnliked = "List unsaved successfully!"
    case listActivated = "List activated successfully!"
    case listDeactivated = "List deactivated successfully!"
    case listGoalSaved = "Goal saved successfully!"
    case none = ""
}
