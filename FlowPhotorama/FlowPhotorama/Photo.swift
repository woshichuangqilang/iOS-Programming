//
//  Photo.swift
//  Photorama
//
//  Created by Wenslow on 16/1/9.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class Photo {
    
    let title: String
    let remoteURL: NSURL
    let photoID: String
    let dateTaken: NSDate
    var image: UIImage?
    
    init(title: String, photoID: String, remoteURL: NSURL, dateTaken: NSDate) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
    
    
}

extension Photo: Equatable {}

func == (lhs: Photo, rhs: Photo) -> Bool {
    //photoID 相同，则图片相同
    return lhs.photoID == rhs.photoID
}