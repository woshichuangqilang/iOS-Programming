//
//  PhotoViewController.swift
//  Photorama
//
//  Created by Wenslow on 16/1/9.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchRecentPhotos() {
            (photoResult) -> Void in
            
            switch photoResult {
            case let .Success(photos):
                print("Successfully found \(photos.count) recent photos.")
                
                //MARK: 下载第一张图片
                if let firstPhoto = photos.first {
                    self.store.fetchImageForPhoto(firstPhoto, completion: { (imageResult) -> Void in
                        
                        switch imageResult {
                        case let .Success(image):
//                            self.imageView.image = image
                            //强制运行在主线程
                            NSOperationQueue.mainQueue().addOperationWithBlock({
                                self.imageView.image = image
                            })
                        case let .Failure(error):
                            print("Error downloading image: \(error)")
                        }
                    })
                }
            case let .Failure(error):
                print("Error fetching recent photos: \(error)")
            }
        }
        
    }
}
