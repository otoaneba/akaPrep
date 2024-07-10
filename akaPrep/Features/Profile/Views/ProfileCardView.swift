//
//  ProfileCardView.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/1/24.
//

import SwiftUI
import CoreData

struct ProfileCardView: View {
    @State private var profileImage: UIImage?
    @State private var showingImagePicker = false
    @State private var profileName: String?
    var context: NSManagedObjectContext
    var profileDetails: String
    
    var body: some View {
            HStack {
                // First column: Profile picture or SF Symbol
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .onTapGesture {
                            showingImagePicker = true
                        }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            showingImagePicker = true
                        }
                }
                
                // Second column: Profile name and details
                VStack(alignment: .leading) {
                    if let profileName = profileName {
                        Text(profileName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    }
                    Text(profileDetails)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .onTapGesture {
                            showingImagePicker = true
                        }
                }
                .padding(.leading, 8)
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $profileImage, context: context)
            }
            .onAppear {
                // Load the existing profile picture
                if let savedImage = ProfileEntity.getProfilePicture(context: PersistenceController.shared.container.viewContext) {
                    profileImage = savedImage
                }
                if let savedName = ProfileEntity.getProfileName(context: PersistenceController.shared.container.viewContext) {
                    print("savedName: \(savedName)")
                    profileName = savedName.isEmpty ? "Me" : savedName
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading) // Full width minus padding
            .background(Color("CardBackground")) // Custom adaptive background color
            .cornerRadius(10)
            .padding(.horizontal, 16) // Add padding to the edges of the screen
        
    }
}

//extension Color {
//    static let cardBackground = Color("CardBackground")
//}

struct ProfileCardView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return ProfileCardView(context: context, profileDetails: "Edit picture")
            .environment(\.managedObjectContext, context)
    }
}
