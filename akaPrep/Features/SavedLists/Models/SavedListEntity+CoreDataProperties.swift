//
//  SavedListEntity+CoreDataProperties.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/6/24.
//
//

import Foundation
import CoreData


extension SavedListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedListEntity> {
        return NSFetchRequest<SavedListEntity>(entityName: "SavedListEntity")
    }
}

