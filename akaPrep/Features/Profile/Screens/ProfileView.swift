//
//  ProfileView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/29/24.
//

import SwiftUI
import CoreData

struct ProfileView: View {
    @StateObject private var personalInfoViewModel: PersonalInfoViewModel
    @StateObject var babyInfoViewModel: BabyInfoViewModel
    
    @State public var name = ""
    
    init(context: NSManagedObjectContext) {
         _personalInfoViewModel = StateObject(wrappedValue: PersonalInfoViewModel(context: context))
         _babyInfoViewModel = StateObject(wrappedValue: BabyInfoViewModel(context: context))
     }
    
    var body: some View {
        NavigationStack {
            VStack {
            ProfileCardView(profileName: "Cynthia Li", profileDetails: "Edit picture")
            
                let primaryList = [
                   NavigationItem(name: "Personal Info", destination: AnyView(PersonalInfoView().environmentObject(personalInfoViewModel))),
                   NavigationItem(name: "Baby Info", destination: AnyView(BabyInfoView().environmentObject(babyInfoViewModel))),
                ]
                let secondaryList = [
                    // TODO: Add SettingsView
                    NavigationItem(name: "Setting", destination: AnyView(PersonalInfoView().environmentObject(personalInfoViewModel))),
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let babyInfoViewModel = BabyInfoViewModel(context: context)
        return ProfileView(context: context)
            .environment(\.managedObjectContext, context)
            .environmentObject(babyInfoViewModel)
    }
}
