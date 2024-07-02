//
//  BottomBarView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/29/24.
//

import SwiftUI

struct BottomBarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        TabView {
            AkaPrepView(context: viewContext)
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
    BottomBarView()
}
