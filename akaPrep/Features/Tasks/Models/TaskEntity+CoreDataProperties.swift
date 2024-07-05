//
//  TaskEntity+CoreDataProperties.swift
//  akaPrep
//
//  Created by Mengyuan Cynthia Li on 2024-07-05.
//
//

import Foundation
import CoreData


extension TaskEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var taskType: String?
    @NSManaged public var title: String?
    @NSManaged public var lists: NSSet?
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }
    
}

extension TaskEntity {
    convenience init(context: NSManagedObjectContext, title: String, taskType: String, isCompleted: Bool = false, id: UUID = UUID()) {
        self.init(context: context)
        self.title = title
        self.isCompleted = isCompleted
        self.id = id
        self.taskType = taskType
    }
}

// MARK: Generated accessors for lists
extension TaskEntity {

    @objc(addListsObject:)
    @NSManaged public func addToLists(_ value: ListEntity)

    @objc(removeListsObject:)
    @NSManaged public func removeFromLists(_ value: ListEntity)

    @objc(addLists:)
    @NSManaged public func addToLists(_ values: NSSet)

    @objc(removeLists:)
    @NSManaged public func removeFromLists(_ values: NSSet)

}

extension TaskEntity : Identifiable {

}
