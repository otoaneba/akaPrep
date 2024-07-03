//
//  BabyInfoViewModel.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/3/24.
//

import Foundation
import CoreData
import Combine

class BabyInfoViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext
    
    private var baby: BabyEntity
    
    @Published var name: String = ""
    @Published var gender: Gender = .female
    @Published var dateOfBirth: Date = Date()
    @Published var showDatePicker: Bool = false
    
    private var initialName: String = ""
    private var initialDateOfBirth: Date = Date()
    private var initialGender: Gender = .female
    
    @Published var isSaveDisabled: Bool = true
    private var cancellables: Set<AnyCancellable> = []
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        
        let fetchRequest: NSFetchRequest<BabyEntity> = BabyEntity.fetchRequest()
        if let baby = try? context.fetch(fetchRequest).first {
            self.baby = baby
        } else {
            self.baby = BabyEntity(context: context)
        }
        loadBabyInfo()
        setupCombine()
    }
    
    func loadBabyInfo() {
        name = baby.name
        initialName = name
        
        dateOfBirth = baby.dateOfBirth ?? Date()
        initialDateOfBirth = dateOfBirth
        
        gender = baby.gender
        initialGender = gender
    }
    
    func saveBabyInfo() {
        baby.name = name
        baby.dateOfBirth = dateOfBirth
        baby.gender = gender
        
        do {
            try viewContext.save()
            print("Baby info saved!")
            loadBabyInfo() // Reload baby info to reset initial values
        } catch {
            print("Failed to save baby info: \(error.localizedDescription)")
        }
    }
    
    private func setupCombine() {
        Publishers.CombineLatest3(
            $name,
            $dateOfBirth,
            $gender
        )
        .map { [weak self] name, dateOfBirth, gender in
            guard let self = self else { return true }
            return name.isEmpty || (name == self.initialName && dateOfBirth == self.initialDateOfBirth && gender == self.initialGender)
        }
        .assign(to: \.isSaveDisabled, on: self)
        .store(in: &cancellables)
    }
    
    var formattedDateOfBirth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: dateOfBirth)
    }
    
}
