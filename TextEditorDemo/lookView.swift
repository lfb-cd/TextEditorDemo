//
//  lookView.swift
//  MyCoreData
//
//  Created by lifubing on 15/5/3.
//  Copyright (c) 2015年 lifubing. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices
import AssetsLibrary

class lookView: UIViewController,UIImagePickerControllerDelegate,UITextViewDelegate,UIToolbarDelegate,UIActionSheetDelegate,UINavigationControllerDelegate{
    var Data:NSManagedObject!                                       //接收传入数据
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext//获取入口类的context

    var isThereHavedata = false                                     //判断是否有新数据
    var toSave:Bool = false                                         //用于退出时删除数据
    var fontSize: CGFloat  = 24.0

    @IBOutlet weak var Toolbar: UIToolbar!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var toRight: NSLayoutConstraint!
    @IBOutlet weak var toolBarLayOut: NSLayoutConstraint!
    @IBOutlet weak var textViewBottomLayoutGuideConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.hidesBarsOnTap = false           //设置点击隐藏导航栏，false为取消
        self.navigationController?.hidesBarsOnSwipe = true          //设置滑动隐藏导航栏
        setup()
        //self.tabBarController?.hidesBottomBarWhenPushed = true //设置压入时是否隐藏导航栏
    }
    
    func setup(){
        /*
        使用UITextView的时候经常出现光标不在最下方的情况。。。(iOS8)
        解决方法：
            1、首先去除所有的Padding：
                self.text.textContainerInset = UIEdgeInsetsZero
                self.text.textContainer.lineFragmentPadding = 0
        
            2、然后在委托方法里加上一行：
                func textViewDidChange(textView: UITextView) {
                self.text.scrollRangeToVisible(self.text.selectedRange)
            }
            ps:委托方法在最下边。
        */
        self.text.textContainerInset = UIEdgeInsetsZero
        self.text.textContainer.lineFragmentPadding = 0
        
        self.text.layoutManager.allowsNonContiguousLayout = false   //用于解决改变文字属性，TextView自动滑到顶部问题
        self.Toolbar.clipsToBounds = true
        if isThereHavedata {
            text.text = Data.valueForKey("string") as! String
            text.textColor = UIColor.blackColor()
        }else {
            text.text = "Typing you want!"
            text.textColor = UIColor.lightGrayColor()
        }
        
        if Data.valueForKey("theAttributedText") != nil  {
            let size = Data.valueForKey("theAttributedText") as! NSAttributedString
            text.attributedText = size
        }
        self.text.editable = true
    }

    /*
    //移动Toolbar到右边
    */
    @IBAction func toright(sender: UIBarButtonItem) {
        if self.toRight.constant < 0{                               //简单判断左移还是右移
            self.Toolbar.layer.cornerRadius = 22                    //改成圆角
            self.toRight.constant += (text.bounds.width - 10)
            sender.image = UIImage(named: "fa-left")                //改变图片
        }else {
            self.Toolbar.layer.cornerRadius = 0                     //恢复原来不是圆角那样
            self.toRight.constant -= (text.bounds.width - 10)
            sender.image = UIImage(named: "fa-right")
        }
    }
    /*
    //减小字体
    */
    @IBAction func down(sender: AnyObject) {
        if fontSize > 16 {
            self.fontSize = text.font.pointSize
            self.fontSize -= 2
            self.text.typingAttributes[NSFontAttributeName] = UIFont.systemFontOfSize((CGFloat)(self.fontSize))
        }
        Notice.showText("减小字体", fontsize: fontSize,obliqueness: 0)//弹出提示

    }
    
    /*
    //增大字体
    */
    @IBAction func up(sender: AnyObject) {
        
        if fontSize < 40 {
            self.fontSize = text.font.pointSize
            fontSize += 4
            self.text.typingAttributes[NSFontAttributeName] = UIFont.systemFontOfSize((CGFloat)(self.fontSize))
            
        }
        Notice.showText("增大字体", fontsize: fontSize,obliqueness: 0)//弹出提示
    }
    /*
    //隐藏键盘
    */
    @IBAction func keybordDown(sender: UIBarButtonItem) {
        self.text.resignFirstResponder()
    }
    
    /*
    //下划线
    */
    @IBAction func underLine(sender: UIBarButtonItem) {
        let changedFontDescriptor = UIFont(name:NSUnderlineStyleAttributeName, size: fontSize)
        let typ = text.typingAttributes[NSUnderlineStyleAttributeName] as? NSNumber
        if (typ == 1) {
            self.text.typingAttributes[NSUnderlineStyleAttributeName] = 0
            Notice.showText("取消下划线", fontsize: fontSize, obliqueness: 0)//弹出提示
        }else {
            self.text.typingAttributes[NSUnderlineStyleAttributeName] = 1
            Notice.showText("下划线", fontsize: fontSize, obliqueness: 0)//弹出提示
            
        }
        
    }
    /*
    //粗体字
    */
    @IBAction func bold(sender: UIBarButtonItem) {
        let changedFontDescriptor = UIFont.systemFontOfSize((CGFloat)(self.fontSize))
        let typ = text.typingAttributes[NSFontAttributeName] as? UIFont
        if ( typ == changedFontDescriptor) {
            self.text.typingAttributes[NSFontAttributeName] = UIFont.boldSystemFontOfSize((CGFloat)(self.fontSize))
            Notice.showText("粗体", fontsize: fontSize, obliqueness: 2)
        }else {
            self.text.typingAttributes[NSFontAttributeName] = UIFont.systemFontOfSize((CGFloat)(self.fontSize))
            Notice.showText("取消粗体", fontsize: fontSize, obliqueness: 2)

        }

    }
    /*
    //斜体字
    */
    @IBAction func Obliqueness(sender: UIBarButtonItem) {
        var typ = text.typingAttributes[NSObliquenessAttributeName] as? NSNumber
        if typ == 0.5 {
//            text.typingAttributes[NSObliquenessAttributeName] = (text.typingAttributes[NSObliquenessAttributeName] as? NSNumber) == 0.5 ? 0 : 0.5
            text.typingAttributes[NSObliquenessAttributeName] = 0
            Notice.showText("取消斜体", fontsize: fontSize, obliqueness: 1)
        }else {
            text.typingAttributes[NSObliquenessAttributeName] = 0.5
            Notice.showText("斜体", fontsize: fontSize, obliqueness: 0)
        }

    }

    @IBAction func save(sender: AnyObject) {
        toSave = true                                                   //默认是要删除数据的，用这个判断是否保存数据
        Data.setValue(text.text, forKey: "string")
        Data.setValue(text.attributedText, forKey: "theAttributedText")
        context?.save(nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    //选取照片
    */
    @IBAction func photeSelect(sender: AnyObject) {
        self.text.resignFirstResponder()
        var sheet:UIActionSheet
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            sheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil,otherButtonTitles: "从相册选择", "拍照")
        }else{
            sheet = UIActionSheet(title:nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "从相册选择")
        }
        sheet.showInView(self.view)
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        var sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if(buttonIndex != 0){
            if(buttonIndex==1){                                     //相册
                sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.text.resignFirstResponder()
            }else{
                sourceType = UIImagePickerControllerSourceType.Camera
            }
            let imagePickerController:UIImagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true              //true为拍照、选择完进入图片编辑模式
            imagePickerController.sourceType = sourceType
            self.presentViewController(imagePickerController, animated: true, completion: {
            })
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        var string:NSMutableAttributedString = NSMutableAttributedString(attributedString: self.text.attributedText)
        var img  = info[UIImagePickerControllerEditedImage] as! UIImage
        img = self.scaleImage(img)
        var textAttachment = NSTextAttachment()
        textAttachment.image = img
        var textAttachmentString = NSAttributedString(attachment: textAttachment)

        var countString:Int = count(self.text.text) as Int
        string.insertAttributedString(textAttachmentString, atIndex: countString) //可以用这个函数实现 插入到光标所在点 ps:如果你实现了希望能共享
        text.attributedText = string
        /*
        //
        */
        //string.appendAttributedString(textAttachmentString)                    //也可以直接添加都后面
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func scaleImage(image:UIImage)->UIImage{
        UIGraphicsBeginImageContext(CGSizeMake(self.view.bounds.size.width, image.size.height*(self.view.bounds.size.width/image.size.width)))
        image.drawInRect(CGRectMake(0, 0, self.view.bounds.size.width, image.size.height*(self.view.bounds.size.width/image.size.width)))
        var scaledimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledimage
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Listen for changes to keyboard visibility so that we can adjust the text view accordingly.
        
        /*
        // 用于注册键盘通知服务
        */
    let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /*
    //退出时判断是否保存数据
    */
    
    @IBAction func cancel(sender: AnyObject) {
        if !toSave {
            context?.deleteObject(Data)
            context?.save(nil)
        }
        println("cancel")
        self.navigationController?.popViewControllerAnimated(true)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /*
    //此bool 标志是为了让键盘 出现和隐藏 成对出现，否则会出现跳出两次的情况.我也只有用这样的办法解决 = =
    // ps:如果你有更好的解决办法，希望能与我分享哦！上面有一个联系方式的
    */
    var bool:Bool = true
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        if bool {
            keyboardWillChangeFrameWithNotification(notification, showsKeyboard: true)
            println("---show")
            bool = !bool
        }
    }
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        if !bool {
            keyboardWillChangeFrameWithNotification(notification, showsKeyboard: false)
            println("---hide")
            bool = !bool

        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillChangeFrameWithNotification(notification: NSNotification, showsKeyboard: Bool) {
        println("4")
        
        let userInfo = notification.userInfo!
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        // Convert the keyboard frame from screen to view coordinates.
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        println(keyboardViewBeginFrame.origin.y)
        println(keyboardViewEndFrame.origin.y)
        var originDelta = abs((keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y))
        println("the origin:\(originDelta)")
        // The text view should be adjusted, update the constant for this constraint.
        if showsKeyboard {
            textViewBottomLayoutGuideConstraint.constant += (originDelta)
            self.toolBarLayOut.constant += originDelta
            println(self.toolBarLayOut.constant)
        }else {
            textViewBottomLayoutGuideConstraint.constant -= (originDelta)
            self.toolBarLayOut.constant -= originDelta
        }
        UIView.animateWithDuration(animationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        // Scroll to the selected text once the keyboard frame changes.
        self.text.scrollRangeToVisible(self.text.selectedRange)              //让TextView滑到光标所在地方
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    //UITextViewDelegate
    */
    
    /*
    // 实现默认提示文字效果：点击文字则会自动消失。
    */

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if !isThereHavedata {
            text.text = ""
            text.textColor = UIColor.blackColor()
            isThereHavedata = true
        }
        return true
    }
    
    /*
    // 让TextView滑到光标所在地方
    */

    func textViewDidChange(textView: UITextView) {
        self.text.scrollRangeToVisible(self.text.selectedRange)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
