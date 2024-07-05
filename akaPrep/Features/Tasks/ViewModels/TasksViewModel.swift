//
//  AkaListViewViewModel.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/26/24.
//

import Foundation
import CoreData
import Combine

class TasksViewModel: ObservableObject {
    static let shared = TasksViewModel(context: PersistenceController.shared.container.viewContext, useSampleData: true)
    
    @Published var showingAddNewTaskView = false
    @Published var dailyTasks: [TaskEntity] = []
    @Published var weeklyTasks: [TaskEntity] = []
    @Published var monthlyTasks: [TaskEntity] = []
    @Published var selectedTaskType: String = "daily"
    
    let listSavedSubject = PassthroughSubject<Void, Never>() // Publisher to notify list saved
    
    private let context: NSManagedObjectContext
    private let openAIService: OpenAIService
    private static var sampleDataLoaded = false // Static flag to check if sample data is already loaded
    
    init(context: NSManagedObjectContext, useSampleData: Bool = false) {
        self.context = context
        self.openAIService = OpenAIService()
        
        // for LLM testing
        if useSampleData {
            loadSampleData()
        } else {
            loadTasks()
        }
    }
    
    
    func loadSampleDataIfNeeded() {
        guard !TasksViewModel.sampleDataLoaded else { return } // Ensure data is loaded only once
        TasksViewModel.sampleDataLoaded = true
        loadSampleData()
    }
    
    private func loadSampleData() {
        if let url = Bundle.main.url(forResource: "SampleData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let tasks = json?["tasks"] as? [String] {
                    self.dailyTasks = tasks.map { TaskEntity(context: self.context, title: $0, taskType: "daily") }
                    print("Loaded sample data dailyTasks")
                }
            } catch {
                print("Failed to load sample data: \(error)")
            }
        } else {
            print("SampleData.json not found")
        }
    }
    
    
    func generateTasks(taskType: String, context: String) {
        let prompt = PromptTemplate.generatePrompt(taskType: taskType, context: context)
        openAIService.fetchTasks(prompt: prompt) { [weak self] generatedTasks in
            DispatchQueue.main.async {
                guard let self = self else { return }
//                // Clear existing tasks of the same type
//                self.clearTasks(ofType: taskType)
                switch taskType {
                case "daily":
                    self.dailyTasks = generatedTasks.map { TaskEntity(context: self.context, title: $0, taskType: "daily") }
                case "weekly":
                    self.weeklyTasks = generatedTasks.map { TaskEntity(context: self.context, title: $0, taskType: "weekly") }
                case "monthly":
                    self.monthlyTasks = generatedTasks.map { TaskEntity(context: self.context, title: $0, taskType: "monthly") }
                default:
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
    
    func toggleTaskCompletion(task: TaskEntity) {
        task.isCompleted.toggle()
        saveContext()
    }
    
    func saveCurrentList() {
        let currentTasks: [TaskEntity]
        
        switch selectedTaskType {
        case "daily":
            currentTasks = dailyTasks
        case "weekly":
            currentTasks = weeklyTasks
        case "monthly":
            currentTasks = monthlyTasks
        default:
            currentTasks = []
        }
        
        let newList = ListEntity(context: context)
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
        newList.name = "\(selectedTaskType.capitalized) Tasks - \(timestamp)"
        newList.frequencyRaw = selectedTaskType
        newList.expirationDate = Date().addingTimeInterval(24 * 60 * 60 * (selectedTaskType == "daily" ? 1 : (selectedTaskType == "weekly" ? 7 : 30)))
        
        for task in currentTasks {
            newList.addToTasks(task)
            task.addToLists(newList)
        }
        
        saveContext()
        listSavedSubject.send() // Notify that a list has been saved
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
//    private func clearTasks(ofType type: String) {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "taskType == %@", type)
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        
//        do {
//            try context.execute(deleteRequest)
//        } catch {
//            print("Failed to delete existing tasks: \(error)")
//        }
//    }
    
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
}
