//
//  PersonalInfoViewModel.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/2/24.
//

import SwiftUI
import CoreData
import Combine

class PersonalInfoViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var birthMonthAndYear: String = ""
    @Published var gender: Gender = .female
    @Published var workSchedule: WorkSchedule = .fullTime
    @Published var selectedDate: Date?
    @Published var showDatePicker: Bool = false
    
    @Published var isSaveDisabled: Bool = true
    private var cancellables: Set<AnyCancellable> = []
    
    private var initialFirstName: String = ""
    private var initialLastName: String = ""
    private var initialBirthMonthAndYear: String = ""
    private var initialGender: Gender = .female
    private var initialWorkSchedule: WorkSchedule = .fullTime
    
    private var viewContext: NSManagedObjectContext
    private var profile: ProfileEntity
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        
        let fetchRequest: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        if let profile = try? context.fetch(fetchRequest).first {
            self.profile = profile
        } else {
            self.profile = ProfileEntity(context: context)
        }
        
        loadProfile()
        setupSubscribers()
    }
    
    var formattedDate: String {
        if let date = selectedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-yyyy"
            return formatter.string(from: date)
        } else {
            return "MM-yyyy"
        }
    }
    
    private func loadProfile() {
        firstName = profile.firstName
        initialFirstName = firstName
        
        lastName = profile.lastName ?? ""
        initialLastName = lastName
        
        if let dateOfBirth = profile.dateOfBirth {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-yyyy"
            birthMonthAndYear = formatter.string(from: dateOfBirth)
            selectedDate = dateOfBirth
            initialBirthMonthAndYear = birthMonthAndYear
        }
        
        gender = profile.gender
        initialGender = gender
        
        workSchedule = profile.workSchedule
        initialWorkSchedule = workSchedule
        
        updateSaveDisabled()
    }
    
    private func setupSubscribers() {
        // Combine first four properties
               let firstFour = Publishers.CombineLatest4(
                   $firstName,
                   $lastName,
                   $birthMonthAndYear,
                   $gender
               )

               // Combine with work schedule
               let firstFive = firstFour.combineLatest($workSchedule)

               // Combine with selected date
               let allProperties = firstFive.combineLatest($selectedDate)

        allProperties
            .map { values -> Bool in
                let (firstFiveValues, _) = values
                let ((firstName, lastName, birthMonthAndYear, gender), workSchedule) = firstFiveValues
                return firstName.isEmpty || (firstName == self.initialFirstName &&
                    lastName == self.initialLastName &&
                    birthMonthAndYear == self.initialBirthMonthAndYear &&
                    gender == self.initialGender &&
                    workSchedule == self.initialWorkSchedule)
            }
            .assign(to: &$isSaveDisabled)
    }
    
    
    private func updateSaveDisabled() {
        isSaveDisabled =
            firstName.isEmpty || (firstName == initialFirstName &&
            lastName == initialLastName &&
            birthMonthAndYear == initialBirthMonthAndYear &&
            gender == initialGender &&
            workSchedule == initialWorkSchedule)
    }
    
    func saveProfile() {
        profile.firstName = firstName
        profile.lastName = lastName
        if let date = selectedDate {
            profile.dateOfBirth = date
        }
        profile.gender = gender
        profile.workSchedule = workSchedule
        
        do {
            try viewContext.save()
            print("Profile saved!")
            loadProfile()
        } catch {
            print("Failed to save profile: \(error.localizedDescription)")
        }
    }
}
