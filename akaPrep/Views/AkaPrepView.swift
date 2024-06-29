//
//  AkaListView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/26/24.
//

import SwiftUI

struct AkaPrepView: View {
    @StateObject var viewModel = AkaPrepViewViewModel()
    @State private var context = ""
    @State private var taskType = "daily"
    
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter context", text: $context)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Picker("Task Type", selection: $taskType) {
                    Text("Daily").tag("daily")
                    Text("Weekly").tag("weekly")
                    Text("Monthly").tag("monthly")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button("Generate Tasks") {
                    //                    viewModel.generateTasks(taskType: taskType, context: context)
                }
            }
            .padding()
            Spacer()
            VStack {
                
            }
            .navigationTitle("Home")
            .toolbar {
                Button {
                    // Action
                    viewModel.showingAddNewTaskView = true
                } label: {
                    Image(systemName: "plus")
                }
            }.sheet(isPresented: $viewModel.showingAddNewTaskView) {
                AddNewTaskView(newTaskPresented: $viewModel.showingAddNewTaskView)
                    .presentationDetents([.medium])
            }
            
        }
    }
        
}

#Preview {
    AkaPrepView()
}
