//
//  PhotoStore.swift
//  Photorama
//
//  Created by Wenslow on 16/1/9.
//  Copyright © 2016年 Wenslow. All rights reserved.
//
//负责初始化网络请求

import UIKit
import CoreData


//下载图片的结果
enum ImageResult {
    case Success(UIImage)
    case Failure(ErrorType)
}

//error
enum PhotoError: ErrorType {
    case ImageCreatingError
}

class PhotoStore {
    
    //是PhotoStore拥有Core Data stack
    let coreDataStack = CoreDataStack(modelName: "Photorama")
    
    let imageStore = ImageStore()
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    //下载图片
    func fetchImageForPhoto(photo: Photo, completion: (ImageResult)->Void) {
        
        let photoKey = photo.photoKey
        
        //如果下载完成，就返回图片
//        if let image = photo.image {
        if let image = imageStore.imageForKey(photoKey){
            photo.image = image
            completion(.Success(image))
            return
        }
        
        let photoURL = photo.remoteURL
        let request = NSURLRequest(URL: photoURL)
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .Success(image) = result {
                photo.image = image
                
                self.imageStore.setImage(image, forKey: photoKey)
            }
            
            //等价于
//            switch result {
//            case let .Success(image):
//                photo.image = image
//            case .Failure(_):
//                break
//            }
            
            
            //debugging
//            if let httpResponse = response as? NSHTTPURLResponse {
//                print(httpResponse.statusCode)
//                print(httpResponse.allHeaderFields)
//            }
//            
            
            
            completion(result)
        }
        
        
        task.resume()
    }
    
    //处理图片请求
    func processImageRequest(data data: NSData?, error: NSError?) -> ImageResult {
        
        guard let
            imageData = data,
            image = UIImage(data: imageData) else {
                
                //不能创建图片
                if  data == nil {
                    return .Failure(error!)
                } else {
                    return .Failure(PhotoError.ImageCreatingError)
                }
        }
        return .Success(image)
    }
    
    //获取图片信息
    func fetchRecentPhotos(completion completion:(PhotoResult) -> Void) {
        
        let url = FlickrAPI.recentPhotoURL()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            //将JSON数据打印出来
            if let jsonData = data {
                do {
                    let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
                    print(jsonObject)
                } catch let error {
                    print("Error creating JSON object: \(error)")
                }
            } else if let requestError = error {
                print("Error fetching recent photos: \(requestError)")
            } else {
                print("Unecpected error with the request")
            }
            
//            let result = self.processRecentPhotosRequest(data: data, error: error)
            
            var result = self.processRecentPhotosRequest(data: data, error: error)
            
            if case let .Success(photos) = result {
                
                //当网络请求完成时
                let mainQueueContext = self.coreDataStack.mainQueueContext
                mainQueueContext.performBlockAndWait(){
                    try! mainQueueContext.obtainPermanentIDsForObjects(photos)
                }
                let objectIDs = photos.map({$0.objectID})
                let predicate = NSPredicate(format: "self IN %@", objectIDs)
                let sortByDateTaken = NSSortDescriptor(key: "dateTaken", ascending: true)
                
                do {
                    try self.coreDataStack.saveChanges()
                    
                    let mainQueuePhotos = try self.fetchMainQueuePhotos(predicate: predicate, sortDescriptors: [sortByDateTaken])
                    result = .Success(mainQueuePhotos)
                    
                }
                catch let error {
                    result = .Failure(error)
                }
            }
            
//            if let httpResponse = response as? NSHTTPURLResponse {
//                print(httpResponse.statusCode)
//                print(httpResponse.allHeaderFields)
//            }
            
            
            completion(result)
        }
        //Task are allways created in the suspended state
        task.resume()
    }
    
    //对从服务器得到的JSON数据进行处理
    func processRecentPhotosRequest(data data: NSData?, error: NSError?) ->PhotoResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return FlickrAPI.photosFromJSONData(jsonData, inContext: self.coreDataStack.mainQueueContext)
    }
    
    //从main queue context获取photo 实例
    func fetchMainQueuePhotos(predicate predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Photo] {
        
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.sortDescriptors = sortDescriptors
//        fetchRequest.predicate = predicate
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueuePhotos: [Photo]?
        var fetchRequestError: ErrorType?
        
        mainQueueContext.performBlockAndWait(){
            do {
                mainQueuePhotos = try mainQueueContext.executeFetchRequest(fetchRequest) as? [Photo]
            }
            catch let error {
                fetchRequestError = error
            }
        }
        
        guard let photos = mainQueuePhotos else {
            throw fetchRequestError!
        }
        return photos
    }
}