//
//  AddNewListView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/27/24.
//

import SwiftUI
import FloatingPromptTextField

struct AddNewListView: View {
    @State private var listName: String = ""
    var body: some View {
        VStack {
            Text("Add List Name")
                .frame(maxWidth: .infinity, alignment: .leading)
                
            TextField(
                "Tap to enter list name here",
                text: $listName
            )
            .textFieldStyle(.roundedBorder)
        }.padding()
    }
}

#Preview {
    AddNewListView()
}
