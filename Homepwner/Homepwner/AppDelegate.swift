//
//  AppDelegate.swift
//  Homepwner
//
//  Created by Wenslow on 16/1/1.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let itemStore = ItemStore()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        print(__FUNCTION__)
        
        //创建一个ImageStore
        let imageStore = ImageStore()
        
        //连接ItemsViewController，并设置item store
//        let itemsController = window!.rootViewController as! ItemsViewController
        
        //让navigation成为根视图
        let navController = window!.rootViewController as! UINavigationController
        let itemsController = navController.topViewController as! ItemsViewController
        
        //接入ItemViewController，并设置itemStore和imageStore
        itemsController.itemStore = itemStore
        itemsController.imageStore = imageStore
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        print(__FUNCTION__)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        print(__FUNCTION__)
        
        let success = itemStore.saveChanges()
        if success {
            print("Saved all of the Items")
        } else {
            print("Could not save any of the Items")
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        print(__FUNCTION__)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        print(__FUNCTION__)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        print(__FUNCTION__)
    }


}

