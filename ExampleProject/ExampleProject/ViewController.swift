//
//  ViewController.swift
//  ExampleProject
//
//  Created by Nhon Nguyen Van on 5/21/15.
//  Copyright (c) 2015 Nhon Nguyen Van. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,BHInputToolbarDelegate {

    @IBOutlet var scrollView: UIView!
    @IBOutlet weak var tblComment: UITableView!
    var toolbar: UIToolbar?
    var inputToolbar : BHInputToolbar?
    var tableData = [String]()
    let kStatusBarHeight: CGFloat = 20
    let kDefaultToolbarHeight: CGFloat = 44
    let kKeyboardHeightPortrait: CGFloat = 216
    let kKeyboardHeightLandscape: CGFloat = 140
    var keyboardIsVisible :Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.scrollView.bounces = true
        self.tblComment.separatorColor = UIColor.clearColor()
        
        var label = UILabel()
        label.text = "Answer Pending...."
        label.textAlignment = NSTextAlignment.Center
        label.sizeToFit()
        self.tblComment.tableFooterView = label
        // Do any additional setup after loading the view, typically from a nib.
        
        var screenFrame = UIScreen.mainScreen().bounds
        self.inputToolbar = BHInputToolbar(frame: CGRectMake(0, screenFrame.size.height-kDefaultToolbarHeight, screenFrame.size.width, kDefaultToolbarHeight))
        self.scrollView.addSubview(self.inputToolbar!)
        
        self.inputToolbar?.inputDelegate = self;
        self.inputToolbar?.textView.placeholder = "Comment";
        self.inputToolbar?.textView.maximumNumberOfLines = 4
        createToolbar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    func createToolbar(){
        self.toolbar = UIToolbar(frame: CGRectMake(0, (self.inputToolbar?.frame.origin.y)! - kDefaultToolbarHeight, self.view!.frame.size.width, kDefaultToolbarHeight))

        /* Right align the toolbar button */
        var cameraItem : UIBarButtonItem = UIBarButtonItem(title: "Camera", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        var fileAttachItem : UIBarButtonItem = UIBarButtonItem(title: "File Attach", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        var finalAnswerItem : UIBarButtonItem = UIBarButtonItem(title: "Final Answer", style: UIBarButtonItemStyle.Plain, target: nil, action: "btnFinalAnswerClicked:")
        var flexItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        var items : NSArray = [cameraItem,flexItem,fileAttachItem,flexItem,finalAnswerItem]
        self.toolbar?.setItems(items, animated: false)
        self.scrollView.addSubview(self.toolbar!)
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
        let commentCell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as CommentCell
        
        for subview in commentCell.subviews {
            subview.removeFromSuperview()
        }

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
        
        commentCell.addSubview(view)

        return commentCell
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        var screenFrame = UIScreen.mainScreen().bounds
        var r = self.inputToolbar?.frame as CGRect!
        var frameHeight : CGFloat = self.inputToolbar?.frame.size.height as CGFloat!
        if UIInterfaceOrientationIsPortrait(toInterfaceOrientation){
            
            r.origin.y = screenFrame.size.height - frameHeight - kStatusBarHeight
            if (keyboardIsVisible) {
                r.origin.y -= kKeyboardHeightPortrait;
            }
            self.inputToolbar?.textView.maximumNumberOfLines = 4
        }else{
             r.origin.y = screenFrame.size.width - frameHeight - kStatusBarHeight
            if (keyboardIsVisible) {
                r.origin.y -= kKeyboardHeightLandscape;
            }
            self.inputToolbar?.textView.maximumNumberOfLines = 7
            self.inputToolbar?.textView.sizeToFit()
        }
        self.inputToolbar?.frame = r
    }
    
    func inputButtonPressed(inputText: String!, fakeClick isFaked: Bool) {
        if isFaked{
            self.tableData.insert(inputText, atIndex: 0)
        }else{
            self.tableData.append(inputText)
        }
        self.tblComment.reloadData()
    }

    func btnFinalAnswerClicked(sender: AnyObject) {
        self.inputToolbar?.fakeClick()
    }
    
    func keyboardWillShow(notification:NSNotification){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        var frame : CGRect = self.inputToolbar?.frame as CGRect!
        if UIInterfaceOrientationIsPortrait(self.interfaceOrientation){
            frame.origin.y = self.view.frame.size.height - frame.size.height - kKeyboardHeightPortrait
        }else{
            frame.origin.y = self.view.frame.size.width - frame.size.height - kKeyboardHeightLandscape - kStatusBarHeight
        }
        self.inputToolbar?.frame = frame;
        var toolbarFrame = self.toolbar?.frame as CGRect!
        toolbarFrame.origin.y = frame.origin.y - kDefaultToolbarHeight;
        self.toolbar?.frame = toolbarFrame
        UIView.commitAnimations();
        keyboardIsVisible = true;
    }
    
    func keyboardWillHide(notification:NSNotification){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        var frame : CGRect = self.inputToolbar?.frame as CGRect!
        if UIInterfaceOrientationIsPortrait(self.interfaceOrientation){
            frame.origin.y = self.view.frame.size.height - frame.size.height
        }else{
            frame.origin.y = self.view.frame.size.width - frame.size.height
        }
        self.inputToolbar?.frame = frame;
        var toolbarFrame = self.toolbar?.frame as CGRect!
        toolbarFrame.origin.y = frame.origin.y - kDefaultToolbarHeight;
        self.toolbar?.frame = toolbarFrame
        UIView.commitAnimations();
        keyboardIsVisible = false;
    }
    
    override func viewWillAppear(animated: Bool) {
         NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        /* No longer listen for keyboard */
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)

    }


}

