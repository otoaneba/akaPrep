//
//  PersonalInfoViewModel.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/2/24.
//

import SwiftUI
import CoreData

class PersonalInfoViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var birthMonthAndYear: String = ""
    @Published var gender: Gender = .female
    @Published var workSchedule: WorkSchedule = .fullTime
    @Published var selectedDate: Date?
    @Published var showDatePicker: Bool = false
    
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
    }
    
    var isSaveDisabled: Bool {
        firstName.isEmpty || firstName == initialFirstName &&
        lastName == initialLastName &&
        birthMonthAndYear == initialBirthMonthAndYear &&
        gender == initialGender &&
        workSchedule == initialWorkSchedule
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
        } catch {
            print("Failed to save profile: \(error.localizedDescription)")
        }
    }
}
