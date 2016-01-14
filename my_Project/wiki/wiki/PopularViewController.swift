//
//  ViewController.swift
//  wiki
//
//  Created by Wenslow on 16/1/12.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let session = PopularSession()
        session.fetchTodayPopularPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

