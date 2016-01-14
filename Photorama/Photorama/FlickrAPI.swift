//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Wenslow on 16/1/9.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import Foundation
import CoreData

enum Method: String{
    case RecentPhotos = "flickr.photos.getRecent"
}

//解析JSON数据
enum PhotoResult {
    case Success([Photo])//解析成功，并创建的Photo对象
    case Failure(ErrorType)
}

//自定义json错误
enum FlickrError: ErrorType {
    case InvalidJSONData
}

struct FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    
    //日期格式
    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    //将JSON数据解析到Photo的实例中
    private static func photoFromJSONObject(json: [String: AnyObject], inContext context: NSManagedObjectContext) -> Photo? {
        guard let
            photoID = json["id"] as? String,
            title = json["title"] as? String,
            dateString = json["datetaken"] as? String,
            photoURLString = json["url_h"] as? String,
            url = NSURL(string: photoURLString),
            dateTaken = dateFormatter.dateFromString(dateString) else {
                return nil
        }
//        return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
        
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        let predicate = NSPredicate(format: "photoID == \(photoID)")
        fetchRequest.predicate = predicate
        
        var fetchedPhotos: [Photo]!
        context.performBlockAndWait(){
            fetchedPhotos = try! context.executeFetchRequest(fetchRequest) as! [Photo]
        }
        
        if fetchedPhotos.count > 0 {
            return fetchedPhotos.first
        }
        
        var photo: Photo!
        context.performBlockAndWait(){
            photo = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: context) as! Photo
            photo.title = title
            photo.photoID = photoID
            photo.remoteURL = url
            photo.dateTaken = dateTaken
        }
        
        return photo
    }
    
    
    //将JSON数据转化为基础数据
    static func photosFromJSONData(data: NSData, inContext context: NSManagedObjectContext) -> PhotoResult {
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            guard let
                jsonDictionary = jsonObject as? [NSObject: AnyObject],
                photos = jsonDictionary["photos"] as? [String: AnyObject],
                photosArray = photos["photo"] as? [[String: AnyObject]] else {
                    //JSON结构不匹配
                    print("JSON结构不匹配")
                    return .Failure(FlickrError.InvalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photoFromJSONObject(photoJSON, inContext: context) {
                    finalPhotos.append(photo)
                    
                }
            }
            
            if finalPhotos.count == 0 && photosArray.count > 0 {
                //得不到任何photos
                print("得不到任何photos")
                return .Failure(FlickrError.InvalidJSONData)
            }
            return .Success(finalPhotos)
        }
        catch let error {
            return .Failure(error)
        }
        
    }
    
    //MARK: 合成URL
    private static func flickrURL(method method: Method, parameters: [String: String]?) -> NSURL {
        
        let components = NSURLComponents(string: baseURLString)!
        
        var queryItems = [NSURLQueryItem]()
        
        //默认访问参数
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": APIKey
        ]
        
        for (key, value) in baseParams {
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let addtionalParams = parameters {
            for (key, value) in addtionalParams {
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
//        print(components.URL!)
        return components.URL!
    }
    
    static func recentPhotoURL() -> NSURL {
        return flickrURL(method: .RecentPhotos, parameters: ["extras": "url_h,date_taken"])
    }
}

