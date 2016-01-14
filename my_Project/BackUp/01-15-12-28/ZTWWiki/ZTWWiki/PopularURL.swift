//
//  PopularURL.swift
//  ZTWWiki
//
//  Created by Wenslow on 16/1/14.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class PopularURL {
    
    var title: String?
    var remoteURL: NSURL?
    var content: String?
    var imageURL: NSURL?
    var image: UIImage?
    init(title: String, remoteURL: NSURL, content: String) {
        self.title = title
        self.remoteURL = remoteURL
        self.content = ""
        
    }
    
}