//
//  DrawView.swift
//  TouchTrack
//
//  Created by Wenslow on 16/1/5.
//  Copyright © 2016年 Wenslow. All rights reserved.
//

import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate {
    
    var tempLineWidth: CGFloat = 0.00001
    
    var theLineNeedToMove: Int?
    
    //捕获menu controller
    let menu = UIMenuController.sharedMenuController()
    let colorMenu = UIMenuController.sharedMenuController()
    
    //记录可能会draw的Line
//    var currentLine: Line?
    //字典，实现多指触控
    var currentLines = [NSValue: Line]()
    
    
    //圆
    var currentCircle: Circle?
    
    //Lines的数组用来记录已经被画下的Line
    var finishedLines = [Line]()
    var finishedLinesLineWidth = [CGFloat]()
    
    var selectedLineIndex: Int? {
        didSet {
            if selectedLineIndex == nil {
                let menu = UIMenuController.sharedMenuController()
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    
    var moveRecognizer: UIPanGestureRecognizer!
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.blackColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.redColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
//    @IBInspectable var lineThickness: CGFloat = 10 {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
    
    func strokeLine(line: Line) {
        
        let path = UIBezierPath()
        

//        path.lineWidth = lineThickness
        
        
        path.lineCapStyle = CGLineCap.Round
        
        path.moveToPoint(line.begin)
        path.addLineToPoint(line.end)
        
        let velocity = log(abs(moveRecognizer.velocityInView(self).x) + abs(moveRecognizer.velocityInView(self).y))
        
        if tempLineWidth <= velocity {
            path.lineWidth = velocity
            tempLineWidth = velocity
        } else {
            path.lineWidth = tempLineWidth
        }

        
//        print("path.lineWidth is \(path.lineWidth)")
        
        path.stroke()
        
    }
    
    
    //画圆
    func strokeCircle(circle: Circle) {
        let ovalPath = UIBezierPath(arcCenter: circle.orignalPoint, radius: circle.radius, startAngle: CGFloat(0), endAngle: CGFloat(2 * M_PI), clockwise: true)
        
        ovalPath.lineWidth = 10
        
        ovalPath.stroke()
        
    }
    
    override func drawRect(rect: CGRect) {
        //画出黑色的finished lines
//        UIColor.blackColor().setStroke()
        
        finishedLineColor.setStroke()
        
        for i in 0..<finishedLines.count {
//            strokeFinishedLine(line)
            let path = UIBezierPath()
            
            
            //        path.lineWidth = lineThickness
            
            
            path.lineCapStyle = CGLineCap.Round
            
            path.moveToPoint(finishedLines[i].begin)
            path.addLineToPoint(finishedLines[i].end)
            
            path.lineWidth = finishedLinesLineWidth[i]
            
            
            path.stroke()
        }
        
//        if let line = currentLine {
//            //是否正在画line， 是则显示红色
//            UIColor.redColor().setStroke()
//            strokeLine(line)
//        }
        
//        UIColor.redColor().setStroke()
        
        
//        currentLineColor.setStroke()
        
        for (_, line) in currentLines {
            
            currentLineColor.setStroke()
            

            
            strokeLine(line)
        }
        
        if let circle = currentCircle {
            UIColor.purpleColor().setStroke()
            strokeCircle(circle)
        }
        
        print("draw")
        
        if let index = selectedLineIndex {
            UIColor.greenColor().setStroke()
            let selectedLine = finishedLines[index]
            let path = UIBezierPath()
            path.lineCapStyle = CGLineCap.Round
            
            path.moveToPoint(selectedLine.begin)
            path.addLineToPoint(selectedLine.end)
            
            
            path.lineWidth = finishedLinesLineWidth[index]

            path.stroke()
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let touch = touches.first!
//        
//        //在视图的坐标系中获取touch的坐标
//        let location = touch.locationInView(self)
//        
//        currentLine = Line(begin: location, end: location)
        
        print(__FUNCTION__)
        
        selectedLineIndex = nil
        
        
        for touch in touches {
            let location = touch.locationInView(self)
                
            let newLine = Line(begin: location, end: location)
                
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
            
                
        }
        
        if touches.count == 2 {
            for touch in touches {
                let location = touch.locationInView(self)
                
                let circle = Circle(radius: 0.0, orignalPoint: location)
                currentCircle = circle
                
            }
        }
        
        
        
        //视图在run loop结束时，重绘
        setNeedsDisplay()
    }
    
    //用来更新currentLine的end
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let touch = touches.first!
//        let location = touch.locationInView(self)
//        
//        currentLine?.end = location
        
        print(__FUNCTION__)
        
        menu.setMenuVisible(false, animated: true)

        
        
        
        
        
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
                
            currentLines[key]?.end = touch.locationInView(self)
                
            let angle = pointPairToBearingDegree(currentLines[key]!.begin, endPoint: currentLines[key]!.end)
                
                
            switch angle {
            case 0..<90:
                currentLineColor = UIColor.redColor()
            case 90..<180:
                currentLineColor = UIColor.greenColor()
            case 180..<270:
                currentLineColor = UIColor.blueColor()
            case 270...360:
                currentLineColor = UIColor.yellowColor()
            default:
                break
            }
                
        }
        
        if touches.count == 2 {
            var circlePointArray = [CGPoint]()
            for touch in touches {
                circlePointArray.append(touch.locationInView(self))
            }
            
            currentCircle?.orignalPoint = CGPointMake((circlePointArray[0].x + circlePointArray[1].x) / 2, (circlePointArray[0].y + circlePointArray[1].y) / 2)
            
            
            let xLine = circlePointArray[0].x - circlePointArray[1].x
            let yLine = circlePointArray[0].y - circlePointArray[1].y
            currentCircle?.radius = hypot(xLine, yLine) / 2
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if var line = currentLine {
//            let touch = touches.first!
//            let location = touch.locationInView(self)
//            line.end = location
//            
//            finishedLines.append(line)
//        }
//        currentLine = nil
        
        print(__FUNCTION__)
        
        
            for touch in touches {
                let key = NSValue(nonretainedObject: touch)
                if var line = currentLines[key] {
                    line.end = touch.locationInView(self)
                    
                    
                    
                    finishedLines.append(line)
                    finishedLinesLineWidth.append(tempLineWidth)
                    tempLineWidth = 0.00001
                    currentLines.removeValueForKey(key)
                    currentCircle = nil
                }
            }
        
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        print(__FUNCTION__)
        
        currentLines.removeAll()
        setNeedsDisplay()
    }
    
    //获得两个CGPoint的夹角
    func pointPairToBearingDegree(startPoint: CGPoint, endPoint: CGPoint) -> CGFloat {
        let originPoint = CGPointMake(endPoint.x - startPoint.x, endPoint.y - startPoint.y)
        let bearingRadians = atan2(originPoint.y, originPoint.x)
        var bearingDegrees = bearingRadians * CGFloat((180.0 / M_PI))
        bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees))
        return bearingDegrees
    }
    
    //MARK: 手势
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        
        //延迟触发
        doubleTapRecognizer.delaysTouchesBegan = true
        
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
        tapRecognizer.delaysTouchesBegan = true
        //双击失败，才会触发单击
        tapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        longPressRecognizer.minimumPressDuration = 1.0
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self, action: "moveLine:")
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(moveRecognizer)
        
        let threeFingersSwipe = UISwipeGestureRecognizer(target: self, action: "threeFingers:")
        threeFingersSwipe.numberOfTouchesRequired = 3
        threeFingersSwipe.delaysTouchesBegan = true
        threeFingersSwipe.direction = .Up
        addGestureRecognizer(threeFingersSwipe)

    }
    
    func doubleTap (gestureRecognizer: UIGestureRecognizer) {
        print("Recognizer a double tap")
        
        selectedLineIndex = nil
        
        currentLines.removeAll(keepCapacity: false)
        finishedLines.removeAll(keepCapacity: false)
        setNeedsDisplay()
        
    }
    
    func tap(gestureRecognizer: UITapGestureRecognizer) {
        print("Recoginzer a tap\n\(selectedLineIndex)")
        
        let point = gestureRecognizer.locationInView(self)
        selectedLineIndex = indexOfLineAtPoint(point)
        
        
        if selectedLineIndex != nil {
            
            //使DrawView成为menu item action message的目标
            becomeFirstResponder()
            
            //创建一个Delete UIMenuItem
            let deleteItem = UIMenuItem(title: "Delete", action: "deleteLine:")
            menu.menuItems = [deleteItem]
            
            //展示这个menuItem
            menu.setTargetRect(CGRect(x: point.x, y: point.y, width: 2, height: 2), inView: self)
            menu.setMenuVisible(true, animated: true)
            
        } else {
            //若没有line被选中，则隐藏
            menu.setMenuVisible(false, animated: true)
        }
        
        
        
        setNeedsDisplay()
    }
    
    func indexOfLineAtPoint(point: CGPoint) -> Int? {
        //找到一根靠近point的line
        for (index, line) in finishedLines.enumerate() {
            let begin = line.begin
            let end = line.end
            
            //检查少量在line上的点
            for t in CGFloat(0).stride(to: 1.0, by: 0.05) {
                let x = begin.x + (end.x - begin.x) * t
                let y = begin.y + (end.y - begin.y) * t
                
                //如果点击的点和枚举的点的所构成的斜边小于20
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        return nil
    }
    
    //删除line
    func deleteLine(sender: AnyObject?) {
        if let index = selectedLineIndex {
            finishedLines.removeAtIndex(index)
            finishedLinesLineWidth.removeAtIndex(index)
            selectedLineIndex = nil
            
            //Redraw everything
            setNeedsDisplay()
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func longPress(gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a long press")
        
        menu.setMenuVisible(false, animated: true)
//        colorMenu.setMenuVisible(false, animated: true)
        
        if gestureRecognizer.state == .Began {
            let point = gestureRecognizer.locationInView(self)
            selectedLineIndex = indexOfLineAtPoint(point)
            
            if selectedLineIndex != nil {
                currentLines.removeAll(keepCapacity: false)
            }
            
            theLineNeedToMove = selectedLineIndex
            
        } else if gestureRecognizer.state == .Ended {
            selectedLineIndex = nil
            theLineNeedToMove = nil
        }
        
        setNeedsDisplay()
    }
    
    func moveLine(gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognizer a pan")
        
        
        //line 被选中
        if let index = theLineNeedToMove {
            
            
            
            //当 pan recognizer 改变了位置
            if gestureRecognizer.state == .Changed {
                
                
                
                //移动了多少？
                let translation = gestureRecognizer.translationInView(self)
                
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, inView: self)
                
                
                
                setNeedsDisplay()
            }
        } else {
            // If no line is selected, do not do anything
            return
        }
        
        
    }
    
    func threeFingers(gestureRecognizer: UISwipeGestureRecognizer) {
        print("three fingers")
        
        becomeFirstResponder()

        let redMenu = UIMenuItem(title: "Red", action: "redLine:")
        let blueMenu = UIMenuItem(title: "Blue", action: "blueLine:")
        let greenMenu = UIMenuItem(title: "Green", action: "greenLine:")
        colorMenu.menuItems = [redMenu, blueMenu, greenMenu]
        
        //展示这个menuItem
        let bounds = CGPoint.init(x: self.bounds.width / 2, y: self.bounds.height / 2)
        colorMenu.setTargetRect(CGRect(x: bounds.x, y: bounds.y, width: 2, height: 2), inView: self)
        colorMenu.arrowDirection = .Down
        colorMenu.setMenuVisible(true, animated: true)
        
        setNeedsDisplay()
    }
    
    
    func redLine(sender: AnyObject?) {
        finishedLineColor = UIColor.redColor()
        print("red")
        
    }
    
    func blueLine(sender: AnyObject?) {
        finishedLineColor = UIColor.blueColor()
        
    }
    
    func greenLine(sender: AnyObject?) {
        finishedLineColor = UIColor.greenColor()
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
