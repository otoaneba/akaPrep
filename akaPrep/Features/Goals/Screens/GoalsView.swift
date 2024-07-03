//
//  GoalsView.swift
//  akaPrep
//
//  Created by Mengyuan Cynthia Li on 2024-07-03.
//

import SwiftUI
import CoreData

struct GoalsView: View {
    @StateObject private var viewModel: GoalsViewModel
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: GoalsViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Goal Type", selection: $viewModel.selectedSegment) {
                    Text("Daily").tag(Frequency.daily.rawValue)
                    Text("Weekly").tag(Frequency.weekly.rawValue)
                    Text("Monthly").tag(Frequency.monthly.rawValue)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                TextField("Enter your \(viewModel.selectedSegment) goal", text: viewModel.bindingForSelectedSegment())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    viewModel.saveGoal()
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color(red: 0.76, green: 0.07, blue: 0.12))

                        .cornerRadius(40)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Goals")
            .padding()
        }
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView(context: PersistenceController.preview.container.viewContext)
    }
}
