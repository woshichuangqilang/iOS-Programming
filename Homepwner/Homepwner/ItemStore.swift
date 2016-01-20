//
//  ItemStore.swift
//  Homepwner
//
//  Created by Wenslow on 16/1/1.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class ItemStore {
    
    var allItems = [Item]()
    
    //创建存储路径
    let itemArchiveURL: NSURL = {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("item.archives")
    }()
    
    //当程序退出时保存数据
    func saveChanges() ->Bool {
        print("Saving items to: \(itemArchiveURL.path!)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path!)
    }
    
    func createItem() -> Item {
        
        let newItem = Item(random: true)
//        if allItems.count == 1 {
//            allItems.insert(newItem, atIndex: 0)
//        } else {
        allItems.insert(newItem, atIndex: 0)
       // }
        return newItem
    }
    
    func removeItem(item: Item) {
        if let index = allItems.indexOf(item) {
            allItems.removeAtIndex(index)
        }
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        //将该item删除
        let movedItem = allItems.removeAtIndex(fromIndex)
        
        //再将该item插入到数组中的心位置
        allItems.insert(movedItem, atIndex: toIndex)
    }
    
    //初始化itemStore时，从文件中读取数据
    init(){
        if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchiveURL.path!) as? [Item] {
            allItems += archivedItems
        }
    }
    
}
