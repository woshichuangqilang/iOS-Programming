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
    
 
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableCell", forIndexPath: indexPath) as! ItemCell
        
        let item = items[indexPath.row]

        cell.titleLabel.text = item.title
        cell.contextLabel.text = item.content!
        if items[indexPath.row].image != nil {
            let imageView = UIImageView(image: items[indexPath.row].image)
            cell.accessoryView = imageView
        }
        return cell
        
    }
    

}

