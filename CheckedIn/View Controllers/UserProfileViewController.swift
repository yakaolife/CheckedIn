//
//  UserProfileViewController.swift
//  CheckedIn
//
//  Created by Ya Kao on 10/24/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//


import UIKit

class UserProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        tableView.registerNib(UINib(nibName: "TableHeader", bundle: nil), forCellReuseIdentifier: "Header")
        tableView.registerNib(UINib(nibName: "SectionTableViewCell", bundle: nil), forCellReuseIdentifier: "Section")

        self.title = "Home"
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //temp
        if(section == 0){
            return 1 //Header
        }else{
            return 10
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        var header = tableView.dequeueReusableCellWithIdentifier("Section") as SectionTableViewCell
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: header.contentView.frame.width, height: header.contentView.frame.height))
        
        
        headerView.addSubview(header)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
                return 0
        }else{
            return 44
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if(indexPath.row == 0 && indexPath.section == 0){
            //load the profile view instead
            println("Loading header")
            cell = tableView.dequeueReusableCellWithIdentifier("Header") as HeaderTableViewCell
        }else{
            cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as EventTableViewCell
        }
        
        return cell
    }
    
    //Swipe cell functions
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var RSVPAction = UITableViewRowAction(style: .Normal, title: "RSVP") { (action, indexPath) -> Void in
            self.tableView.editing = false
            println("RSVP")
        }
        RSVPAction.backgroundColor = UIColor(red: 63/255, green: 195/255, blue: 168/255, alpha: 1)
        
        var cancelAction = UITableViewRowAction(style: .Normal, title: "Cancel") { (action, indexPath) -> Void in
            self.tableView.editing = false
            println("Cacnel")
        }
        cancelAction.backgroundColor = UIColor(red: 255/255, green: 193/255, blue: 126/255, alpha: 1)
        
        return [RSVPAction, cancelAction]
        
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        
    }


}
