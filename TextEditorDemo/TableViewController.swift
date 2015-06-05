//
//  TableViewController.swift
//  MyCoreData
//
//  Created by lifubing on 15/5/3.
//  Copyright (c) 2015年 lifubing. All rights reserved.
//
//
//  一个功能还算完整的富文本编辑器          (IPhone 5s Xcode 6.3 swift 1.2)
//
//  实现并解决了一些基本功能：
//  1.更改字体大小，粗体，下划线，斜体字。并进行了数据的存储 更多请查看网友StringX的文章：http://www.jianshu.com/p/ab5326850e74/comments/327660#comment-327660
//  2.在TextView中添加照片，以及照片存储
//  3.实现键盘隐藏和弹出
//  4.实现默认提示文字效果：点击进行编辑时提示文字自动消失
//  5.解决改变文字属性，TextView自动滑到顶部问题
//  6.让TextView滑到光标所在点
//  7.利用自动布局 实现点击按钮底部工具栏隐藏到右端 ps:没有动画效果。。。
//  8.简单封装了提示文字的功能           更多请查看网友johnlui的开源项目：https://github.com/johnlui/SwiftNotice
//  9.设置点击隐藏导航栏，设置滑动隐藏导航栏
//  10.解决UITextView经常出现光标不在最下方的情况
//
//  最后重要说明：这个Demo可能还隐藏了一些BUG:如果你解决了希望能共享，谢谢！
//              导入的两个framework是用于选取照片，以及拍照的
//  联系方式:
//      邮箱：lfb.cd@qq.com            QQ：962429707
//                                                                                   2015/6/5/20:12

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var array:[AnyObject] = []
    var string:String = ""
    var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewWillAppear(animated: Bool){
       reFlash()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func reFlash(){
        getData()
        self.tableView.reloadData()
    }
    
    func getData(){
//        var applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        var managedObjectContext = applicationDelegate.managedObjectContext
        var fetchRequest = NSFetchRequest(entityName: "Users")
        var error:NSError?
        var fetchResults = context?.executeFetchRequest(fetchRequest, error: &error)!
        if let results = fetchResults{
//            println(array)
           self.array = results
        }else{
            println(error)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return array.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = array[array.count - 1 - indexPath.row].valueForKey("string") as? String //这样使后面的数据呈现在前面
        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }


    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            println("delete")
            context?.deleteObject(array[array.count - 1 - indexPath.row] as! NSManagedObject)
            context?.save(nil)
            reFlash()
        }

    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "edit" {
            if let secondeVc = segue.destinationViewController as? lookView {
                let indexPath = self.tableView.indexPathForSelectedRow()
                let rowd = array[array.count - 1 - indexPath!.row] as! NSManagedObject
                secondeVc.Data = rowd
                secondeVc.toSave = true                                 //这两个都是做标记用的，可以先不管。
                secondeVc.isThereHavedata = true
            }
                println("edit")
        }else if (segue.identifier == "add"){
            if let secondeVc = segue.destinationViewController as? lookView {
                let indexPath = self.tableView.indexPathForSelectedRow()
                let row: AnyObject =  NSEntityDescription.insertNewObjectForEntityForName("Users", inManagedObjectContext: context!)
                row.setValue("", forKey: "string")
                context?.save(nil)
                secondeVc.Data = row as! NSManagedObject
                secondeVc.isThereHavedata = false
                println("add")
            }
        }else {
            NSLog("Error")
        }
    }
}
