//
//  DarePickerController.swift
//  Homepwner
//
//  Created by Wenslow on 16/1/3.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class DatePickerController: UIViewController {
    
    var item: Item!
    
    @IBOutlet var pickedDate: UIDatePicker!
    
    //从DetialViewController获取数据
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Pick a Date"
        pickedDate.date = item.dateCreated
    }
    
    //视图返回时，修改date的数值
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        item.dateCreated = pickedDate.date
        
    }
}
