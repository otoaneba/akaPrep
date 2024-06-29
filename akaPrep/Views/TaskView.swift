//
//  SwiftUIView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/26/24.
//

import SwiftUI
import CoreData

struct TaskView: View {
    @StateObject var viewModel = NewTaskViewViewModel()
    
    var body: some View {
        VStack {
            Text("New Task")
                .font(.system(size:32))
                .bold()
            }
        Form {
            // title
            TextField("Title", text: $viewModel.title)
                .textFieldStyle(DefaultTextFieldStyle())
            // Date
            DatePicker("Due Date", selection: $viewModel.date)
                .datePickerStyle(GraphicalDatePickerStyle())
            // Button
            
        }
    }
}

#Preview {
    TaskView()
}
