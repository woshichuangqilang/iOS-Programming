//
//  Photo.swift
//  Photorama
//
//  Created by Wenslow on 16/1/12.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit
import CoreData


class Photo: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    var image: UIImage?
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        //给属性初始值
        title = ""
        photoID = ""
        remoteURL = NSURL()
        photoKey = NSUUID().UUIDString
        dateTaken = NSDate()
        
    }
    
}
