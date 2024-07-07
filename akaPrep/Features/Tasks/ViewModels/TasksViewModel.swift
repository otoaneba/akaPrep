//
//  TasksViewModel.swift
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
    @Published var currentLikedLists: [String: UUID] = [:]
    
    let listLikedSubject = PassthroughSubject<Void, Never>()
    let listUnlikedSubject = PassthroughSubject<Void, Never>()
    
    private let context: NSManagedObjectContext
    private let openAIService: OpenAIService
    private static var sampleDataLoaded = false // Static flag to check if sample data is already loaded
    
    init(context: NSManagedObjectContext, useSampleData: Bool = false) {
        self.context = context
        self.openAIService = OpenAIService()
        
        if let dailyLikedListUUIDString = UserDefaults.standard.string(forKey: "dailyLikedListUUID"),
           let dailyLikedListUUID = UUID(uuidString: dailyLikedListUUIDString) {
            currentLikedLists["daily"] = dailyLikedListUUID
        }
        if let weeklyLikedListUUIDString = UserDefaults.standard.string(forKey: "weeklyLikedListUUID"),
           let weeklyLikedListUUID = UUID(uuidString: weeklyLikedListUUIDString) {
            currentLikedLists["weekly"] = weeklyLikedListUUID
        }
        if let monthlyLikedListUUIDString = UserDefaults.standard.string(forKey: "monthlyLikedListUUID"),
           let monthlyLikedListUUID = UUID(uuidString: monthlyLikedListUUIDString) {
            currentLikedLists["monthly"] = monthlyLikedListUUID
        }
        
//        clearLikedLists() // clear the currentLikedLists for testing purposes
        
        // for LLM testing
        if useSampleData {
            loadSampleData()
        } else {
            loadActiveLists()
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
                let newTasks = generatedTasks.map { TaskEntity(context: self.context, title: $0, taskType: taskType) }
                // Save the generated tasks in Core Data as an "active list"
                self.saveActiveList(taskType: taskType, tasks: newTasks)
                // Update the corresponding task list in memory
                switch taskType {
                case "daily":
                    self.dailyTasks = newTasks
                case "weekly":
                    self.weeklyTasks = newTasks
                case "monthly":
                    self.monthlyTasks = newTasks
                default:
                    break
                }
            }
        }
    }
    
    private func saveActiveList(taskType: String, tasks: [TaskEntity]) {
        // Remove any existing active list for the given task type
        removeActiveList(for: taskType)
        
        let activeList = ActiveListEntity(context: context)
        activeList.name = "Active \(taskType.capitalized) Tasks"
        activeList.frequencyRaw = taskType
        activeList.expirationDate = Date().addingTimeInterval(24 * 60 * 60 * (taskType == "daily" ? 1 : (taskType == "weekly" ? 7 : 30)))
        
        for task in tasks {
            activeList.addToTasks(task)
            task.addToLists(activeList)
        }
        
        saveContext()
    }
    
    private func removeActiveList(for taskType: String) {
        let fetchRequest: NSFetchRequest<ActiveListEntity> = ActiveListEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", "Active \(taskType.capitalized) Tasks")
        
        do {
            let lists = try context.fetch(fetchRequest)
            for list in lists {
                context.delete(list)
            }
            saveContext()
        } catch {
            print("Failed to remove existing active list: \(error)")
        }
    }
    
    func loadActiveLists() {
        let fetchRequest: NSFetchRequest<ActiveListEntity> = ActiveListEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", "Active")
        
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
            print("Failed to fetch active lists: \(error)")
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
        print("toggle task \(task.id) to \(task.isCompleted)")
        task.isCompleted.toggle()
        saveContext()
    }
    
    func likeCurrentList() {
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
        
        let newList = LikedListEntity(context: context)
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
        newList.name = "\(selectedTaskType.capitalized) Tasks - \(timestamp)"
        newList.frequencyRaw = selectedTaskType
        newList.expirationDate = Date().addingTimeInterval(24 * 60 * 60 * (selectedTaskType == "daily" ? 1 : (selectedTaskType == "weekly" ? 7 : 30)))
        
        for task in currentTasks {
            let newTask = TaskEntity(context: context)
            newTask.title = task.title
            newTask.date = task.date
            newTask.isCompleted = task.isCompleted
            newTask.taskType = task.taskType
            newTask.id = UUID() // Ensure a unique ID for the new task
            
            newList.addToTasks(newTask)
            newTask.addToLists(newList)
        }
        
        saveContext()
        listLikedSubject.send()
        currentLikedLists[selectedTaskType] = newList.id
        UserDefaults.standard.set(newList.id?.uuidString, forKey: "\(selectedTaskType)LikedListUUID")
        print("Saved Like list")
        print("currentLikedLists: \(currentLikedLists)")
    }
    
    func unlikeCurrentList() {
        guard let listToDeleteUUID = currentLikedLists[selectedTaskType],
              let listToDelete = loadLikedList(with: listToDeleteUUID) else { return }
        
        context.delete(listToDelete)
        saveContext()
        
        currentLikedLists[selectedTaskType] = nil
        UserDefaults.standard.removeObject(forKey: "\(selectedTaskType)LikedListUUID")
        
        listUnlikedSubject.send()
        print("Unsaved Like list")
        print("currentLikedLists: \(currentLikedLists)")
    }
    
    private func loadLikedList(with uuid: UUID) -> LikedListEntity? {
        let fetchRequest: NSFetchRequest<LikedListEntity> = LikedListEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        do {
            let lists = try context.fetch(fetchRequest)
            if let list = lists.first {
                return list
            }
        } catch {
            print("Failed to load liked list with UUID: \(error)")
        }
        return nil
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func clearLikedLists() {
        UserDefaults.standard.removeObject(forKey: "dailyLikedListUUID")
        UserDefaults.standard.removeObject(forKey: "weeklyLikedListUUID")
        UserDefaults.standard.removeObject(forKey: "monthlyLikedListUUID")
        currentLikedLists.removeAll()
    }
}
