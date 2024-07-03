//
//  Task.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/25/24.
//
import Foundation
import CoreData

@objc(TaskEntity)
public class TaskEntity: NSManagedObject, Identifiable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
         return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
     }
    
    @NSManaged public var id: UUID?
    @NSManaged public var title: String
    @NSManaged public var date: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var taskType: String?
    @NSManaged public var list: ListEntity? // Inverse relationship
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }
}

// MARK: accessors for subTasks
extension TaskEntity {

    convenience init(context: NSManagedObjectContext, title: String, taskType: String, isCompleted: Bool = false, id: UUID = UUID()) {
            self.init(context: context)
            self.title = title
            self.isCompleted = isCompleted
            self.id = id
            self.taskType = taskType
        }

}
