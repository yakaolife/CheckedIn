//
//  UserProfileViewController.swift
//  CheckedIn
//
//  Created by Ya Kao on 10/24/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//


import UIKit

class UserProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    var events:NSArray?
    var selectedIndex = 0
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        fetchRsvpedEvents()
        
        tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        tableView.registerNib(UINib(nibName: "TableHeader", bundle: nil), forCellReuseIdentifier: "Header")
       // tableView.registerNib(UINib(nibName: "SectionTableViewCell", bundle: nil), forCellReuseIdentifier: "Section")
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
            return events?.count ?? 0
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

//        var header = tableView.dequeueReusableCellWithIdentifier("Section") as SectionTableViewCell
//        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: header.contentView.frame.width, height: header.contentView.frame.height))
 
//        headerView.addSubview(header)
//        
//        return headerView
        
        var itemArray = ["Rsvped events", "All events" , "CheckedIn events"]
        
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 35))
        
        var control = UISegmentedControl(items: itemArray)
        control.frame = headerView.frame
        control.selectedSegmentIndex = self.selectedIndex
        control.enabled = true
        control.addTarget(self, action: "selectedEvents:", forControlEvents: UIControlEvents.ValueChanged)
        
        headerView.addSubview(control)
        
        return headerView
        
    }
    func showMyEvents () {
        fetchRsvpedEvents()
    }
    
    func showAllEvents () {
        fetchAllEvents()
    }
    func showCheckedInEvents() {
        fetchCheckedInEvents()
        
    }
    
    func fetchCheckedInEvents(){
        var user = PFUser.currentUser()
        var relation = user.relationForKey("checkedIn")
        relation.query().findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                println("error retrieving rsvped events")
            } else {
                self.events = objects
                self.tableView.reloadData()
            }
        }
    }
    func fetchRsvpedEvents(){
        var user = PFUser.currentUser()
        var relation = user.relationForKey("rsvped")
        relation.query().findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                println("error retrieving rsvped events")
            } else {
                self.events = objects
                 self.tableView.reloadData()
            }
        }
    }
    
    func fetchAllEvents(){
        var query = ParseEvent.query() as PFQuery
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if objects != nil {
                self.events = objects
                if self.events != nil {
                    self.tableView.reloadData()
                }
            } else {
                println("fetch all events error \(error)")
            }
        }
    }
    func selectedEvents (sender:UISegmentedControl) {
        self.events = nil
        println("\n[ ]>>>>>> \(__FILE__.pathComponents.last!) >> \(__FUNCTION__) < \(__LINE__) >")
        switch sender.selectedSegmentIndex {
        case 0 :
            println("0")
            self.selectedIndex = 0
             showMyEvents()
            
        case 1:
            println ("1")
            self.selectedIndex = 1
            showAllEvents()
            
        case 2 :
            println ("2")
            self.selectedIndex = 2
            showCheckedInEvents()
            
        default:
            println ("default")
        }
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
                return 0
        }else{
            return 44
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       // var cell = UITableViewCell()
        if(indexPath.row == 0 && indexPath.section == 0){
            //load the profile view instead
            println("Loading header ..  ")
    
            var cell = tableView.dequeueReusableCellWithIdentifier("Header") as HeaderTableViewCell
            return cell
        }else{
            var cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as EventTableViewCell
            var event = events?[indexPath.row] as ParseEvent
            cell.eventTitleLabel.text = event.EventName!
            cell.locationLabel.text = "\(event.cityName!), \(event.state!)"
            cell.timeLabel.text = "\(event.eventDate!)"
            return cell
         }
        
        
//        var cell = tableView.dequeueReusableCellWithIdentifier("eventCell") as UITableViewCell
//        var event = events?[indexPath.row] as parseEvent
//        cell.textLabel.text = event.EventName
//        cell.detailTextLabel?.text = event.tagLine
//        return cell
    
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
