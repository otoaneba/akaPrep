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

    @NSManaged public var name: String
    @NSManaged private var frequencyRaw: String
    @NSManaged public var tasks: [TaskEntity]?
    @NSManaged public var expirationDate: Date
   
    public var frequency: Frequency {
           get {
               return Frequency(rawValue: frequencyRaw) ?? .daily
           }
           set {
               frequencyRaw = newValue.rawValue
           }
       }
}

extension ListEntity {
    public enum Frequency: String, Codable {
        case daily
        case weekly
        case monthly
    }
}

