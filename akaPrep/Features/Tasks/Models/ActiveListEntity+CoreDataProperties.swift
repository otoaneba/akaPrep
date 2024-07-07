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
}
