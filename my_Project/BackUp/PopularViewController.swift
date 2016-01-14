//
//  ViewController.swift
//  ZTWWiki
//
//  Created by Wenslow on 16/1/14.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class PopularViewController: UITableViewController {
    
//    @IBOutlet weak var popularView: UITableViewCell!
    
    
    
    
    var store = PopularStore()
    var items = [PopularURL]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            self.items = self.store.fetchTodayPopularURL(self.items)
            dispatch_async(dispatch_get_main_queue()){
                print(self.items.description)
                self.tableView.reloadData()
            }
        }
        
        
        
        
//            (popularURLResults) -> Void in
//            print(self.items.description)
//            
//            NSOperationQueue.mainQueue().addOperationWithBlock(){
//                switch popularURLResults {
//                case let .Success(popularURLs):
//                    print("Successfully found \(popularURLs.count) recent URLs")
////                    self.items = popularURLs
//                case let .Failure(error):
//                    print("Error fetching recent URLs: \(error)")
//                    self.items.removeAll()
//                }
//                
//                print("01")
//                self.tableView.reloadData()
//            }
//        }
    
        

        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "UITableCell")
        print("02")
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = String(item.content)
        
        
        return cell
        
    }
    

}

