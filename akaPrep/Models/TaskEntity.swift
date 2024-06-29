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

    
    public override func awakeFromInsert() {
            super.awakeFromInsert()
            id = UUID()
        }
}

enum TaskStatus: String, Codable {
    case complete
    case imcomplete
}

// MARK: accessors for subTasks
extension TaskEntity {

}
