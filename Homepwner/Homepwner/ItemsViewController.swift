//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Wenslow on 16/1/1.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    //var noMoreItem = Item(name: "No more item!", serialNumber: "", valueInDollars: 0)
    var imageStore: ImageStore!
    
    //为navigation左侧添加一个编辑按钮
    required init?(coder aDeconder: NSCoder) {
        super.init(coder: aDeconder)
        
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    
    
    //MARK: 增加cell
    @IBAction func addNewItem(sender: AnyObject) {
//        //在0section的最后row，设置一个新的index path
//        let lastRow = tableView.numberOfRowsInSection(0)
//        let indexPath = NSIndexPath(forRow: lastRow, inSection: 0)
//        
//        //将新row插入到table中
//        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation:  .Automatic)
        
        //创建一个新的item，并添加到store中
        let newItem = itemStore.createItem()
        
        //设置newItem在数组中的位置
        if let index = itemStore.allItems.indexOf(newItem) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            //将新row插入到table
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation:  .Automatic)
        }
    }
    
//    @IBAction func toggleEditingMode(sender: AnyObject) {
//        //是否已经在编辑模式了
//        if editing {
//            //设置button的title
//            sender.setTitle("Edit", forState:  .Normal)
//            //关闭编辑模式
//            setEditing(false, animated: true)
//        } else {
//            //设置button的title
//            sender.setTitle("Done", forState:  .Normal)
//            //进入编辑模式
//            setEditing(true, animated: true)
//        }
//    }
    
//    //设置section的个数
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 2
//    }
    
    
    //MARK: 初始化cell
    //每个section里有几行
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
            return itemStore.allItems.count
//        } else {
//            return 1
//        }
    }
    
    //设置cell的具体内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        //创建一个UITableViewCell的实例，界面默认
//        let cell = UITableViewCell(style:  .Value1, reuseIdentifier: "UITableViewCell")

        //创建一个新的或者循环应用的cell
//        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        //更新labels的字体大小 系统大小
        cell.updateLabels()
        
//        if indexPath.section == 0 {
            //设置cell中的文字为item的description
            let item = itemStore.allItems[indexPath.row]
            
            cell.nameLabel.text = item.name
            cell.serialNumberLabel?.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
        
        
        //若value大于50，则设置颜色为绿色。反之红色
        if item.valueInDollars > 50 {
            cell.valueLabel.textColor = UIColor.greenColor()
        } else {
            cell.valueLabel.textColor = UIColor.redColor()
        }
        
        return cell
//        } else {
//            cell.textLabel?.text = "No more item!"
//            cell.detailTextLabel?.text = ""
//            return cell
//        }

        
    }
    
    
    //MARK: 编辑cell
    //删除cell
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        //如果table在要求实现删除功能
        if editingStyle ==  .Delete {
            let item = itemStore.allItems[indexPath.row]
                
            //添加删除警告
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
                
            let ac = UIAlertController(title: title, message: message, preferredStyle:  .ActionSheet)
                
            //警告中的取消
            let cancelAction = UIAlertAction(title: "Cancel", style:  .Cancel, handler: nil )
            //添加警告
            ac.addAction(cancelAction)
                
            let deleteAction = UIAlertAction(title: "Remove", style:  .Destructive, handler: { (action) -> Void in
                //将item从store中删除
                self.itemStore.removeItem(item)
                
                //将image从store中删除
                self.imageStore.deleteImageForKey(item.itemKey)
                
                //还要将row删除掉
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:  .Automatic)
            })
            ac.addAction(deleteAction)
                
            //展现alert controller
            presentViewController(ac, animated: true, completion: nil)
                
                //            //删除item
                //            itemStore.removeItem(item)
                //
                //            //还要删除相应的cell
                //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:  .Automatic)
        }
    }
    
//    //使row无法移动到最后一行
//    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
//        if proposedDestinationIndexPath.row == itemStore.allItems.count - 1 {
//            return sourceIndexPath
//        } else {
//            return proposedDestinationIndexPath
//        }
//    }
    
    //MARK:移动cell
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        //更新model
        itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
        
    }
    
//    //最后一行无法编辑
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        if indexPath.row == itemStore.allItems.count - 1 {
//            return false
//        } else {
//            return true
//        }
//    }
    
    //向DetialViewController传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //判断目标segue是否是 ShowItem
        if segue.identifier == "ShowItem" {
            
            //设置要传值的行数
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = itemStore.allItems[row]
                let detialViewController = segue.destinationViewController as! DetialViewController
                detialViewController.item = item
                detialViewController.imageStore = imageStore
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        //获取状态栏的高度
//        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
//        
//        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
//        tableView.contentInset = insets
//        tableView.scrollIndicatorInsets = insets
        
        //itemStore.allItems.append(noMoreItem)
        
//        tableView.rowHeight = 65
        //cell的高度自动化
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    //视图返回时，更新数据
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
