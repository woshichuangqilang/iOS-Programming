//
//  WIkiAPI.swift
//  wiki
//
//  Created by Wenslow on 16/1/12.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import Foundation

enum Action: String {
    case query = "query"
}

enum URLTitle: String {
    case mainPage = "Main Page"
}

enum PopularTitleResults {
    case Success([PolularResult])
    case Failure(ErrorType)
}
enum WikiError: ErrorType {
    case InvalidJSONData
}

class WikiAPI {
    
    private static let baseURLString = "https://en.wikipedia.org/w/api.php"
    
    private class func wikiURL(action action: Action, title: URLTitle) -> NSURL {
        
        let components = NSURLComponents(string: baseURLString)!
        
        var queryItem = [NSURLQueryItem]()
        
        let baseParams = [
            "action": action.rawValue,
            "titles": title.rawValue,
            "format": "json",
            "prop": "revisions",
            "rvprop": "content"
        ]
        
        for (key, value) in baseParams {
            let item = NSURLQueryItem(name: key, value: value)
            print(item)
            queryItem.append(item)
        }
        
        components.queryItems = queryItem
        print(components)
        return components.URL!
    }
    
    static func titleFromJSONData(data: NSData)->PopularTitleResults {
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            guard let jsonDictionary = jsonObject as? [NSObject: AnyObject],
            results = jsonDictionary["result"] as? [String: AnyObject],
            collection = results["collection1"] as? [String: AnyObject],
                title = collection["Title"] as? [[String: AnyObject]] else {
                    return .Failure(WikiError.InvalidJSONData)
            }
            
            var popularTitles = [PolularResult]()
            for polularResultJSON in title {
                if let polularResult = popularTitleFromJSONObject(polularResultJSON) {
                    popularTitles.append(polularResult)
                }
            }
            if popularTitles.count == 0 && title.count > 0 {
                return .Failure(WikiError.InvalidJSONData)
            }
            print(popularTitles)
            return .Success(popularTitles)
        }
        catch let error {
            return .Failure(error)
        }
    }
    
    private static func popularTitleFromJSONObject(json: [String: AnyObject]) -> PolularResult? {
        guard let
            title = json["text"] as? String,
            remoteURLString = json["href"] as? String,
            url = NSURL(string: remoteURLString) else {
                return nil
        }
        return PolularResult(title: title, remoteURL: url, section1: "")
    }
}