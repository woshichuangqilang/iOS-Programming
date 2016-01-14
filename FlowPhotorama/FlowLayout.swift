//
//  FlowLayout.swift
//  FlowPhotorama
//
//  Created by Wenslow on 16/1/10.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class FlowLayout: UICollectionViewFlowLayout {

//    let previousOffset: CGFloat
//    let mainIndexPath: NSIndexPath
//    let movingInIndexPath: NSIndexPath
//    let diffrence: CGFloat
//    
//    override func prepareLayout() {
//        super.prepareLayout()
//        self.setUpLayout()
//    }
//    
//    func setUpLayout() {
//        var inset = (self.collectionView?.bounds.width)! * (6 / 64.0)
//        inset = floor(inset)
//        
//        self.itemSize = CGSizeMake((self.collectionView?.bounds.width)! - 2 * inset, (self.collectionView?.bounds.height)! * 3 / 4)
//        self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset)
//    }
//    
//    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        let attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
//        self.ap
//    }
//    
//    func applyTransformToLayoutAttributes(attribute: UICollectionViewLayoutAttributes) {
//        if attribute.indexPath.section == mainIndexPath.section {
//            let cell = self.collectionView?.cellForItemAtIndexPath(mainIndexPath)
//            attribute.transform3D = self.trans
//        }
//    }
//    
//    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
//        return true
//    }
//    
//    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        
//        let attibutes = flowLayout.layoutAttributesForItemAtIndexPath(itemIndexPath)
//        
//        attibutes?.alpha = 0.0
//        let size = self.collectionView?.frame.size
//        
//        attibutes?.center = CGPointMake((size?.width)! / 2, (size?.height)! / 2)
//        
//        return attibutes
//    }
//    
//    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
//        
//        super.prepareForCollectionViewUpdates(updateItems)
//        
////        var indexPath = [UICollectionViewUpdateItem]()
////        
////        for updateItem in updateItems {
////            switch updateItem.updateAction {
////            case .Insert:
////                [indexPath.append(.indexPathAfterUpdate)]
////            }
////        }
//        
//    }
//    
//    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        let attibutes = flowLayout.layoutAttributesForItemAtIndexPath(itemIndexPath)
//        
//        attibutes?.alpha = 0.0
//        let size = self.collectionView?.frame.size
//        
//        attibutes?.center = CGPointMake((size?.width)! / 2, (size?.height)! / 2)
//        
//        return attibutes
//    }
    
}
