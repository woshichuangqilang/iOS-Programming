//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Wenslow on 16/1/10.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func updateWithImage(image: UIImage?) {
        if let imageToDispaly = image {
            spinner.stopAnimating()
            imageView.image = imageToDispaly
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    //is called after the interface file is loaded in and the outlet connections are made
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateWithImage(nil)
        
    }
    
    //is called when a cell is about to reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateWithImage(nil)
    }
}