# TextEditorDemo
swift：textEditorDemo一个简单的富文本编辑器
###一个简单的富文本编辑器          
(IPhone 5s Xcode 6.3 swift 1.2)

  实现并解决了一些基本功能：

 1. 更改字体大小，粗体，下划线，斜体字。并进行了数据的存储 更多请查看网友StringX的文章：http://www.jianshu.com/p/ab5326850e74/comments/327660#comment-327660 
 2. 在TextView中添加照片，以及照片存储
 3. 实现键盘隐藏和弹出
 4. 实现默认提示文字效果：点击进行编辑时提示文字自动消失
 5. 解决改变文字属性，TextView自动滑到顶部问题
 6. 让TextView滑到光标所在点
 7. 利用自动布局 实现点击按钮底部工具栏隐藏到右端 ps:没有动画效果。。
 8. 简单封装了提示文字的功能           更多请查看网友johnlui的开源项目：https://github.com/johnlui/SwiftNotice
 9.设置点击隐藏导航栏，设置滑动隐藏导航栏
 
 ####重要说明：
 这个Demo还有一些BUG:创建新的一个文本就插入图片，保存时会崩掉。给已有文本添加图片就可以正常保存。我在网上到处找了好久也不知道怎么解决，反正我觉得莫名其妙。。如果你解决了希望能共享，谢谢！O(∩_∩)O~~
              导入的两个framework是用于选取照片，以及拍照的
 联系方式:
      邮箱：lfb.cd@qq.com            QQ：962429707
      还有我的微博号:[我的微博](http://weibo.com/p/1005052009667563/home?from=page_100505&mod=TAB#place%20%E6%88%91%E7%9A%84%E5%BE%AE%E5%8D%9A)
                                                                                   by lifubing in CUIT
####项目地址
	
[github地址](https://github.com/lfb-cd/TextEditorDemo) 
如果有更新微博上会发消息的:[我的微博](http://weibo.com/p/1005052009667563/home?from=page_100505&mod=TAB#place%20%E6%88%91%E7%9A%84%E5%BE%AE%E5%8D%9A)
	                                                                              
####1.   更改字体：
```
//更改字体大小：
self.text.typingAttributes[NSFontAttributeName] = UIFont.systemFontOfSize((CGFloat)(self.fontSize))
//下划线：
self.text.typingAttributes[NSUnderlineStyleAttributeName] = 1
//粗体：
self.text.typingAttributes[NSFontAttributeName] = UIFont.boldSystemFontOfSize((CGFloat)(self.fontSize))
//斜体：
text.typingAttributes[NSObliquenessAttributeName] = 0.5
```

####2. 插入图片：
```
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
        var string:NSMutableAttributedString
        string  = NSMutableAttributedString(attributedString: self.text.attributedText)
        var img = info[UIImagePickerControllerEditedImage] as! UIImage
        img = self.scaleImage(img)
        var textAttachment= NSTextAttachment()
        textAttachment.image = img
        var textAttachmentString  = NSAttributedString(attachment: textAttachment)

            
        var countString:Int = count(self.text.text) as Int
        string.insertAttributedString(textAttachmentString, atIndex: countString) //可以用这个函数实现 插入到光标所在点 ps:如果你实现了希望能共享
        text.attributedText = string
        /*
        //
        */
        //string.appendAttributedString(textAttachmentString)
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func scaleImage(image:UIImage)->UIImage{
        UIGraphicsBeginImageContext(CGSizeMake(self.view.bounds.size.width, image.size.height*(self.view.bounds.size.width/image.size.width)))
        image.drawInRect(CGRectMake(0, 0, self.view.bounds.size.width, image.size.height*(self.view.bounds.size.width/image.size.width)))
        var scaledimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledimage
        
    }

```

####3. 实现键盘隐藏和弹出 

```
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
    
    func keyboardWillChangeFrameWithNotification(notification: NSNotification, showsKeyboard: Bool) {
        println("4")
        let userInfo = notification.userInfo!
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        // Convert the keyboard frame from screen to view coordinates.
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        var originDelta = abs((keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y))
        println("the origin:\(originDelta)")
        // The text view should be adjusted, update the constant for this constraint.
        if showsKeyboard {
            textViewBottomLayoutGuideConstraint.constant += (originDelta)
            self.toolBarLayOut.constant += originDelta
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

```

####4. 实现默认提示文字效果：点击进行编辑时提示文字自动消失
```
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
```

####5. 解决改变文字属性，TextView自动滑到顶部问题
```
	self.text.layoutManager.allowsNonContiguousLayout = false   //用于解决改变文字属性，TextView自动滑到顶部问题


####6.让TextView滑到光标所在点

 	self.text.scrollRangeToVisible(self.text.selectedRange)
####7.利用自动布局 实现点击按钮底部工具栏隐藏到右端
```
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

	 				
####8.简单封装了提示文字的功能
```
	//复制showtext.swift文件到工程
	Notice.showText("减小字体", fontsize: fontSize,obliqueness: 0)//弹出提示

```
####9.设置点击隐藏导航栏，设置滑动隐藏导航栏
```
self.navigationController?.hidesBarsOnTap = false           //设置点击隐藏导航栏，false为取消
    self.navigationController?.hidesBarsOnSwipe = true          //设置滑动隐藏导航栏
```
	
####10.解决UITextView经常出现光标不在最下方的情况
```
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
```
	
####项目地址
	
[github地址](https://github.com/lfb-cd/TextEditorDemo) 

https://github.com/lfb-cd/TextEditorDemo 
	
如果有更新微博上会发消息的:[我的微博](http://weibo.com/p/1005052009667563/home?from=page_100505&mod=TAB#place%20%E6%88%91%E7%9A%84%E5%BE%AE%E5%8D%9A)
	
	
	

####效果浏览:
![image](https://github.com/lfb-cd/TextEditorDemo/blob/master/IMG_0926.PNG) 


（gif图片大约10MB）：

![image](https://github.com/lfb-cd/TextEditorDemo/blob/master/2015-05-23%2023_45_56.gif) 
