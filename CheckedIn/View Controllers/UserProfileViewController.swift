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
    weak var segmentControl:UISegmentedControl?
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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 96
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        selectedIndex = 0
         fetchRsvpedEvents(nil)

 
    }
    func refresh( refreshControl : UIRefreshControl)
    {
        //TODO: somehow, now it hault after refresh pull.. comment it out for now
        refreshControl.beginRefreshing()
//        self.events = nil
//        switch self.selectedIndex {
//        case 0 :
//            self.selectedIndex = 0
//            showMyEvents()
//        case 1:
//            self.selectedIndex = 1
//            showAllEvents()
//        case 2 :
//            self.selectedIndex = 2
//            showPastEvents()
//        default:
//            println ("default")
//        }
        
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
            showPastEvents()
        default:
            println ("default")
        }
    }
    
    //MARK: tableview Data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //temp
        if(section == 0){
            println("tableview count is \(events?.count ?? 0)")

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
        var itemArray = ["RSVP events", "All events" , "Past RSVPs"]
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
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if(indexPath.section == 0){
            return false
        }else{
            return true
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
                    cell.bgImage.image = cell.profileImage.image
                    var blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
                    blur.frame = cell.bgImage.frame
                    cell.bgImage.addSubview(blur)
                    cell.backgroundView = cell.bgImage

                }
            })
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as EventTableViewCell
            var event = events?[indexPath.row] as ParseEvent
            cell.eventTitleLabel.text = event.EventName!
            cell.locationLabel.text = "\(event.cityName!), \(event.state!)"
            cell.timeLabel.text = "\(event.dateToShow!)"
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
        
        if indexPath.section == 0 {
            return
        }
        
        let event = events?[indexPath.row] as ParseEvent
        if selectedIndex == 2 {
            var  eventIdAndRsvped = [  "objectId": event.objectId  ]
 
            self.performSegueWithIdentifier("ShowDetailSegue", sender: eventIdAndRsvped)
        } else {
            var  eventIdAndRsvped = [ "objectId": event.objectId, "isRsvped" : isAlreadyRSVPed(event.objectId) ]
            self.performSegueWithIdentifier("ShowDetailSegue", sender: eventIdAndRsvped)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "ShowDetailSegue"){
            println("Going to Event Detail Page")
            
            if segue.destinationViewController.isKindOfClass(EventDetailViewController){
                let vc = segue.destinationViewController as EventDetailViewController
                vc.eventIdAndRsvped = sender as NSDictionary?
                
            }
        } else if segue.identifier == "toMapView" {
             if segue.destinationViewController.isKindOfClass(UINavigationController) {
               let nvc = segue.destinationViewController as UINavigationController
               let vc = nvc.childViewControllers[0] as MapViewViewController
                vc.allMyEvents = self.allMyEvents
            }
            
        }
    }
    
    //Swipe cell functions
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.selectedIndex == 2 {
            return false
        }
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {

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
    func showPastEvents() {
        fetchPastEvents()
        //fetchCheckedInEvents()
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
        var query = relation.query()
        query.whereKey("EventDate", greaterThanOrEqualTo: NSDate().dateByAddingTimeInterval  (-60*60*12))
        query.orderByAscending("EventDate")
            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
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
        
        query.whereKey("EventDate", greaterThanOrEqualTo: NSDate().dateByAddingTimeInterval  (-60*60*12))
        query.orderByAscending("EventDate")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if objects != nil {
                 self.events = objects
                
                println("\n[ ]>>>>>> \(__FILE__.pathComponents.last!) >> \(__FUNCTION__) < \(__LINE__) >")
                self.tableView.reloadData()
            } else {
                println("fetch all events error \(error)")
            }
        }
    }
    func fetchPastEvents(){
//        var query = ParseEvent.query() as PFQuery
//         query.whereKey("EventDate", lessThan: NSDate().dateByAddingTimeInterval  (-60*60*5))
//        query.orderByDescending("EventDate")
//            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
//                if objects != nil {
//                    self.events = objects
//                    self.tableView.reloadData()
//                } else {
//                    println("fetch all events error \(error)")
//                }
//        }
    
    
        var user = PFUser.currentUser()
        var relation = user.relationForKey("rsvped")
        var query = relation.query()
        query.whereKey("EventDate", lessThan: NSDate().dateByAddingTimeInterval  (-60*60*12))
        query.orderByAscending("EventDate")
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
            var each : ParseEvent?
        if self.allMyEvents != nil {
            for each   in self.allMyEvents! {
                if each.objectId == objectId {
                     return true
                }
            }
        }
        return false
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        println("Logout")
        PFUser.logOut()
        var currentUser = PFUser.currentUser()
        self.performSegueWithIdentifier("toLoginSegue", sender: self)
        
    }

}
