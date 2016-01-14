//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Wenslow on 16/1/12.
//  Copyright © 2016年 Wenslow. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var photoID: String
    @NSManaged var photoKey: String
    @NSManaged var title: String
    @NSManaged var dateTaken: NSDate
//    @NSManaged var remoteURL: NSObject
    @NSManaged var remoteURL: NSURL
    
}
