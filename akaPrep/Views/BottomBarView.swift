//
//  BottomBarView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/29/24.
//

import SwiftUI

struct BottomBarView: View {
    var body: some View {
        TabView {
            AkaPrepView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            AkaListView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                    
            AkaListView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
            }
    }
}

#Preview {
    BottomBarView()
}
