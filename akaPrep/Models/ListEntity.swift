//
//  ListEntity.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/27/24.
//

import Foundation
import CoreData

@objc(ListEntity)
public class ListEntity: NSManagedObject {
}

extension ListEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListEntity> {
        return NSFetchRequest<ListEntity>(entityName: "ListEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String
    @NSManaged private var frequencyRaw: String
    @NSManaged public var expirationDate: Date
    @NSManaged public var tasks: NSSet?
   
    public var frequency: Frequency {
           get {
               return Frequency(rawValue: frequencyRaw) ?? .daily
           }
           set {
               frequencyRaw = newValue.rawValue
           }
       }
    
    public var taskArray: [TaskEntity] {
        let set = tasks as? Set<TaskEntity> ?? []
        return Array(set)
    }
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }
}

extension ListEntity {
    public enum Frequency: String, Codable {
        case daily
        case weekly
        case monthly
    }
    
    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TaskEntity)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TaskEntity)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)
    
}

