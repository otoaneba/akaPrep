//
//  ProfileEntity.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/29/24.
//

import CoreData
import UIKit

@objc(ProfileEntity)
public class ProfileEntity: NSManagedObject {
}

extension ProfileEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileEntity> {
        return NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity")
    }

    @NSManaged public var firstName: String
    @NSManaged public var lastName: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var genderRaw: String
    // @NSManaged public var baby: BabyEntity
    @NSManaged private var workScheduleRaw: String
    @NSManaged public var currentLists: [ListEntity] // at most 3 and some may be expired
    @NSManaged public var savedLists: [ListEntity]
    @NSManaged public var profilePicture: Data?
    
    public var workSchedule: WorkSchedule {
        get {
           return WorkSchedule(rawValue: workScheduleRaw) ?? .unemployed
        }
        set {
           workScheduleRaw = newValue.rawValue
        }
    }
    
    public var gender: Gender {
        get {
           return Gender(rawValue: genderRaw) ?? .female
        }
        set {
           genderRaw = newValue.rawValue
        }
    }
}

extension ProfileEntity {
    static func getProfilePicture(context: NSManagedObjectContext) -> UIImage? {
        let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        do {
            let result = try context.fetch(request).first
            if let data = result?.profilePicture {
                return UIImage(data: data)
            }
        } catch {
            print("Failed to fetch profile picture: \(error)")
        }
        return nil
    }
}

