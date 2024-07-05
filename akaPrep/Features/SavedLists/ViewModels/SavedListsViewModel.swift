//
//  SavedListsViewModel.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/3/24.
//

import Foundation
import CoreData
import Combine

class SavedListsViewModel: ObservableObject {
    @Published var dailyLists: [ListEntity] = []
    @Published var weeklyLists: [ListEntity] = []
    @Published var monthlyLists: [ListEntity] = []
    
    private var context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext, tasksViewModel: TasksViewModel) {
        self.context = context
        loadLists()
        //        fetchSavedLists()
        tasksViewModel.listSavedSubject
            .sink { [weak self] in
                self?.loadLists()
            }
            .store(in: &cancellables)
    }
    
    private func loadLists() {
        let fetchRequest: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        
        do {
            let lists = try context.fetch(fetchRequest)
            self.dailyLists = lists.filter { $0.frequency == .daily }
            self.weeklyLists = lists.filter { $0.frequency == .weekly }
            self.monthlyLists = lists.filter { $0.frequency == .monthly }
            print("loading lists: \(lists)")
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }
}
