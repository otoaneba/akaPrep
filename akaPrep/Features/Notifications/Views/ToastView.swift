//
//  ToastView.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/10/24.
//

import SwiftUI

struct ToastView: View {
    @Environment(\.colorScheme) var colorScheme
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle")
                .foregroundColor(.green)
            Text(message)
                .font(.body)
            Spacer()

        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .leading) // Full width minus padding
        .padding()
        .background(.gray)
        .cornerRadius(8)
        .shadow(radius: 10)
        .opacity(1.5)
        
    }
}

#Preview {
    ToastView(message: "You’ll have a working toast message view that can be easily integrated into your SwiftUI projects.!")
}
