//
//  LikedListEntity+CoreDataProperties.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/6/24.
//
//

import Foundation
import CoreData


extension LikedListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedListEntity> {
        return NSFetchRequest<LikedListEntity>(entityName: "LikedListEntity")
    }
}

