//
//  ProfileEntity.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/29/24.
//

import Foundation
import CoreData

@objc(ProfileEntity)
public class ProfileEntity: NSManagedObject {
}

extension ProfileEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileEntity> {
        return NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var dateOfBirth: Date
    // @NSManaged public var baby: BabyEntity
    @NSManaged private var workScheduleRaw: String
    @NSManaged public var currentLists: [ListEntity] // at most 3 and some may be expired
    @NSManaged public var savedLists: [ListEntity]
    
    public var workSchedule: WorkSchedule {
           get {
               return WorkSchedule(rawValue: workScheduleRaw) ?? .unemployed
           }
           set {
               workScheduleRaw = newValue.rawValue
           }
       }
    
}

extension ProfileEntity {
    public enum WorkSchedule: String, Codable {
        case fullTime
        case partTime
        case unemployed
    }
}
