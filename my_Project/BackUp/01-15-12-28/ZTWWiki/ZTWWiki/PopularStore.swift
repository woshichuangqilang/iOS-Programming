//
//  PopularStore.swift
//  ZTWWiki
//
//  Created by Wenslow on 16/1/14.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit


class PopularStore {
    
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    //处理从服务器得到的JSON数据
    func processRecentPopularURLsRequest(data data: NSData?, error: NSError?) -> PopularURLResults {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        
        return PopularAPI.popularURLsFromJSONData(jsonData)
    }
    
    func fetchTodayPopularURL(var items: [PopularURL]) ->[PopularURL]{

//        let url = PopularAPI.recentPopularURL()
        let url = NSURL(string: "https://www.kimonolabs.com/api/626fdtyu?apikey=ZyxnQM3AIL6U6zEjfrXJeG5u4CCC90rW&kimpath1=wiki&kimpath2=Shetland_sheep&kimbypage=1")
        print(url)
        let request = NSURLRequest(URL: url!)
        
        let jsonData = NSData(contentsOfURL: url!)
        
        let jsonObject = JSON(data: jsonData!)
        
        
        for i in 0..<10 {
            let item = PopularURL(title: "", remoteURL: NSURL(string: "")!, content: "")
            
            
            
            
            if let jTitle = jsonObject["results"][i]["collection1"][0]["title"].string {
                item.title = jTitle
            }
            
            if let jContent = jsonObject["results"][i]["collection2"][0]["context"].string {
               item.content = jContent 
            }
            
            
            
            if let jURL = jsonObject["results"][i]["collection1"][0]["url"].string {
                item.remoteURL = NSURL(string: jURL)
            }
            
            if let jImageURLString = jsonObject["results"][i]["collection1"][0]["image"]["src"].string {
                item.imageURL = NSURL(string: jImageURLString)
                let imageData = NSData(contentsOfURL: item.imageURL!)
                item.image = UIImage(data: imageData!, scale: 3)
            }
            
            items.append(item)
            print(items[i].title)
        }
        print("\(items[1].content) sdf")
        print("\(items[0].title, items[5].title, String(items[2].imageURL))")
        
//        let task = session.dataTaskWithRequest(request){
//            (data, response, error)-> Void in
//            
//            if let jsonData = data {
//                if let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) {
//                    print(jsonString)
//                    print("45")
//                }
//            }else if let requestError = error {
//                print("Error fetching main page: \(requestError)")
//            } else {
//                print("Unexpected error with the request")
//            }
//            
//            
//            
//            
//            
////            let result = self.processRecentPopularURLsRequest(data: data, error: error)
////            completion(result)
//        }
//        task.resume()
        return items
    }
    
    
}