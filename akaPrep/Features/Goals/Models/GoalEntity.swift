//
//  GoalEntity.swift
//  akaPrep
//
//  Created by Mengyuan Cynthia Li on 2024-07-03.
//

import Foundation
import CoreData

// Assuming GoalEntity is generated, we extend it here.
extension GoalEntity {
    var frequency: Frequency {
        get {
            return Frequency(rawValue: type ?? Frequency.daily.rawValue) ?? .daily
        }
        set {
            type = newValue.rawValue
        }
    }
}
