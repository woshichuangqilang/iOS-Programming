//
//  PopularAPI.swift
//  ZTWWiki
//
//  Created by Wenslow on 16/1/14.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

enum PopularURLResults {
    case Success([PopularURL])
    case Failure(ErrorType)
}

enum WikiError: ErrorType {
    case InvalidJSONData
}

//enum KimonoAPI: String {
//    case popularURLAPI = "ZyxnQM3AIL6U6zEjfrXJeG5u4CCC90rW"
////    case popularContentAPI = "ZyxnQM3AIL6U6zEjfrXJeG5u4CCC90rW"
//}



class PopularAPI {
    
    static let baseKimonoURL = "https://www.kimonolabs.com/api/50rqkyus?"
    static let apiKey = "ZyxnQM3AIL6U6zEjfrXJeG5u4CCC90rW"
    
    //合成kimono的APIURL
    private class func kimonoURL(string: String) ->NSURL {
        
        let componets = NSURLComponents(string: baseKimonoURL)!
        
        var queryItems = [NSURLQueryItem]()
        
        var baseParams = ["apikey": apiKey]
        
        if string == "Today" {
            baseParams["kimpath1"] = "wiki"
            baseParams["kimpath2"] = "Shetland_sheep"
        }
            
//            let title = popularURL!.title
//            
//            let filtered = title.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
//            
//            baseParams["kimpath1"] = "wiki"
//            baseParams["kimpath2"] = filtered
            
        
        
        for (key, value) in baseParams {
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        componets.queryItems = queryItems
        return componets.URL!
    }
    
    //处理title
    class func popularURLsFromJSONData(data: NSData)->PopularURLResults {
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            guard let jsonDictionary = jsonObject as? [NSObject: AnyObject],
                results = jsonDictionary["results"] as? [String: AnyObject],
                collection1 = results["collection1"] as? [[String: AnyObject]] else {
                    return .Failure(WikiError.InvalidJSONData)
            }
            
            
            
            print(collection1)
            var popularURLs = [PopularURL]()
//            var collectionTitle = [[String: AnyObject]]()
//            
//            for i in 0..<10 {
//                for (_, value) in collection1[i]{
//                    collectionTitle.append(value as! [String : AnyObject])
//                }
//            }
            
            //print(collectionTitle.description)
            for polularURLJSON in collection1 {
                if let polularURL = popularURLFromJSONObject(polularURLJSON) {
                    popularURLs.append(polularURL)
                }
            }
            
            if popularURLs.count == 0 && collection1.count > 0 {
                //print("2")
                return .Failure(WikiError.InvalidJSONData)
            }
            print(popularURLs)
            return .Success(popularURLs)
        }
        catch let error {
            return .Failure(error)
        }
    }
    
    private class func popularURLFromJSONObject(json: [String : AnyObject]) -> PopularURL? {
        guard let
            
            title = json["title"] as? String,
            remoteURLString = json["url"] as? String,
            url = NSURL(string: remoteURLString)
        
            else {
                
                // Don't have enough information to construct a Photo
                return nil
        }
        
        return PopularURL(title: title, remoteURL: url, content: "")
    }
    
    //MARK: 获取title和URL
    class func recentPopularURL() ->NSURL {
        return kimonoURL("Today")
    }
    
}