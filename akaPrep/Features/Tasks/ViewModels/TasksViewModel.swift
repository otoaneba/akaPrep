//
//  TasksViewModel.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/26/24.
//

import Foundation
import CoreData
import Combine
import UIKit
import SwiftUI

class TasksViewModel: ObservableObject {
    static let shared = TasksViewModel(context: PersistenceController.shared.container.viewContext, useSampleData: true)
    
    @Published var dailyTasks: [TaskEntity] = []
    @Published var weeklyTasks: [TaskEntity] = []
    @Published var monthlyTasks: [TaskEntity] = []
    @Published var selectedTaskType: String = "daily"
    @Published var currentLikedLists: [String: UUID] = [:]
    @Published var showToast: Bool = false
    @Published var toastState: ToastState = .none
    @Published var listLiked: Bool = false
    @Published var listActivated: Bool = false
    
    let listLikedSubject = PassthroughSubject<Void, Never>()
    let listUnlikedSubject = PassthroughSubject<Void, Never>()
    
    private let context: NSManagedObjectContext
    private let openAIService: OpenAIService
    private static var sampleDataLoaded = false // Static flag to check if sample data is already loaded
    private var workItem: DispatchWorkItem?
    
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
    
    // TODO: For automating recurring tasks
    private var timer: Timer?
    @Published var dailyActiveList: ActiveListEntity?
    @Published var dailyActiveListExpired: Bool = false
    
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
    
    func toggleTaskCompletion(task: TaskEntity) {
        task.isCompleted.toggle()
        saveContext()
    }
    
    func moveTask(from source: IndexSet, to destination: Int) {
        print("moving")
        var tasks = tasksForSelectedType
        tasks.move(fromOffsets: source, toOffset: destination)
        
        // Update the task order in the published arrays
        switch selectedTaskType {
        case "daily":
            dailyTasks = tasks
        case "weekly":
            weeklyTasks = tasks
        case "monthly":
            monthlyTasks = tasks
        default:
            break
        }
        
        saveContext()
    }
    
    func removeTasks(atOffsets offsets: IndexSet) {
        offsets.forEach { index in
            let task = tasksForSelectedType[index]
            print("Deleting task: \(task.title ?? "")") // Debug print statement
            removeTask(task)
        }
    }
    
    func removeTask(_ task: TaskEntity) {
        print("Remove task called for task: \(task.title ?? "")") // Debug print statement
        context.delete(task)
        saveContext()
        resetCurrentLikedListStatus()
        
        switch task.taskType {
        case "daily":
            if let index = dailyTasks.firstIndex(of: task) {
                dailyTasks.remove(at: index)
            }
        case "weekly":
            if let index = weeklyTasks.firstIndex(of: task) {
                weeklyTasks.remove(at: index)
            }
        case "monthly":
            if let index = monthlyTasks.firstIndex(of: task) {
                monthlyTasks.remove(at: index)
            }
        default:
            break
        }
        
        loadActiveLists()  // Ensure the list is reloaded after deletion
    }
    
    func deleteTask(withId id: UUID) {
        let task = tasksForSelectedType.first { $0.id == id }
        if let task = task {
            removeTask(task)
        }
    }
    
    func saveTask(_ task: TaskEntity) {
        do {
            try context.save()
            resetCurrentLikedListStatus()
            print("Saved updated task and reset liked list status")
        } catch {
            print("Failed to save task: \(error)")
        }
    }
    
    func addTask(title: String) {
        let newTask = TaskEntity(context: context)
        newTask.title = title
        newTask.taskType = selectedTaskType
        newTask.isCompleted = false
        
        switch selectedTaskType {
        case "daily":
            dailyTasks.append(newTask)
        case "weekly":
            weeklyTasks.append(newTask)
        case "monthly":
            monthlyTasks.append(newTask)
        default:
            break
        }
        
        saveContext()
        resetCurrentLikedListStatus()
        updateActiveListWithNewTask(newTask) // Update the active list with the new task
    }
    
    private func updateActiveListWithNewTask(_ task: TaskEntity) {
        let fetchRequest: NSFetchRequest<ActiveListEntity> = ActiveListEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", "Active \(selectedTaskType.capitalized) Tasks")
        
        do {
            if let activeList = try context.fetch(fetchRequest).first {
                activeList.addToTasks(task)
                task.addToLists(activeList)
                saveContext()
            } else {
                saveActiveList(taskType: selectedTaskType, tasks: [task])
            }
        } catch {
            print("Failed to update active list with new task: \(error)")
        }
    }
    
    func resetCurrentLikedListStatus() {
        currentLikedLists[selectedTaskType] = nil
        UserDefaults.standard.removeObject(forKey: "\(selectedTaskType)LikedListUUID")
        print("Reset liked list status for \(selectedTaskType)")
    }
    
    func activateList(_ list: ListEntity) {
        let tasks = list.taskArray.map { task in
            let newTask = TaskEntity(context: context)
            newTask.title = task.title
            newTask.isCompleted = task.isCompleted
            newTask.taskType = task.taskType
            newTask.date = task.date
            newTask.id = UUID()
            return newTask
        }
        saveActivatedList(taskType: list.frequencyRaw ?? "daily", tasks: tasks)
        if let listID = list.id {
            currentLikedLists[list.frequencyRaw ?? "daily"] = listID
        }
        
        toastState = .listActivated
        showToastCard()
    }
    
    private func saveActivatedList(taskType: String, tasks: [TaskEntity]) {
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
        if let listID = activeList.id {
            currentLikedLists[taskType] = listID
            UserDefaults.standard.set(listID.uuidString, forKey: "\(taskType)LikedListUUID")
        }
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
        toastState = .listLiked
        showToastCard()
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
        toastState = .listUnliked
        showToastCard()
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
    
    func showToastCard() {
        // Cancel any existing toast
        workItem?.cancel()
        
        withAnimation(.easeIn) {
            showToast.toggle()
        }
        
        // Provide haptic feedback
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        // Create a new work item to hide the toast after the duration
        let task = DispatchWorkItem { [weak self] in
            self?.dismissToast()
        }
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: task)
    }
    
    // Method to hide toast
    func dismissToast() {
        DispatchQueue.main.async {
            self.showToast = false
        }
    }
    
    func isListActive(_ list: ListEntity) -> Bool {
        let activeListID = currentLikedLists[selectedTaskType]
        return list.id == activeListID
    }
    
    func uncheckAllTasks() {
        let currentTasks: [TaskEntity]
        
        switch selectedTaskType {
        case "daily":
            currentTasks = dailyTasks
        case "weekly":
            currentTasks = weeklyTasks
        case "monthly":
            currentTasks = monthlyTasks
        default:
            return
        }
        
        for task in currentTasks {
            task.isCompleted = false
        }
    }
    
    // TODO: For automating recurring logic
    func checkAllListsForExpiration() {
        if let dailyActiveList = dailyActiveList {
            if dailyActiveList.isExpired {
                handleExpiredDailyList()
            }
        }
    }
    
    private func handleExpiredDailyList() {
        // Handle the expired daily active list (e.g., notify the user, update UI, etc.)
        print("The daily active list has expired.")
        self.dailyActiveListExpired.toggle()
    }
    
    private func startExpirationCheckTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            self?.checkAllListsForExpiration()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
