//
//  ContentView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/25/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var tasksViewModel: TasksViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State var isActive: Bool = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskEntity.date, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<TaskEntity>

    var body: some View {
        ZStack {
            if self.isActive {
                BottomBarView()
                    .environmentObject(tasksViewModel)
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
    let context = PersistenceController.preview.container.viewContext
    let tasksViewModel = TasksViewModel(context: context, useSampleData: true)
    
    return ContentView()
        .environment(\.managedObjectContext, context)
        .environmentObject(tasksViewModel)
}
