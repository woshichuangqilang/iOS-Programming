//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Wenslow on 16/1/8.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchRecentPhotos()
    }
    
}
