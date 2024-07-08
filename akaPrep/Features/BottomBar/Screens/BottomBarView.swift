//
//  BottomBarView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/29/24.
//

import SwiftUI
import CoreData

struct BottomBarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var tasksViewModel: TasksViewModel
    @State private var profileName: String?
    @State private var profileImage: UIImage?

    var body: some View {
        TabView {
            TasksView()
                .environmentObject(tasksViewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Tasks")
                }
            GoalsView(context: viewContext)
                .tabItem {
                    Image(systemName: "target")
                    Text("Goals")
                }
            SavedListsView(context: viewContext, tasksViewModel: tasksViewModel)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Saved Lists")
                }
            ProfileView(context: viewContext)
                .tabItem {
                    if let profileImage = profileImage {
                        TabIcon(icon: profileImage, size: CGSize(width: 27, height: 27))
                        
                    } else {
                        Image(systemName: "person.fill")
                    }
                    if let savedName = profileName {
                        Text("\(savedName)")
                    } else {
                        Text("Profile")
                    }
                }
        }
        .onAppear {
            // Load the existing profile picture
            loadProfile()
            loadProfileImage()
            NotificationCenter.default.addObserver(forName: .profileImageUpdated, object: nil, queue: .main) { _ in
                self.loadProfileImage()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .profileImageUpdated, object: nil)
        }
    }
    
    private func loadProfile() {
        if let savedName = ProfileEntity.getProfileName(context: PersistenceController.shared.container.viewContext) {
            profileName = savedName
            print("name in context: \(savedName)")
        }
    }
    
    private func loadProfileImage() {
        DispatchQueue.global(qos: .background).async {
            if let savedImage = ProfileEntity.getProfilePicture(context: viewContext) {
                DispatchQueue.main.async {
                    self.profileImage = savedImage
                    print("getting image")
                }
            }
        }
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(TasksViewModel(context: PersistenceController.preview.container.viewContext, useSampleData: false))
    }
}
