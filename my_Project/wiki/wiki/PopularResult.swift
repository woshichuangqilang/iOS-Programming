//
//  File.swift
//  wiki
//
//  Created by Wenslow on 16/1/14.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class PolularResult {
    let title: String
    let remoteURL: NSURL
    let section1: String
    var image: UIImage?
    var imageURL: NSURL?
    
    init(title: String, remoteURL: NSURL, section1: String) {
        self.title = title
        self.remoteURL = remoteURL
        self.section1 = section1
    }
}