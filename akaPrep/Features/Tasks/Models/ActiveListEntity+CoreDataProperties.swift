//
//  ActiveListEntity+CoreDataProperties.swift
//  akaPrep
//
//  Created by Mengyuan Cynthia Li on 2024-07-07.
//
//

import Foundation
import CoreData


extension ActiveListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActiveListEntity> {
        return NSFetchRequest<ActiveListEntity>(entityName: "ActiveListEntity")
    }

    @NSManaged public var isLiked: Bool
    @NSManaged public var isLikeDisabled: Bool // This will be computed dynamically
    
    // TODO: For automating recurring tasks
    public var isExpired: Bool {
        if let expirationDate = expirationDate {
            return expirationDate < Date()
        }
        return false
    }

    public override func awakeFromFetch() {
        super.awakeFromFetch()
        self.updateIsLikeDisabled()
    }

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.updateIsLikeDisabled()
    }

    public override func didChangeValue(forKey key: String) {
        super.didChangeValue(forKey: key)
        if key == "tasks" {
            self.updateIsLikeDisabled()
        }
    }

    private func updateIsLikeDisabled() {
        self.isLikeDisabled = (self.tasks?.count ?? 0) == 0
    }
    
    // TODO: For automating recurring tasks 
    private func calculateExpirationDate(frequency: Frequency) -> Date {
        let calendar = Calendar.current
        let creationDate = Date() // Assuming creationDate is now, adjust as necessary
        switch frequency {
        case .daily:
            return calendar.date(byAdding: .day, value: 1, to: creationDate) ?? creationDate
        case .weekly:
            return calendar.date(byAdding: .day, value: 7, to: creationDate) ?? creationDate
        case .monthly:
            return calendar.date(byAdding: .month, value: 1, to: creationDate) ?? creationDate
        }
    }
}
