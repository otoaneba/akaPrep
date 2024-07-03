//
//  ProfileCardView.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/1/24.
//

import SwiftUI

struct ProfileCardView: View {
    var profileImage: Image? = nil
    var profileName: String
    var profileDetails: String
    var body: some View {
            HStack {
                // First column: Profile picture or SF Symbol
                if let image = profileImage {
                    image
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                // Second column: Profile name and details
                VStack(alignment: .leading) {
                    Text(profileName)
                        .font(.headline)
                    Text(profileDetails)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 8)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading) // Full width minus padding
            .background(Color(UIColor.white))
            .cornerRadius(10)
            .padding(.horizontal, 16) // Add padding to the edges of the screen
        
    }
}

#Preview {
    ProfileCardView(profileName: "Cynthia Li", profileDetails: "Edit picture")
}
