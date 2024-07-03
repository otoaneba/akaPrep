//
//  BabyInfoView.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/3/24.
//

import SwiftUI

struct BabyInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: BabyInfoViewModel

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Baby Info")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("required", text: $viewModel.name)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Birth Date")
                        Spacer()
                        Button(action: {
                            viewModel.showDatePicker.toggle()
                        }) {
                            Text(viewModel.formattedDateOfBirth)
                                .foregroundColor(.black)
                        }
                    }
                    if viewModel.showDatePicker {
                        DatePicker(
                            "",
                            selection: Binding(
                                get: { viewModel.dateOfBirth },
                                set: {
                                    viewModel.dateOfBirth = $0
                                    viewModel.showDatePicker = false // Hide the DatePicker when a date is selected
                                }
                            ),
                            displayedComponents: .date
                        )
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()
                    }
                    Picker("Gender", selection: $viewModel.gender) {
                        Text("Female").tag(Gender.female)
                        Text("Male").tag(Gender.male)
                        Text("Other").tag(Gender.other)
                    }.tint(.black)
                }
            }
            .navigationTitle("Baby Info")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveBabyInfo()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(viewModel.isSaveDisabled)
                }
            }
        }
    }
}

struct BabyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let viewModel = BabyInfoViewModel(context: context)
        return BabyInfoView()
            .environmentObject(viewModel)
    }
}
