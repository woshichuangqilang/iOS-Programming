//
//  DetialViewController.swift
//  Homepwner
//
//  Created by Wenslow on 16/1/2.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class DetialViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore!
    
    //MARK: 选取照片
    //删除照片
    @IBAction func deleteImage(sender: AnyObject) {
        if let _ = imageStore.imageForKey(item.itemKey) {
            imageStore.deleteImageForKey(item.itemKey)
            imageView.image = nil
        }
    }
    
    //添加图片
    @IBAction func takePicture(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        
        //检测设备是否有摄像头，有则拍摄照片，没有则从照片库选取照片
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
            
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        imagePicker.delegate = self
        
        //在屏幕上展示图片选择器
        presentViewController(imagePicker, animated: true, completion: nil)
        
        imagePicker.allowsEditing = true

    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //获取编辑过的图片
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        //将image保存到imageStore
        imageStore.setImage(image, forKey: item.itemKey)
        
        //展示图片
        imageView.image = image
        
        //退出图片选择器
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: 设置键盘退出
    //回车键推出键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //点击屏幕推出编辑模式，键盘弹出
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //MARK: 传值
    //向DatePickerController传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //判断目标segue是否是 ShowItem
        if segue.identifier == "PickDate" {
            
        let datePickerController = segue.destinationViewController as! DatePickerController
            
        datePickerController.item = item
            
        }
    }
    
    let numberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle =  .DecimalStyle
        formatter.minimumFractionDigits = 2 //小数点后最多显示多少位
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle =  .MediumStyle
        formatter.timeStyle =  .NoStyle
        return formatter
    }()
    
    //MARK: view life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //清除第一响应者
        view.endEditing(true)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
//        valueField.text = "\(item.valueInDollars)"
//        dateLabel.text = "\(item.dateCreated)"
        valueField.text = numberFormatter.stringFromNumber(item.valueInDollars)
        dateLabel.text = dateFormatter.stringFromDate(item.dateCreated)
        
        //获取item key
        let key = item.itemKey
        
        //展示获取的image
        let imageToDisplay = imageStore.imageForKey(key)
        imageView.image = imageToDisplay
    }
    
    //视图返回时，传值
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //将编辑过的内容保存到item中
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text, value = numberFormatter.numberFromString(valueText) {
            item.valueInDollars = value.integerValue
        } else {
            item.valueInDollars = 0
        }
    }

}
