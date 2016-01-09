//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Wenslow on 16/1/8.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import Foundation

enum Method: String {
    case RecentPhotos = "flickr.photos.getRecent"
}

struct FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    
    //得到完整URL
    private static func flickrURL(method method: Method, parameters: [String: String]?) ->NSURL {
        
        let components = NSURLComponents(string: baseURLString)!
        
        var querItems = [NSURLQueryItem]()
        
        let baseParams = ["method": method.rawValue, "format": "json", "nojsoncallback": "1", "api_key": APIKey]
        
        for (key, value) in baseParams {
            let item = NSURLQueryItem(name: key, value: value)
            querItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = NSURLQueryItem(name: key, value: value)
                querItems.append(item)
            }
        }
        components.queryItems = querItems
        
        return components.URL!
    }
    
    static func recentPhotosURL() -> NSURL {
        return flickrURL(method: .RecentPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
}