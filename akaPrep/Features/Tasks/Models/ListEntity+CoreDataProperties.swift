//
//  ListEntity+CoreDataProperties.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/5/24.
//
//

import Foundation
import CoreData


extension ListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListEntity> {
        return NSFetchRequest<ListEntity>(entityName: "ListEntity")
    }

    @NSManaged public var expirationDate: Date?
    @NSManaged public var frequencyRaw: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var tasks: NSOrderedSet?
    
    public var frequency: Frequency {
            get {
                return Frequency(rawValue: frequencyRaw ?? "daily") ?? .daily
            }
            set {
                frequencyRaw = newValue.rawValue
            }
        }
        
        public var taskArray: [TaskEntity] {
            let set = tasks ?? []
            return Array(set) as! [TaskEntity]
        }
        
        override public func awakeFromInsert() {
            super.awakeFromInsert()
            id = UUID()
        }

}

// MARK: Generated accessors for tasks
extension ListEntity {

    @objc(insertObject:inTasksAtIndex:)
    @NSManaged public func insertIntoTasks(_ value: TaskEntity, at idx: Int)

    @objc(removeObjectFromTasksAtIndex:)
    @NSManaged public func removeFromTasks(at idx: Int)

    @objc(insertTasks:atIndexes:)
    @NSManaged public func insertIntoTasks(_ values: [TaskEntity], at indexes: NSIndexSet)

    @objc(removeTasksAtIndexes:)
    @NSManaged public func removeFromTasks(at indexes: NSIndexSet)

    @objc(replaceObjectInTasksAtIndex:withObject:)
    @NSManaged public func replaceTasks(at idx: Int, with value: TaskEntity)

    @objc(replaceTasksAtIndexes:withTasks:)
    @NSManaged public func replaceTasks(at indexes: NSIndexSet, with values: [TaskEntity])

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TaskEntity)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TaskEntity)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSOrderedSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSOrderedSet)

}

extension ListEntity : Identifiable {

}
