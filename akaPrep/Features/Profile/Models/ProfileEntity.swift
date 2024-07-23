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
                print("Fetched profile picture data of size: \(data.count) bytes")
                return UIImage(data: data)
            } else {
                print("No profile picture data found")
            }
        } catch {
            print("Failed to fetch profile picture: \(error)")
        }
        return nil
    }
    
    static func getProfileName(context: NSManagedObjectContext) -> String? {
        let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        do {
            let result = try context.fetch(request).first
            if let data = result?.firstName {
                print("Fetched profile name data of size: \(data.count) bytes")
                return data
            } else {
                print("No profile name data found")
            }
        } catch {
            print("Failed to fetch profile picture: \(error)")
        }
        return nil
    }
    
    func saveProfilePicture(image: UIImage, context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            let profileEntity: ProfileEntity
            
            if let existingProfile = results.first {
                // Update existing profile
                profileEntity = existingProfile
            } else {
                // Create a new profile entity
                profileEntity = ProfileEntity(context: context)
            }
            
            // Convert UIImage to Data
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                profileEntity.profilePicture = imageData
            }
            
            // Save context
            try context.save()
            // Post notification after saving the image
            NotificationCenter.default.post(name: .profileImageUpdated, object: nil)
        } catch {
            print("Failed to save profile picture: \(error)")
        }
    }
    
    static func getProfile(context: NSManagedObjectContext) -> ProfileEntity? {
        let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch profile: \(error)")
            return nil
        }
    }
}

extension Notification.Name {
    static let profileImageUpdated = Notification.Name("profileImageUpdated")
    static let profileNameUpdated = Notification.Name("profileNameUpdated")
}
