//
//  NewTaskView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/26/24.
//

import SwiftUI

struct AddNewTaskView: View {
    @StateObject var viewModel = AddNewTaskViewViewModel()
    @State private var showDetailsEditor = false
    @Binding var newTaskPresented: Bool
    
    
    var body: some View {
        VStack {
            Text("New Task")
                .font(.system(size: 32))
                .bold()
                .padding(.top, 30)
            
            Form {
                // Title
                TextField("Title", text: $viewModel.title)
                    .textFieldStyle(DefaultTextFieldStyle())
      
                VStack(alignment: .leading) {
                    // Toolbar
                    HStack {
                        Button(action: {
                            viewModel.isFavorite.toggle()
                        }) {
                            Image(systemName: viewModel.isFavorite ? "bookmark.fill" : "bookmark")
                                .foregroundColor(viewModel.isFavorite ? .pink : .gray)
                        }
                        Text("\(DateUtils.formattedDate(Date.now))")
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color.gray, lineWidth: 0.25)
                            .background(Color.white)
                            .cornerRadius(8)
                        TextEditor(text: $viewModel.details)
                            .padding(8)
                            .background(Color.clear)
                    }
                    .frame(height: 200)
                }
                             
                
                // Button
                AkaButton(
                    title: "Save",
                    background: .pink
                ) {
                    if viewModel.canSave {
                        viewModel.save()
                        newTaskPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                    
                }
                .padding()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Please fill in all fields.")
                )
            }
           
        }
    }
}

#Preview {
    AddNewTaskView(newTaskPresented: Binding(get: {
        return true
    }, set: { _ in
    }))
}
