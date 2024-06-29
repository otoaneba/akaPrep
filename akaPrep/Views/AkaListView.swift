//
//  AkaListView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/27/24.
//

import SwiftUI


struct AkaListView: View {
    @State private var username: String = ""

    var body: some View {
        VStack {
            Form {
                TextField(
                    "User name (email address)",
                    text: $username
                )
            }
        }
    }
}

#Preview {
    AkaListView()
}
