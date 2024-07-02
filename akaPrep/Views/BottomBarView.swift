//
//  BottomBarView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/29/24.
//

import SwiftUI

struct BottomBarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = AkaPrepViewViewModel(context: PersistenceController.shared.container.viewContext, useSampleData: false)

    var body: some View {
        TabView {
            AkaPrepView()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Tasks")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



