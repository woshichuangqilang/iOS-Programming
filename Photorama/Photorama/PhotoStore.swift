//
//  PhotoStore.swift
//  Photorama
//
//  Created by Wenslow on 16/1/9.
//  Copyright © 2016年 Wenslow. All rights reserved.
//
//负责初始化网络请求

import UIKit

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
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    //下载图片
    func fetchImageForPhoto(photo: Photo, completion: (ImageResult)->Void) {
        
        let photoURL = photo.remoteURL
        let request = NSURLRequest(URL: photoURL)
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .Success(image) = result {
                photo.image = image
                
            
            }
            
            //等价于
//            switch result {
//            case let .Success(image):
//                photo.image = image
//            case .Failure(_):
//                break
//            }
            
            
            //debugging
            let httpResponse = response as! NSHTTPURLResponse
            
            print(httpResponse.statusCode)
            print(httpResponse.allHeaderFields)
            
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
            
//            if let jsonData = data {
//                do {
//                    let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
//                    print(jsonObject)
//                } catch let error {
//                    print("Error creating JSON object: \(error)")
//                }
//            } else if let requestError = error {
//                print("Error fetching recent photos: \(requestError)")
//            } else {
//                print("Unecpected error with the request")
//            }
            
            let result = self.processRecentPhotosRequest(data: data, error: error)
            
            let httpResponse = response as! NSHTTPURLResponse
            
            print(httpResponse.statusCode)
            print(httpResponse.allHeaderFields)
            
            
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
        return FlickrAPI.photosFromJSONData(jsonData)
    }
}