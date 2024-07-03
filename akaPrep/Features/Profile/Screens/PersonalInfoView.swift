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
    var body: some View {
        NavigationStack {
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
                            .foregroundColor(viewModel.lastName.isEmpty ? Color(UIColor.placeholderText) : .black)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Birth Month and Year")
                        Spacer()
                        Button(action: {
                            viewModel.showDatePicker.toggle()
                       }) {
                           Text(viewModel.birthMonthAndYear.isEmpty ? "optional" : viewModel.birthMonthAndYear)
                               .foregroundColor(viewModel.birthMonthAndYear.isEmpty ?  Color(UIColor.placeholderText) : .black)
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
                        Text("Other").tag(Gender.other)
                    }.tint(.black)
                    
                    Picker("Work Schedule", selection: $viewModel.workSchedule) {
                        Text("Swamped").tag(WorkSchedule.fullTime)
                        Text("Busy").tag(WorkSchedule.partTime)
                        Text("Manageable").tag(WorkSchedule.freelance)
                        Text("Chill").tag(WorkSchedule.unemployed)
                    }.tint(.black)
                }
            }
            .navigationTitle("Personal Info")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Handle save action
                        print("Saved!")
                        viewModel.saveProfile()
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
