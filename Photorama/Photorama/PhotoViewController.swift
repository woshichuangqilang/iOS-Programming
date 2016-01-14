//
//  PhotoViewController.swift
//  Photorama
//
//  Created by Wenslow on 16/1/9.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UICollectionViewDelegate {
    
//    @IBOutlet var imageView: UIImageView!

    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        store.fetchRecentPhotos() {
            (photoResult) -> Void in
            
//            switch photoResult {
//            case let .Success(photos):
//                print("Successfully found \(photos.count) recent photos.")
//                
//                //MARK: 下载第一张图片
//                if let firstPhoto = photos.first {
//                    self.store.fetchImageForPhoto(firstPhoto, completion: { (imageResult) -> Void in
//                        
//                        switch imageResult {
//                        case let .Success(image):
////                            self.imageView.image = image
//                            //强制运行在主线程
//                            NSOperationQueue.mainQueue().addOperationWithBlock({
//                                self.imageView.image = image
//                            })
//                        case let .Failure(error):
//                            print("Error downloading image: \(error)")
//                        }
//                    })
//                }
//            case let .Failure(error):
//                print("Error fetching recent photos: \(error)")
//            }
            
//            NSOperationQueue.mainQueue().addOperationWithBlock(){
//                switch photoResult {
//                case let .Success(photos):
//                    print("Successfully found \(photos.count) recent photos")
//                    self.photoDataSource.photos = photos
//                case let .Failure(error):
//                    self.photoDataSource.photos.removeAll()
//                    print("Error fetching recent photos: \(error)")
//                }
//                self.collectionView.reloadSections(NSIndexSet(index: 0))
//            }
            
            let sortByDataTaken = NSSortDescriptor(key: "dateTaken", ascending: true)
            let allPhotos = try! self.store.fetchMainQueuePhotos(predicate: nil, sortDescriptors: [sortByDataTaken])
            
            NSOperationQueue.mainQueue().addOperationWithBlock(){
                self.photoDataSource.photos = allPhotos
                self.collectionView.reloadSections(NSIndexSet(index: 0))
            }
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let photo = photoDataSource.photos[indexPath.row]
        
        //下载图片数据需要时间
        store.fetchImageForPhoto(photo) { (result) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                //zai请求开始和结束时，photo的index path可能会改变，所以要找到最近的index path
                let photoIndex = self.photoDataSource.photos.indexOf(photo)!
                let photoIndexPath = NSIndexPath(forRow: photoIndex, inSection: 0)
                
                //当请求完成时，只更新可见的cel
                if let cell = self.collectionView.cellForItemAtIndexPath(photoIndexPath) as? PhotoCollectionViewCell {
                    cell.updateWithImage(photo.image)
                }
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhoto" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first {
                
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                let destinationVC = segue.destinationViewController as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        }
    }
}
