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
    var profileName: String
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
                    Text(profileName)
                        .font(.headline)
                    Text(profileDetails)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            showingImagePicker = true
                        }
                }
                .padding(.leading, 8)
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $profileImage)
            }
            .onAppear {
                // Load the existing profile picture
                if let savedImage = ProfileEntity.getProfilePicture(context: PersistenceController.shared.container.viewContext) {
                    profileImage = savedImage
                }
            }
            .onChange(of: profileImage) { newImage, oldImage in
                if let newImage = newImage {
                    // Save the new profile picture
                    saveProfilePicture(newImage)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading) // Full width minus padding
            .background(Color(UIColor.white))
            .cornerRadius(10)
            .padding(.horizontal, 16) // Add padding to the edges of the screen
        
    }
    
    private func saveProfilePicture(_ image: UIImage) {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()

        do {
            let result = try context.fetch(request).first ?? ProfileEntity(context: context)
            result.profilePicture = image.jpegData(compressionQuality: 0.8)
            try context.save()
        } catch {
            print("Failed to save profile picture: \(error)")
        }
    }
}

#Preview {
    ProfileCardView(profileName: "Cynthia Li", profileDetails: "Edit picture")
}
