//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Wenslow on 15/12/22.
//  Copyright © 2015年 Wenslow. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var  mapView: MKMapView!
    var locateManage = CLLocationManager()
    var currentCoordinate:CLLocationCoordinate2D?
    
//    var firstPin = MKPinAnnotationView()
//    var secondPin = MKPinAnnotationView()
//    var thirdPin = MKPinAnnotationView()
    
    
    override func loadView() {
        //creat a map view
        mapView = MKMapView()
 
        //Set it as the view of view controller
        view = mapView

//        let segmentedControl = UISegmentedControl(items: ["Stander", "Hybride", "Stellite"])
        
        let standerString = NSLocalizedString("Standard", comment: "Standar map view")
        let satelliteString = NSLocalizedString("Satellie", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        
        let segmentedControl = UISegmentedControl(items: [standerString,satelliteString, hybridString])
        
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: "mapTypeChanged:", forControlEvents: .ValueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(segmentedControl)
        
//        let topConstraint = segmentController.topAnchor.constraintEqualToAnchor(view.topAnchor)
        
        let topConstraint = segmentedControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 8)
//
//        let leadingConstraint = segmentController.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor)
//        
//        let trailingConstraint = segmentController.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor)
        
        let margins = view.layoutMarginsGuide
        
        let leadingConstraint = segmentedControl.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        
        let trailingConstraint = segmentedControl.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        topConstraint.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
        
        let annotation1 = MyMKAnnotation.init(title: "上海", subtitle: "潼港八村", coordinate: CLLocationCoordinate2D(latitude: 31.35, longitude: 121.57))
        
        mapView.addAnnotation(annotation1)
        
        
    }
    
    func mapTypeChanged(segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0: mapView.mapType = .Standard
        case 1: mapView.mapType = .Hybrid
        case 2: mapView.mapType = .Satellite
        default: break
        }
    }
    
    
    override func viewDidLoad() {
        //Always call the super implementation of viewDidLoad
        
        self.locateManage.delegate = self
        
        //请求定位权限
        if self.locateManage.respondsToSelector(Selector("requestAlwaysAuthorization")) {
            self.locateManage.requestAlwaysAuthorization()
        }
        
        self.locateManage.desiredAccuracy = kCLLocationAccuracyBest//定位精准度
        self.locateManage.startUpdatingLocation()//开始定位
        
        self.mapView.showsUserLocation = true

//        firstPin.pinTintColor = MKPinAnnotationView.redPinColor()
//        
//        secondPin.pinTintColor = MKPinAnnotationView.greenPinColor()
//        
//        thirdPin.pinTintColor = MKPinAnnotationView.purplePinColor()
//        
//
//        
//        firstPin.animatesDrop = true
        
//        let a = CGRect(x: 20, y: 500, width: 30, height: 30)
//        
//        let pinController = UIButton(frame: a)
//        
//        pinController.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.5)
//        
//        mapView.addSubview(pinController)
//        
        super.viewDidLoad()
//
//    }
//    
//    @IBAction func pinController (sender: UIButton) {
//        
//    }
    
    //CLLocationManager定位代理方法
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("hello")
        if let newLoca = locations.last {
            CLGeocoder().reverseGeocodeLocation(newLoca, completionHandler: { (pms, err) -> Void in
                if let newCoordinate = pms?.last?.location?.coordinate {
                    //此处设置地图中心点为定位点，缩放级别18
                    self.mapView.setCenterCoordinateLevel(newCoordinate, zoomLevel: 15, animated: true)
                    manager.stopUpdatingLocation()//停止定位，节省电量，只获取一次定位
                    
                    self.currentCoordinate = newCoordinate
                    
                    }
            })
        }
    }
}

extension MKMapView {
    
    var MERCATOR_OFFSET:Double {
        return 268435456.0
    }
    var MERCATOR_RADIUS:Double {
        return 85445659.44705395
    }
    
    public func setCenterCoordinateLevel(centerCoordinate:CLLocationCoordinate2D,var zoomLevel:Double,animated:Bool) {
        //设置最小缩放级别
        zoomLevel  = min(zoomLevel, 22)
        
        let span   = self.coordinateSpanWithMapView(self, centerCoordinate: centerCoordinate, zoomLevel: zoomLevel);
        let region = MKCoordinateRegionMake(centerCoordinate, span);
        
        self.setRegion(region, animated: animated)
        
    }
    
    func longitudeToPixelSpaceX(longitude:Double) ->Double {
        return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0)
    }
    
    func latitudeToPixelSpaceY(latitude:Double) ->Double {
        return round(MERCATOR_OFFSET - MERCATOR_RADIUS * log((1 + sin(latitude * M_PI / 180.0)) / (1 - sin(latitude * M_PI / 180.0))) / 2.0)
    }
    
    func pixelSpaceXToLongitude(pixelX:Double) ->Double {
        return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI
    }
    
    func pixelSpaceYToLatitude(pixelY:Double) ->Double {
        return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI
    }
    
    func coordinateSpanWithMapView(mapView:MKMapView,
        centerCoordinate:CLLocationCoordinate2D,
        zoomLevel:Double) -> MKCoordinateSpan
    {
        let centerPixelX = self.longitudeToPixelSpaceX(centerCoordinate.longitude)
        let centerPixelY = self.latitudeToPixelSpaceY(centerCoordinate.latitude)
        let zoomExponent = 20.0 - zoomLevel
        let zoomScale = pow(2.0, zoomExponent)
        
        let mapSizeInPixels = mapView.bounds.size
        let scaledMapWidth  = Double(mapSizeInPixels.width) * zoomScale
        let scaledMapHeight = Double(mapSizeInPixels.height) * zoomScale
        
        let topLeftPixelX = centerPixelX - (scaledMapWidth/2)
        let topLeftPixelY = centerPixelY - (scaledMapHeight/2)
        
        let minLng = self.pixelSpaceXToLongitude(topLeftPixelX)
        let maxLng = self.pixelSpaceXToLongitude(topLeftPixelX + scaledMapWidth)
        let longitudeDelta = maxLng - minLng
        
        let minLat = self.pixelSpaceYToLatitude(topLeftPixelY);
        let maxLat = self.pixelSpaceYToLatitude(topLeftPixelY + scaledMapHeight);
        let latitudeDelta = -1 * (maxLat - minLat);
        
        let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        return span
    }
}
