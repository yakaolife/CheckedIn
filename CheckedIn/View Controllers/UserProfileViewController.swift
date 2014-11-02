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
    var allMyEvents:NSArray?
    var selectedIndex = 0
    var selectedEventObjectId:String!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: UI related
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        tableView.registerNib(UINib(nibName: "TableHeader", bundle: nil), forCellReuseIdentifier: "Header")
        
        self.title = "Home"
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchRsvpedEvents(nil)
        
    }
    func refresh( refreshControl : UIRefreshControl)
    {
        refreshControl.beginRefreshing()
        switch self.selectedIndex {
        case 0:
            showMyEvents()
        case 1:
            showAllEvents()
        case 2:
            showCheckedInEvents()
        default:
            println("default")
        }
        refreshControl.endRefreshing()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.allMyEvents = nil
        self.events = nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectedEvents (sender:UISegmentedControl) {
        self.events = nil
        switch sender.selectedSegmentIndex {
        case 0 :
            self.selectedIndex = 0
            showMyEvents()
        case 1:
            self.selectedIndex = 1
            showAllEvents()
        case 2 :
            self.selectedIndex = 2
            showCheckedInEvents()
        default:
            println ("default")
        }
    }
    
    //MARK: tableview Data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //temp
        if(section == 0){
            return 1 //Header
        }else{
            println("tableview count is \(events?.count ?? 0)")
            return events?.count ?? 0
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    //MARK: tableview delegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var itemArray = ["RSVP events", "All events" , "CheckedIn events"]
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 35))
        var control = UISegmentedControl(items: itemArray)
        control.frame = headerView.frame
        control.selectedSegmentIndex = self.selectedIndex
        control.enabled = true
        control.addTarget(self, action: "selectedEvents:", forControlEvents: UIControlEvents.ValueChanged)
        headerView.addSubview(control)
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
        // var cell = UITableViewCell()
        if(indexPath.row == 0 && indexPath.section == 0){
            //load the profile view instead
            //println("Loading header ..  ")
            var cell = tableView.dequeueReusableCellWithIdentifier("Header") as HeaderTableViewCell
            cell.usernameLabel.text = ParseUser.currentUser().username
            cell.displaynameLabel.text = ParseUser.currentUser().screenName
            cell.locationLabel.text = ParseUser.currentUser().zipcode
            
            cell.profileImage.image = nil
            let user  = PFUser.currentUser() as ParseUser
            let img = user.userImage
            
            img?.getDataInBackgroundWithBlock({ (imageData: NSData!, error:NSError!) -> Void in
                if imageData != nil {
                    cell.profileImage.image = UIImage(data: imageData)
                }
            })
            
            
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as EventTableViewCell
            var event = events?[indexPath.row] as ParseEvent
            cell.eventTitleLabel.text = event.EventName!
            cell.locationLabel.text = "\(event.cityName!), \(event.state!)"
            cell.timeLabel.text = "\(event.eventDate!)"
            if isAlreadyRSVPed(event.objectId!) {
                cell.rsvpMarkImage.hidden = false
                //cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.rsvpMarkImage.hidden = true
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            cell.profileImage.image = nil
            let eventImage = event.eventProfileImage
            eventImage?.getDataInBackgroundWithBlock({ (imageData: NSData!, error: NSError!) -> Void in
                if imageData != nil  {
                    cell.profileImage.image = UIImage(data: imageData)
                }
            })
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let event = events?[indexPath.row] as ParseEvent
        var eventNameAndRsvped = [ "objectId": event.objectId, "isRsvped" :true ]
        
        self.performSegueWithIdentifier("ShowDetailSegue", sender: eventNameAndRsvped)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "ShowDetailSegue"){
            println("Going to Event Detail Page")
            
            if segue.destinationViewController.isKindOfClass(EventDetailViewController){
                let vc = segue.destinationViewController as EventDetailViewController
                vc.eventNameAndRsvped = sender as NSDictionary?
                
            }
        } else if segue.identifier == "toMapView" {
            
        }
    }
    
    //Swipe cell functions
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        if self.selectedIndex == 2 {
            return nil
        }
        let event =  events?[indexPath.row] as ParseEvent
        if isAlreadyRSVPed(event.objectId) {

            var cancelAction = UITableViewRowAction(style: .Normal, title: "Cancel RSVP") { (action, indexPath) -> Void in
                self.tableView.editing = false
                let event = self.events?[indexPath.row] as  ParseEvent
                self.events = nil
                self.allMyEvents = nil
                self.unRsvpEvent(event.objectId)
                println("Cacnel")
            }
            cancelAction.backgroundColor = UIColor(red: 255/255, green: 193/255, blue: 126/255, alpha: 1)
            return [cancelAction]
        } else {
            var RSVPAction = UITableViewRowAction(style: .Normal, title: "RSVP") { (action, indexPath) -> Void in
                self.tableView.editing = false
                println("RSVP")
                let event = self.events?[indexPath.row] as  ParseEvent
                self.events = nil
                self.allMyEvents = nil
                self.rsvpEvent(event.objectId)
            }
            RSVPAction.backgroundColor = UIColor(red: 63/255, green: 195/255, blue: 168/255, alpha: 1)

            return [RSVPAction]
        }
    }
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        
    }
    
    //MARK: methods
    
    func showMyEvents () {
        self.allMyEvents = nil
        fetchRsvpedEvents(nil)
    }
    func showAllEvents () {
        self.events = nil
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
    
    func fetchRsvpedEvents(isRsvped:Bool?){
        var user = PFUser.currentUser()
        var relation = user.relationForKey("rsvped")
        relation.query().findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                println("error retrieving rsvped events")
            } else {
                if isRsvped == nil {
                    self.events = objects
                    self.allMyEvents = objects
                    self.tableView.reloadData()
                } else {
                    //fetch after rsvp action
                    self.allMyEvents = objects
                    self.fetchAllEvents()
                }
            }
        }
    }
    
    func fetchAllEvents(){
        var query = ParseEvent.query() as PFQuery
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if objects != nil {
                self.events = objects
                self.tableView.reloadData()
            } else {
                println("fetch all events error \(error)")
            }
        }
    }
    
    func unRsvpEvent(selectedEventObjectId:String) {
        var user = PFUser.currentUser()
        var relation = user.relationForKey("rsvped")
        var events = ParseEvent.query() as PFQuery
        events.getObjectInBackgroundWithId(selectedEventObjectId ) { (object: PFObject!, error: NSError!) -> Void in
            if object != nil {
                relation.removeObject(object)
                user.saveInBackgroundWithBlock({ (succeed: Bool, error:NSError!) -> Void in
                    if succeed {
                        if self.selectedIndex == 0 {
                            self.fetchRsvpedEvents(nil )
                        } else {
                            self.fetchRsvpedEvents(true )
                        }
                    } else  {
                        println("rsvped error \(error)")
                    }
                })
            } else {
                println("rsvp event error \(error)")
            }
        }
    }
    func rsvpEvent(selectedEventObjectId:String){
        var user = PFUser.currentUser()
        var relation = user.relationForKey("rsvped")
        var events = ParseEvent.query() as PFQuery
        events.getObjectInBackgroundWithId(selectedEventObjectId ) { (object: PFObject!, error: NSError!) -> Void in
            if object != nil {
                relation.addObject(object)
                user.saveInBackgroundWithBlock({ (succeed: Bool, error:NSError!) -> Void in
                    if succeed {
                        self.fetchRsvpedEvents(true )
                    } else  {
                        println("rsvped error \(error)")
                    }
                })
            } else {
                println("rsvp event error \(error)")
            }
        }
    }
    
    func isAlreadyRSVPed(objectId :String) -> Bool {
        var state = false
        var each : ParseEvent?
        if self.allMyEvents != nil {
            for each   in self.allMyEvents! {
                if each.objectId == objectId {
                    state = true
                }
            }
        }
        return state
    }
}
