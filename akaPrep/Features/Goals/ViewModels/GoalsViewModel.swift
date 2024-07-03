//
//  GoalsViewModel.swift
//  akaPrep
//
//  Created by Mengyuan Cynthia Li on 2024-07-03.
//

import Foundation
import CoreData
import SwiftUI

class GoalsViewModel: ObservableObject {
    @Published var selectedSegment = Frequency.daily.rawValue
    @Published var dailyGoal = ""
    @Published var weeklyGoal = ""
    @Published var monthlyGoal = ""
    
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        loadGoals()
    }
    
    private func loadGoals() {
        let fetchRequest: NSFetchRequest<GoalEntity> = GoalEntity.fetchRequest()
        do {
            let goals = try context.fetch(fetchRequest)
            for goal in goals {
                switch goal.frequency {
                case .daily:
                    dailyGoal = goal.title ?? ""
                case .weekly:
                    weeklyGoal = goal.title ?? ""
                case .monthly:
                    monthlyGoal = goal.title ?? ""
                }
            }
        } catch {
            print("Failed to fetch goals: \(error)")
        }
    }
    
    func saveGoal() {
        let fetchRequest: NSFetchRequest<GoalEntity> = GoalEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@", selectedSegment)
        
        do {
            let results = try context.fetch(fetchRequest)
            let goal: GoalEntity
            if let existingGoal = results.first {
                goal = existingGoal
            } else {
                goal = GoalEntity(context: context)
                goal.id = UUID()
                goal.type = selectedSegment
            }
            goal.title = currentGoalText()
            try context.save()
            print("\(selectedSegment.capitalized) goal saved!")
        } catch {
            print("Failed to save goal: \(error)")
        }
    }
    
    private func currentGoalText() -> String {
        switch selectedSegment {
        case Frequency.daily.rawValue:
            return dailyGoal
        case Frequency.weekly.rawValue:
            return weeklyGoal
        case Frequency.monthly.rawValue:
            return monthlyGoal
        default:
            return ""
        }
    }
    
    func bindingForSelectedSegment() -> Binding<String> {
        switch selectedSegment {
        case Frequency.daily.rawValue:
            return Binding(
                get: { self.dailyGoal },
                set: { self.dailyGoal = $0 }
            )
        case Frequency.weekly.rawValue:
            return Binding(
                get: { self.weeklyGoal },
                set: { self.weeklyGoal = $0 }
            )
        case Frequency.monthly.rawValue:
            return Binding(
                get: { self.monthlyGoal },
                set: { self.monthlyGoal = $0 }
            )
        default:
            return Binding(
                get: { self.dailyGoal },
                set: { self.dailyGoal = $0 }
            )
        }
    }
}
