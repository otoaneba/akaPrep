//
//  PersonalInfoView.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/2/24.
//

import SwiftUI

struct PersonalInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: PersonalInfoViewModel

    init(viewModel: PersonalInfoViewModel) {
        self.viewModel = viewModel
    }
    
//    @State private var firstName: String = ""
//    @State private var lastName: String = ""
//    @State private var birthMonthAndYear: String = ""
//    @State private var gender: Gender = Gender.female
//    @State private var workSchedule: WorkSchedule = WorkSchedule.fullTime
//    @State private var showDatePicker = false
//    @State private var selectedDate = Date()
//    
//    // Initial values
//    private let initialFirstName = ""
//    private let initialLastName = ""
//    private let initialBirthMonthAndYear = ""
//    private let initialGender: Gender = .female
//    private let initialWorkSchedule: WorkSchedule = .fullTime
    
    
    
//    var isSaveDisabled: Bool {
//        firstName == initialFirstName &&
//        lastName == initialLastName &&
//        birthMonthAndYear == initialBirthMonthAndYear &&
//        gender == initialGender &&
//        workSchedule == initialWorkSchedule
//    }
    
    var body: some View {
        NavigationStack {
//            Form {
            List {
                Section(header: Text("Personal Info")) {
                    HStack {
                        Text("First Name")
                        Spacer()
                        TextField("required", text: $viewModel.firstName)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.trailing)
                            
                    }
                    HStack {
                        Text("Last Name")
                        Spacer()
                        TextField("optional", text: $viewModel.lastName)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Birth Month and Year")
                        Spacer()
                        Button(action: {
                            viewModel.showDatePicker.toggle()
                       }) {
                           Text(viewModel.birthMonthAndYear.isEmpty ? "optional" : viewModel.birthMonthAndYear)
                               .foregroundColor(.secondary)
                               .multilineTextAlignment(.trailing)
                       }
                    }
                    if viewModel.showDatePicker {
                        YearMonthPickerView(selectedDate: Binding(
                            get: { viewModel.selectedDate ?? Date() },
                            set: { viewModel.selectedDate = $0 }
                        ))
                        .onDisappear {
                            // Update birthMonthAndYear when the date picker is dismissed
                            viewModel.birthMonthAndYear = viewModel.formattedDate
                        }
                    }
                    Picker("Gender", selection: $viewModel.gender) {
                        Text("Female").tag(Gender.female)
                        Text("Male").tag(Gender.male)
                        Text("Other").tag(Gender.male)
                    }
                    Picker("Work Schedule", selection: $viewModel.workSchedule) {
                        Text("Swamped").tag(WorkSchedule.fullTime)
                        Text("Busy").tag(WorkSchedule.partTime)
                        Text("Manageable").tag(WorkSchedule.freelance)
                        Text("Chill").tag(WorkSchedule.unemployed)
                    }
                }
            }
            .navigationTitle("Personal Info")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Handle save action
                        print("Saved!")
                        presentationMode.wrappedValue.dismiss()
                    }.disabled(viewModel.isSaveDisabled)
                }
                
            }
        }
    }
}



struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let viewModel = PersonalInfoViewModel(context: context)
        return PersonalInfoView(viewModel: viewModel)
            .environment(\.managedObjectContext, context)
    }
}
