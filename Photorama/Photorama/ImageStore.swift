//
//  ImageStore.swift
//  Homepwner
//
//  Created by Wenslow on 16/1/3.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class ImageStore {
    
    let cache = NSCache()
    
    //创建图片存储路径
    func imageURLForKey(key: String) -> NSURL {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.URLByAppendingPathComponent(key)
    }
    
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key )
        
        //为图片创建 全 URL
        let imageURL = imageURLForKey(key)
        
//        //将图片转换为JPGE数据
//        if let data = UIImageJPEGRepresentation(image, 0.5) {
//            //将图片写进 URL 路径
//            data.writeToURL(imageURL, atomically: true)
//        }
        
        //将图片转换为PNG数据
        if let data = UIImagePNGRepresentation(image) {
            //将图片写进 URL 路径
            data.writeToURL(imageURL, atomically: true)
        }
    }
    
    func imageForKey(key: String) ->UIImage? {
//        return cache.objectForKey(key) as? UIImage
        
        if let existingImage = cache.objectForKey(key) as? UIImage {
            return existingImage
        } else {
            //图片是否可以成功读取
            let imageURL = imageURLForKey(key)
            guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path!) else {
                return nil
            }
            cache.setObject(imageFromDisk, forKey: key)
            return imageFromDisk
        }
        
        
        
//        if let imageFromDisk = UIImage(contentsOfFile: imageURL.path!) {
//            cache.setObject(imageFromDisk, forKey: key)
//            return imageFromDisk
//        }
//        
//        return nil
        
        
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObjectForKey(key)
        
        let imageURL = imageURLForKey(key)
        
        //图片可能不存在
        do {
            try NSFileManager.defaultManager().removeItemAtURL(imageURL)
        }
//        catch {
//            print("Error removing the image from disk: \(error)")
//        }
        catch let deleteError{
            print("Error removing the image from disk: \(deleteError)")
        }
    }
    
    
    
}
