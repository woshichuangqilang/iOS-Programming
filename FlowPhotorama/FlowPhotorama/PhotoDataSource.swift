//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by Wenslow on 16/1/10.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit


class PhotoDataSource: UICollectionViewFlowLayout, UICollectionViewDataSource  {
    
    var photos = [Photo]()
    
    
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    
    //重复利用Cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        let photo = photos[indexPath.row]
        cell.updateWithImage(photo.image)
        
        return cell
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
        attributes!.transform = CGAffineTransform(a: 1.5, b: 2.5, c: 3.5, d: 4.5, tx: 0.5, ty: 1.0)
        return attributes
    }
    
    
    
//    override func invalidateLayout() {
//        super.invalidateLayout()
//        
//        
//    }
//    
//    override func prepareLayout() {
//        super.prepareLayout()
//    }
    
    
    
    
    
    
    
//    override func collectionViewContentSize() -> CGSize {
//        return CGSizeMake(1000, 1000)
//    }
    

    
//    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//    
//            let attibutes = self.layoutAttributesForItemAtIndexPath(itemIndexPath)
//    
////            attibutes?.alpha = 0.0
//            let size = self.collectionView?.frame.size
//    
//            attibutes?.center = CGPointMake((size?.width)! / 2, (size?.height)! / 2)
//    
//            return attibutes
//        }
//    
//        override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
//    
//            super.prepareForCollectionViewUpdates(updateItems)
//    
//    //        var indexPath = [UICollectionViewUpdateItem]()
//    //
//    //        for updateItem in updateItems {
//    //            switch updateItem.updateAction {
//    //            case .Insert:
//    //                [indexPath.append(.indexPathAfterUpdate)]
//    //            }
//    //        }
//    
//        }
//    
//        override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//            let attibutes = self.layoutAttributesForItemAtIndexPath(itemIndexPath)
//    
//            attibutes?.alpha = 0.0
//            let size = self.collectionView?.frame.size
//    
//            attibutes?.center = CGPointMake((size?.width)! / 2, (size?.height)! / 2)
//            
//            return attibutes
//        }
    

}