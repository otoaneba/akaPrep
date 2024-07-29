//
//  EditableTitleView.swift
//  akaTask
//
//  Created by Naoto Abe on 7/23/24.
//

import SwiftUI

struct EditableTitleView: View {
    @Binding var isEditing: Bool
    @Binding var title: String
    @Binding var subTitle: String
    let onCommit: () -> Void

    var body: some View {
        VStack {
            if isEditing {
                TextField("List Name", text: $title, onCommit: {
                    onCommit()
                    isEditing = false
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200)  // Adjust width as needed
            } else {
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .onTapGesture {
                        isEditing = true
                    }
                Text(subTitle)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .onTapGesture {
                        isEditing = true
                    }
            }
        }
    }
}

#Preview {
    EditableTitleView(isEditing: .constant(false), title: .constant("title"), subTitle: .constant("sub title"), onCommit: ({}))
}
