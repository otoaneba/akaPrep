//
//  AkaButton.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/26/24.
//

import SwiftUI

struct AkaButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            // Action
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)
                
                Text(title)
                    .foregroundColor(Color.white)
                    .bold()
            }
        }
    }
}

#Preview {
    AkaButton(title: "Value", background: .pink) {
        
    }
}
