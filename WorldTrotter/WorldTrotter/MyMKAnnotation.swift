//
//  MyMKAnnotation.swift
//  MapPin
//
//  Created by Wenslow on 15/12/28.
//  Copyright © 2015年 Wenslow. All rights reserved.
//

import UIKit
import MapKit

class MyMKAnnotation: MKPointAnnotation {
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        super.init()
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
    }
}
