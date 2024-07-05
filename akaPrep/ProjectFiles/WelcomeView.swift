//
//  WelcomeView.swift
//  akaPrep
//
//  Created by Mengyuan Cynthia Li on 2024-07-03.
//

import SwiftUI

struct WelcomeView: View {
    @State var isActive: Bool = false
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        ZStack {
            if self.isActive {
                let context = PersistenceController.preview.container.viewContext
                let akaPrepViewModel = TasksViewModel(context: context, useSampleData: true)
                
                ContentView()
                    .environment(\.managedObjectContext, context)
                    .environmentObject(akaPrepViewModel)
            } else {
                Image("welcome-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
