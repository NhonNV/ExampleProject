//
//  ViewController.swift
//  ExampleProject
//
//  Created by Nhon Nguyen Van on 5/21/15.
//  Copyright (c) 2015 Nhon Nguyen Van. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var tblComment: UITableView!
    @IBOutlet weak var txtComment: UITextField!
    var tableData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.bounces = true
        self.tblComment.separatorColor = UIColor.clearColor()
        
        var label = UILabel()
        label.text = "Answer Pending...."
        label.textAlignment = NSTextAlignment.Center
        label.sizeToFit()
        self.tblComment.tableFooterView = label
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        let font = UIFont(name: "Helvetica", size: 18.0)
        var height = heightForView(self.tableData[indexPath.row], font: font!, width: 278)
        println("\(height)")
        return height+20
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let commentCell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as? CommentCell
        let font = UIFont(name: "Helvetica", size: 18.0)
        var height = heightForView(self.tableData[indexPath.row], font: font!, width: 278)
        var label = UILabel(frame: CGRectMake(5, 5, 278, height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.textAlignment = NSTextAlignment.Left
        label.text = self.tableData[indexPath.row]
        
        var view = UIView(frame: CGRectMake(0, 5, 288, height+10))
        view.addSubview(label)
        view.clipsToBounds = true
        
        view.layer.borderWidth = 1;
        view.layer.borderColor = UIColor.grayColor().CGColor
        
        commentCell?.addSubview(view)

        return commentCell!
    }

    
    @IBAction func btnPostClicked(sender: AnyObject) {
        self.tableData.append(self.txtComment.text!)
        self.txtComment.text = ""
        self.tblComment.reloadData()
    }

    @IBAction func btnFinalAnswerClicked(sender: AnyObject) {
    }
}

