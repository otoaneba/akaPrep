//
//  BabyEntity.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/29/24.
//

import Foundation
import CoreData

@objc(BabyEntity)
public class BabyEntity: NSManagedObject {
}

extension BabyEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BabyEntity> {
        return NSFetchRequest<BabyEntity>(entityName: "BabyEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var dateOfBirth: Date
    // @NSManaged public var baby: BabyEntity
    @NSManaged private var genderRaw: String
    @NSManaged public var goal: [String]
    
    
    public var gender: Gender {
           get {
               return Gender(rawValue: genderRaw) ?? .female
           }
           set {
               genderRaw = newValue.rawValue
           }
       }
}

extension BabyEntity {
    public enum Gender: String, Codable {
        case female
        case male
        case other
    }
}
