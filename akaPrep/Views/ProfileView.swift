//
//  ProfileView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/29/24.
//

import SwiftUI

struct ProfileView: View {
    @State public var name = ""
    var body: some View {
        NavigationStack {
            VStack {
            ProfileCardView(profileName: "Cynthia Li", profileDetails: "Edit picture")
            
                let primaryList = [
                   NavigationItem(name: "Personal Info", destination: AnyView(ProfileView())),
                   NavigationItem(name: "Baby Info", destination: AnyView(ProfileView())),
                ]
                let secondaryList = [
                   NavigationItem(name: "Settings", destination: AnyView(ProfileView())),
                ]
                List {
                    Section {
                        ForEach(primaryList) { item in
                                NavigationLink(destination: item.destination) {
                                    Text(item.name)
                                        .foregroundColor(.secondary)
                                        .padding(.vertical, 8)
                                }
                                .listRowInsets(EdgeInsets()) // Remove default padding
                                .padding(.horizontal, 32)
                        }
                        .cornerRadius(10)
                    }
                    Section {
                        ForEach(secondaryList) { item in
                                NavigationLink(destination: item.destination) {
                                    Text(item.name)
                                        .foregroundColor(.secondary)
                                        .padding(.vertical, 8)
                                }
                                .listRowInsets(EdgeInsets()) // Remove default padding
                                .padding(.horizontal, 32)
                        }
                        .cornerRadius(10)
                        Button {
                            // Action
                        } label: {
                            Text("Sign Out")
                        }
                        .padding(.horizontal, 8)
                    }
                }
            }
            .background(Color(UIColor.secondarySystemBackground))

            Spacer()
            .navigationTitle("Profile")
            .toolbar {
                Button {
                    // Action
                } label: {
                    Image(systemName: "plus")
                }
            }
            
        }
    }
}

struct NavigationItem: Identifiable {
    var id = UUID()
    var name: String
    var destination: AnyView
}

#Preview {
    ProfileView()
}
