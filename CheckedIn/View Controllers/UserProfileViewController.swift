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
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //temp
        return 10
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = tableView.dequeueReusableCellWithIdentifier("Header") as HeaderTableViewCell
        var cellView = UIView()

        cellView.addSubview(header)
        cellView.frame.size.width = tableView.frame.size.width
        //set all the stuff for header display
        println("Getting Header!")
        return cellView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 170
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as EventTableViewCell
        
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
