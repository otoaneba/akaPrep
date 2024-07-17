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
    @Published var originalDailyGoal = ""
    @Published var originalWeeklyGoal = ""
    @Published var originalMonthlyGoal = ""
    @Published var showToast: Bool = false
    @Published var toastState: ToastState = .none
    
    private let context: NSManagedObjectContext
    private var workItem: DispatchWorkItem?

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
                    originalDailyGoal = dailyGoal
                case .weekly:
                    weeklyGoal = goal.title ?? ""
                    originalWeeklyGoal = weeklyGoal
                case .monthly:
                    monthlyGoal = goal.title ?? ""
                    originalMonthlyGoal = monthlyGoal
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
            updateOriginalGoal()
            toastState = .listGoalSaved
            showToastCard()
            print("\(selectedSegment.capitalized) goal saved!")
        } catch {
            print("Failed to save goal: \(error)")
        }
    }
    
    private func updateOriginalGoal() {
        switch selectedSegment {
        case Frequency.daily.rawValue:
            originalDailyGoal = dailyGoal
        case Frequency.weekly.rawValue:
            originalWeeklyGoal = weeklyGoal
        case Frequency.monthly.rawValue:
            originalMonthlyGoal = monthlyGoal
        default:
            break
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
    
    func isSaveButtonDisabled() -> Bool {
        switch selectedSegment {
        case Frequency.daily.rawValue:
            return dailyGoal.isEmpty || dailyGoal == originalDailyGoal
        case Frequency.weekly.rawValue:
            return weeklyGoal.isEmpty || weeklyGoal == originalWeeklyGoal
        case Frequency.monthly.rawValue:
            return monthlyGoal.isEmpty || monthlyGoal == originalMonthlyGoal
        default:
            return true
        }
    }
    
    func showToastCard() {
        // Cancel any existing toast
        workItem?.cancel()
        withAnimation(.easeIn) {
            showToast.toggle()
        }
        
        // Provide haptic feedback
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        // Create a new work item to hide the toast after the duration
        let workTask = DispatchWorkItem { [weak self] in
            self?.dismissToast()
        }
        workItem = workTask
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workTask)
    }
    
    // Method to hide toast
    func dismissToast() {
        DispatchQueue.main.async {
            self.showToast = false
        }
    }
}
