//
//  EventDetailViewController.swift
//  CheckedIn
//
//  Created by Ya Kao on 10/26/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit
import EventKit

enum StateOfCheckedIn  {
    case Done
    case Now
    case NA
}

class EventDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    @IBOutlet weak var addToCalendarButton: UIBarButtonItem!
    var eventIdAndRsvped:NSDictionary?
    var eventObjectId:String?
    var thisEvent: ParseEvent!
    var RSVPstate:Bool?
    let eventStore = EKEventStore()
    var state = StateOfCheckedIn.NA
    let RSVPColor = UIColor(red: 63/255, green: 195/255, blue: 168/255, alpha: 1)
    let cancelColor = UIColor(red: 255/255, green: 193/255, blue: 126/255, alpha: 1)
    var imageNames = ["checkInButton01.png", "checkInButton02.png","checkInButton03.png", ]
    @IBOutlet weak var rsvpButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var sectionKey = ["Header", "TimeInfo" ] //We can add more here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Event Detail"
         tableView.delegate = self
         tableView.dataSource = self
         tableView.rowHeight = UITableViewAutomaticDimension
         tableView.estimatedRowHeight = 96
        // Do any additional setup after loading the view.
        
        //if segue from profile view controller , otherwise, objectId should be set
         if self.eventIdAndRsvped != nil {
            self.eventObjectId = eventIdAndRsvped?.objectForKey("objectId") as String?
            //for past event, no rsvp state
            if let rsvpState = eventIdAndRsvped?.objectForKey("isRsvped") as Bool? {
                self.RSVPstate = eventIdAndRsvped?.objectForKey("isRsvped") as Bool?
            }
        }
         fetchTheEvent()
    }
    
    //MARK: parse methods
    func CheckedInState()  {
        var user = PFUser.currentUser()
        var relation = user.relationForKey("checkedIn")
        var query = relation.query()
        query.whereKey("objectId", equalTo: eventObjectId)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            //already checked in
             if objects.count > 0 {
                self.state = StateOfCheckedIn.Done
                self.showRSVPButton()
                
            } else {
                var eventTime = self.thisEvent!.eventDate!
                var startTime = eventTime.dateByAddingTimeInterval(-60*60*12)
                var endTime = eventTime.dateByAddingTimeInterval(60*60*12)
                var now = NSDate()
                if now.compare(startTime) == NSComparisonResult.OrderedDescending && now.compare(endTime) == NSComparisonResult.OrderedAscending {
                    //ok to checked in
                    self.state = StateOfCheckedIn.Now
                    self.showRSVPButton()
                 }
            }
            self.showRSVPButton()
         }
    }
    
    func fetchTheEvent (){
        var query = ParseEvent.query()        
        query.getObjectInBackgroundWithId(self.eventObjectId ) { (object: PFObject!, error: NSError!) -> Void in
            if object != nil {
                let event = object as ParseEvent 
                self.thisEvent = event
                 self.CheckedInState()
                self.tableView.reloadData()
            } else {
                println("getting detail event error \(error) ")
            }
        }
    }

    //This function only change the look of the RSVPButton, it does not immediately update RSVP info on Parse
    // We do that when user dismiss this controller, just to save some bandwith
    func showRSVPButton(){
         //for past event, no button to show here
        if self.RSVPstate == nil {
            addToCalendarButton.enabled = false
            rsvpButton.enabled = false
            rsvpButton.alpha = 0
            rsvpButton.backgroundColor = cancelColor
            return
        }
        if((self.RSVPstate) == true ){
            switch self.state {
            case StateOfCheckedIn.NA:
                 rsvpButton.setTitle("Cancel RSVP", forState: .Normal)
                addToCalendarButton.enabled = true
                rsvpButton.backgroundColor = cancelColor
                rsvpButton.tintColor = UIColor.blackColor()

            case StateOfCheckedIn.Now:
                 //TODO/betsy: Make an animated button for this
                addToCalendarButton.enabled = false
                println("Can check in now!")
                var images = NSMutableArray()
                for var index = 0; index < imageNames.count; index++ {
                    images.addObject(UIImage(named: imageNames[index])!)
                }
                
                var animateButtonView = UIImageView(frame: rsvpButton.bounds)
                animateButtonView.tag = 1
                animateButtonView.animationImages = images
                animateButtonView.animationDuration = 0.8
                animateButtonView.animationRepeatCount = 0
                animateButtonView.startAnimating()
                rsvpButton.addSubview(animateButtonView)


            case StateOfCheckedIn.Done:
                 addToCalendarButton.enabled = false
                var animateButtonView = rsvpButton.viewWithTag(1)
                if(animateButtonView != nil){
                    animateButtonView?.removeFromSuperview()
                }
                var newButtonView = UIImageView(image: UIImage(named: "checkedInButton.png"))
                rsvpButton.addSubview(newButtonView)
            }
            
         }else{
            rsvpButton.backgroundColor = RSVPColor
            rsvpButton.tintColor = UIColor.whiteColor()
            rsvpButton.setTitle("RSVP", forState: .Normal)
            addToCalendarButton.enabled = false
         }
    }

    //TODO/betsy: Need to do the check in!
    @IBAction func updateRSVP(sender: AnyObject) {
         if self.RSVPstate != true {
            self.RSVPstate = !self.RSVPstate!
            showRSVPButton()
            //since state changed for UI, here is oposite
            if self.RSVPstate == false {
                unRsvpEvent()
            } else {
                rsvpEvent()
            }
     
        } else {
            switch self.state {
            case StateOfCheckedIn.Now :
                checkInEvent()
            case StateOfCheckedIn.Done:
                 UIAlertView(title: "checked In already", message: "You are already checked In", delegate: self, cancelButtonTitle: "OK").show()
            case StateOfCheckedIn.NA:
                self.RSVPstate = !self.RSVPstate!
                showRSVPButton()
                //since state changed for UI, here is oposite
                if self.RSVPstate == false {
                    unRsvpEvent()
                } else {
                    rsvpEvent()
                }
            }
        }
    }

    func unRsvpEvent() {
        var user = PFUser.currentUser()
        var relation = user.relationForKey("rsvped")
        var events = ParseEvent.query() as PFQuery
        events.getObjectInBackgroundWithId(self.eventObjectId ) { (object: PFObject!, error: NSError!) -> Void in
            if object != nil {
                relation.removeObject(object)
                user.saveEventually()
            } else {
                println("rsvp event error \(error)")
            }
        }
    }
    
    func checkInEvent(){
        var user = PFUser.currentUser()
        var relation = user.relationForKey("checkedIn")
        var events = ParseEvent.query() as PFQuery
        events.getObjectInBackgroundWithId(self.eventObjectId ) { (object: PFObject!, error: NSError!) -> Void in
            if object != nil {
                relation.addObject(object)
                println("checked in!")
                self.state = StateOfCheckedIn.Done
                self.showRSVPButton()
                user.saveEventually()
            } else {
                println("check in event error \(error)")
            }
        }
    }
    
    func rsvpEvent(){
        var user = PFUser.currentUser()
        var relation = user.relationForKey("rsvped")
        var events = ParseEvent.query() as PFQuery
        events.getObjectInBackgroundWithId(self.eventObjectId ) { (object: PFObject!, error: NSError!) -> Void in
            if object != nil {
                relation.addObject(object)
                user.saveEventually()
            } else {
                println("rsvp event error \(error)")
            }
        }
    }
    
    //MARK: tableview related data source or delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Current behavior:
        //only "TimeInfo" section contains 2 rows, 1 is Time, 1 is Event info
        if thisEvent == nil {
                return 0
        }else{
            if(sectionKey[section] == "TimeInfo"){
                return 3
            }else{
                return 1
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
          //  println("First header section height is set to 0")
            return 0 //Header
        }else{
            return 20
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionKey.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Had to return cell in every conditional block, can't use lazy initialization :(
        //Header
        if(indexPath.section == 0){
            var cell = tableView.dequeueReusableCellWithIdentifier("EventHeader") as EventHeaderTableViewCell
            //Pass in cell info

            cell.eventTitleLabel.text = thisEvent.EventName
            thisEvent.eventProfileImage?.getDataInBackgroundWithBlock({ (imageData: NSData!, error:NSError!) -> Void in
                if imageData != nil {
                    cell.eventLogoImage.image = UIImage(data: imageData)
                    cell.bgImage.image = cell.eventLogoImage.image
                    var blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
                    blur.frame = cell.bgImage.frame
                    cell.bgImage.addSubview(blur)
                    cell.backgroundView = cell.bgImage
                }
            })
            return cell
            
        }else {
            //Time
            switch indexPath.row {	
                
            case 0:
                 var cell = tableView.dequeueReusableCellWithIdentifier("Time") as EventTimeTableViewCell
                cell.timeLabel.text = "\(self.thisEvent.dateToShow!)"
                return cell
                
            case 1:
                 var cell = tableView.dequeueReusableCellWithIdentifier("Description") as EventDescriptionTableViewCell
                 cell.descriptionLabel.text = self.thisEvent.eventDetail
                return cell
                
              default:
                tableView.rowHeight = 380
                var cell = tableView.dequeueReusableCellWithIdentifier("Map") as EventMapTableViewCell
                cell.addAnotation(self.thisEvent!)
                return cell
            }
        }
    }
    
    @IBAction func onAddEvent(sender: AnyObject) {        
        //show user alert first about the access premission
        
        switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent)  {
            case EKAuthorizationStatus.Authorized:
                println("authorized")
                addEventToCalendar()
            case EKAuthorizationStatus.Denied :
                println("denied")
                UIAlertView(title: "Change Setting Needed", message: "You have denied our calendar access, please update the configuration on your IOS device.", delegate: self, cancelButtonTitle: "OK").show()
            case EKAuthorizationStatus.NotDetermined:
                println("request access")
                requestEventAccess()
            
            default:
                return
        }
    }
    
    //MARK : calendar related   
    func addEventToCalendar(){
        //Add code to save event
        //currently we use such time windows for event past and current guideline
        var startDate = self.thisEvent.eventDate?.dateByAddingTimeInterval(-60*60*12)
        var endDate = self.thisEvent.eventDate?.dateByAddingTimeInterval(60*60*24*12)
        var predicate = self.eventStore.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)
        var eV = self.eventStore.eventsMatchingPredicate(predicate) as [EKEvent]!
        if eV != nil{
            for i in eV{
               // println("Event Title:\(i.title)")
                if i.title == self.thisEvent.EventName{
                   // println("Already have the event!")
                    UIAlertView(title: "Duplicate events found", message: "You already have a same event on your calendar. ", delegate: self, cancelButtonTitle: "Ok").show()
                    return
                }
            }
            
        }
         UIAlertView(title: "Calendar Item added", message: "Your event is added into your calendar on \(self.thisEvent.eventDate!). ", delegate: self, cancelButtonTitle: "OK").show()
        var event = EKEvent(eventStore: self.eventStore)
        event.title = self.thisEvent.EventName
        event.startDate = self.thisEvent.eventDate
        event.endDate = self.thisEvent.eventDate
        event.notes = "\(self.thisEvent.eventDetail!)"
        event.calendar = self.eventStore.defaultCalendarForNewEvents
        var result = self.eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
        //println("add into calendar : \(result)")

    }

    func requestEventAccess()  {
        
        let alert = UIAlertController(title: "Add this event to calendar?", message: "In order to add this event to your calendar, we may need your permission", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertActionStyle.Default, handler:{(alert: UIAlertAction!)-> Void in
            println("Cancel the add event action, do nothing")
       
        }))
        
        alert.addAction(UIAlertAction(title:"Add", style: UIAlertActionStyle.Default, handler:{(alert: UIAlertAction!)-> Void in
            
            self.eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
                granted, error in
                if(granted) && (error == nil){
                    
                    println("Access to Calendar/Reminder granted")
                 
                    self.addEventToCalendar()
                    
                } else {
                    println("access request denied!")
                }
            })
        }))
         self.presentViewController(alert, animated: true, completion: nil)
    }

}
