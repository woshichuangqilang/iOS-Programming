//
//  PopularSession.swift
//  wiki
//
//  Created by Wenslow on 16/1/12.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import Foundation

class PopularSession {
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func fetchTodayPopularPage() {
        let url = NSURL(string: "https://www.kimonolabs.com/api/ondemand/8kvt5rsc?apikey=ZyxnQM3AIL6U6zEjfrXJeG5u4CCC90rW&kimpath1=wikitrends&kimpath2=english-uptrends-today.html")
        print(url)
        let request = NSURLRequest(URL: url!)
        let task = session.dataTaskWithRequest(request){
            (data, response, error)-> Void in
            
            if let jsonData = data {
                if let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) {
                    print(jsonString)
                }
            }else if let requestError = error {
                print("Error fetching main page: \(requestError)")
            } else {
                print("Unexpected error with the request")
            }
            WikiAPI.titleFromJSONData(data!)
        }
        task.resume()
        
    }
}