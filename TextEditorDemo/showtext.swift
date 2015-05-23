//
//  showtext.swift
//  MyTest
//
//  Created by lifubing on 15/5/21.
//  Copyright (c) 2015年 lifubing. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func noticeText(text:String,fontsize:CGFloat,obliqueness:NSNumber){
        Notice.showText(text, fontsize: fontsize ,obliqueness: obliqueness)
    }
    func noticeText(text:String,fontsize:CGFloat){
    }
}

class Notice:NSObject {
    static var windows = Array<UIWindow!>()
    static let rv = UIApplication.sharedApplication().keyWindow?.subviews.first as! UIView
    static func clear() {
        windows.removeAll(keepCapacity: false)
    }
    
    static func showText(text: String,fontsize:CGFloat,obliqueness:NSNumber) {
        let frame = CGRectMake(0, 0, 200, 60)
        let window = UIWindow(frame: frame)
        let mainView = UIView(frame: frame)
        mainView.layer.cornerRadius = 12//设置圆角
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        let label = UILabel(frame: frame)
        label.text = text
        if obliqueness == 0{
            label.font = UIFont.systemFontOfSize(fontsize)
        }else if (obliqueness == 1) {
            label.font = UIFont(name: NSObliquenessAttributeName, size: fontsize)
            
        }else if (obliqueness == 2) {
            label.font = UIFont.boldSystemFontOfSize(fontsize)
        }
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        mainView.addSubview(label)
        
        window.windowLevel = UIWindowLevelAlert
        window.center = rv.center
        window.frame = CGRectMake(rv.center.x - frame.size.width/2, rv.center.y/3, frame.size.width, frame.size.height)
        window.hidden = false
        window.addSubview(mainView)
        windows.append(window)
        
       
        let selector = Selector("hideNotice:")
        self.performSelector(selector, withObject: mainView, afterDelay: 1)
    }
    static func hideNotice(sender: AnyObject) {
//        if sender is UIView {
//            sender.removeFromSuperview()
//            (sender as! UIView). = false
//        }
        sender.removeFromSuperview()
        windows.removeAll(keepCapacity: false)//将生成的windows也同时删除，否则会影响到下一层view的操作
        
    }

}