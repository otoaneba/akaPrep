//
//  BottomBarView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/29/24.
//

import SwiftUI

struct BottomBarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: AkaPrepViewViewModel
    
    init(useSampleData: Bool = false) {
        _viewModel = StateObject(wrappedValue: AkaPrepViewViewModel(context: PersistenceController.shared.container.viewContext, useSampleData: useSampleData))
    }

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

#Preview {
    BottomBarView(useSampleData: true)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

