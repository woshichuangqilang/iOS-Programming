//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Wenslow on 15/12/21.
//  Copyright © 2015年 Wenslow. All rights reserved.
//

import UIKit
class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    //MARK:字符串格式
    let numberFormatter: NSNumberFormatter = {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    var fahrenheitValue: Double? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Double? {
        if let value = fahrenheitValue {
            return (value - 32) * (5 / 9)
        } else {
            return nil
        }
    }
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let nonDigitSet = NSCharacterSet.decimalDigitCharacterSet().invertedSet
        
        let component = string.componentsSeparatedByCharactersInSet(nonDigitSet)
        
        let filtered = component.joinWithSeparator("")
        
        
        
        
//        let exisitingTextHasDecimalSeparator = textField.text?.rangeOfString(".")
//        let replacementTextHasDecimalSeparator = string.rangeOfString(".")
        
        let currentLocale = NSLocale.currentLocale()
        let decimalSeparator = currentLocale.objectForKey(NSLocaleDecimalSeparator) as! String
        
        let exisitingTextHasDecimalSeparator = textField.text?.rangeOfString(decimalSeparator)
        let replacementTextHasDecimalSeparator = string.rangeOfString(decimalSeparator)
        
        if exisitingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil {
            return false
        } else if string != filtered {
            return false
        } else {
            return true
        }
    }
    
    func updateCelsiusLabel() {
        if let value = celsiusValue {
//            celsiusLabel.text = "\(value)"
            celsiusLabel.text = numberFormatter.stringFromNumber(value)
        } else {
            celsiusLabel.text = "???"
        }
    }

    @IBAction func fahrenheiFieldEditingChanged(textField: UITextField) {
//        if let text = textField.text, value = Double(text) {
//            fahrenheitValue = value
//            print(fahrenheitValue)
//        } else {
//            fahrenheitValue = nil
//        }
        
        if let text = textField.text, number = numberFormatter.numberFromString(text ) {
            fahrenheitValue = number.doubleValue
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard (sender: AnyObject) {
        textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ConversionViewController loaded its view")
    }
    
    override func viewWillAppear(animated: Bool) {
//        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
//        let dateComponents = calendar.componentsInTimeZone(NSTimeZone.defaultTimeZone(), fromDate: NSDate())
//        let isDark = dateComponents.hour >= 19 || dateComponents.hour <= 6
//        
//        
//        if isDark {
//            view.backgroundColor = UIColor.darkGrayColor()
//
//        }
        
        func randomCGFloat() ->CGFloat {
            return CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        }
       
        func randomColor() ->UIColor {
            let r = randomCGFloat()
            let g = randomCGFloat()
            let b = randomCGFloat()
            
            return UIColor(red: r, green: g, blue: b, alpha: 1.0)
        }
        
        view.backgroundColor = randomColor()
    }
}
