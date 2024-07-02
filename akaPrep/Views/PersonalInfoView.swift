//
//  PersonalInfoView.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/2/24.
//

import SwiftUI

struct PersonalInfoView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var birthMonthAndYear: String = ""
    @State private var gender: String = ""
    @State private var workSchedule: String = ""
        
    @State private var selectedDate = Date()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Personal Info")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    
                    
                }
                Section(header: Text("Birth Date")) {
                                    YearMonthPickerView(selectedDate: $selectedDate)
                                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Handle save action
                        print("Saved!")
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
                }
    }
}



#Preview {
    PersonalInfoView()
}
