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
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
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

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

//#Preview {
//    WelcomeView()
//}
