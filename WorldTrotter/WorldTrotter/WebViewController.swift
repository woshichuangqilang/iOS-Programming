//
//  WKWebView.swift
//  WorldTrotter
//
//  Created by Wenslow on 15/12/23.
//  Copyright © 2015年 Wenslow. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController {
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        
        let aURL = NSURL.init(string: "https://www.bignerdranch.com")
        
        let req = NSURLRequest(URL: aURL!)
        
        webView.loadRequest(req)
        
        view = webView
    }
    
       
        
    
}
