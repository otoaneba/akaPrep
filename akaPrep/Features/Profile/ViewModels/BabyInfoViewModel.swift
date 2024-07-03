//
//  BabyInfoViewModel.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/3/24.
//

import Foundation
import CoreData

class BabyInfoViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext
    
    private var baby: BabyEntity
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        
        let fetchRequest: NSFetchRequest<BabyEntity> = BabyEntity.fetchRequest()
        if let baby = try? context.fetch(fetchRequest).first {
            self.baby = baby
        } else {
            self.baby = BabyEntity(context: context)
        }
    }
}
