//
//  AkaListViewViewModel.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/26/24.
//

import Foundation
import CoreData

class AkaPrepViewViewModel: ObservableObject {
    @Published var showingAddNewTaskView = false
    @Published var dailyTasks: [TaskEntity] = []
    @Published var weeklyTasks: [TaskEntity] = []
    @Published var monthlyTasks: [TaskEntity] = []
    @Published var selectedTaskType: String = "daily"
    
    private let context: NSManagedObjectContext
    
    private let openAIService = OpenAIService()
    
    func generateTasks(taskType: String, context: String) {
        print(taskType)
        let prompt = PromptTemplate.generatePrompt(taskType: taskType, context: context)
        openAIService.fetchTasks(prompt: prompt) { [weak self] generatedTasks in
            DispatchQueue.main.async {
                guard let self = self else { return }
                // Clear existing tasks of the same type
                self.clearTasks(ofType: taskType)
                switch taskType {
                case "daily":
//                    self.dailyTasks = generatedTasks.map { TaskEntity(context: self.context, title: $0)}
                    let list = self.fetchOrCreateList(for: .daily)
                    list.addToTasks(NSSet(array: generatedTasks.map { TaskEntity(context: self.context, title: $0, taskType: "daily") }))
                    self.dailyTasks = list.taskArray
                case "weekly":
//                    self.weeklyTasks = generatedTasks.map { TaskEntity(context: self.context, title: $0) }
                    let list = self.fetchOrCreateList(for: .weekly)
                    list.addToTasks(NSSet(array: generatedTasks.map { TaskEntity(context: self.context, title: $0, taskType: "weekly") }))
                    self.weeklyTasks = list.taskArray
                case "monthly":
//                    self.monthlyTasks = generatedTasks.map { TaskEntity(context: self.context, title: $0) }
                    let list = self.fetchOrCreateList(for: .monthly)
                    list.addToTasks(NSSet(array: generatedTasks.map { TaskEntity(context: self.context, title: $0, taskType: "monthly") }))
                    self.monthlyTasks = list.taskArray
                default:
//                    self.dailyTasks = generatedTasks.map { TaskEntity(context: self.context, title: $0) }
                    break
                }
                
            }
        }
    }
    
    var tasksForSelectedType: [TaskEntity] {
         switch selectedTaskType {
         case "daily":
             return dailyTasks
         case "weekly":
             return weeklyTasks
         case "monthly":
             return monthlyTasks
         default:
             return []
         }
     }
    
    init(context: NSManagedObjectContext) {
         self.context = context
     }
    
    func toggleTaskCompletion(task: TaskEntity) {
        task.isCompleted.toggle()
        saveContext()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    private func clearTasks(ofType type: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "taskType == %@", type)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to delete existing tasks: \(error)")
        }
    }
    
    private func loadTasks() {
        let fetchRequest: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        
        do {
            let lists = try context.fetch(fetchRequest)
            for list in lists {
                switch list.frequency {
                case .daily:
                    self.dailyTasks = list.taskArray
                case .weekly:
                    self.weeklyTasks = list.taskArray
                case .monthly:
                    self.monthlyTasks = list.taskArray
                }
            }
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }

    private func fetchOrCreateList(for frequency: ListEntity.Frequency) -> ListEntity {
        let fetchRequest: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "frequencyRaw == %@", frequency.rawValue)
        
        do {
            let lists = try context.fetch(fetchRequest)
            if let list = lists.first {
                return list
            }
        } catch {
            print("Failed to fetch list: \(error)")
        }
        
        // Create new list if it doesn't exist
        let list = ListEntity(context: context)
        list.name = "\(frequency.rawValue.capitalized) Tasks"
        list.frequency = frequency
        list.expirationDate = Date().addingTimeInterval(24 * 60 * 60 * (frequency == .daily ? 1 : (frequency == .weekly ? 7 : 30))) // Example expiration logic
        return list
    }

}

struct TaskItem: Identifiable {
    let id = UUID()
    let title: String
    var isCompleted: Bool = false
}
