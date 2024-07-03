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
