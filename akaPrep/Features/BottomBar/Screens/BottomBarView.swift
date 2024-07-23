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
    @EnvironmentObject private var goalsViewModel: GoalsViewModel
    @State private var profileName: String?
    @State private var profileImage: UIImage?
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TasksView()
                .environmentObject(tasksViewModel)
                .environmentObject(goalsViewModel)
                .tabItem {
                    Image(selectedTab == 0 ? "taskIcon" : "tasksIconGray")
                    Text("Tasks")
                }
                .tag(0)
            GoalsView()
                .environmentObject(goalsViewModel)
                .tabItem {
                    Image(systemName: "target")
                    Text("Goals")
                }
                .tag(1)
            SavedListsView(context: viewContext, tasksViewModel: tasksViewModel)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Saved Lists")
                }
                .tag(2)
            ProfileView(context: viewContext)
                .tabItem {
                    if let profileImage = profileImage {
                        TabIcon(icon: profileImage, size: CGSize(width: 27, height: 27))
                    } else {
                        Image(systemName: "person.fill")
                    }
                    if let profileName = profileName {
                        Text(profileName)
                    } else {
                        Text("Me")
                    }
                }
                .tag(3)
        }
        .accentColor(.customRed)
        .onAppear {
            // Load the existing profile picture
            loadProfile()
            loadProfileImage()
            NotificationCenter.default.addObserver(forName: .profileImageUpdated, object: nil, queue: .main) { _ in
                self.loadProfileImage()
            }
            NotificationCenter.default.addObserver(forName: .profileNameUpdated, object: nil, queue: .main) { _ in
                self.loadProfile()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .profileImageUpdated, object: nil)
            NotificationCenter.default.removeObserver(self, name: .profileNameUpdated, object: nil)
        }
    }
    
    private func loadProfile() {
        if let savedName = ProfileEntity.getProfileName(context: PersistenceController.shared.container.viewContext) {
            profileName = savedName.isEmpty ? "Me" : savedName
        }
    }
    
    private func loadProfileImage() {
        if let savedImage = ProfileEntity.getProfilePicture(context: PersistenceController.shared.container.viewContext) {
            profileImage = savedImage
        }
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let tasksViewModel = TasksViewModel(context: context, useSampleData: false)
        let goalsViewModel = GoalsViewModel(context: context)
        return BottomBarView()
            .environment(\.managedObjectContext, context)
            .environmentObject(tasksViewModel)
            .environmentObject(goalsViewModel)
    }
}
