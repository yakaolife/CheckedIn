//
//  EventDetailViewController.swift
//  CheckedIn
//
//  Created by Ya Kao on 10/26/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

//Note: hiding first section header
//  Using the rest as seperator
import UIKit
import EventKit

class EventDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    @IBOutlet weak var addToCalendarButton: UIBarButtonItem!
    
    var eventIdAndRsvped:NSDictionary?
    var eventObjectId:String?
    var thisEvent: ParseEvent!
    var RSVPstate = true
    let eventStore = EKEventStore()
    
    let RSVPColor = UIColor(red: 63/255, green: 195/255, blue: 168/255, alpha: 1)
    let cancelColor = UIColor(red: 255/255, green: 193/255, blue: 126/255, alpha: 1)
    
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
            self.RSVPstate = eventIdAndRsvped?.objectForKey("isRsvped") as Bool
            changeRSVPButtonState(self.RSVPstate)
        }
         fetchTheEvent()
    }
    
    func fetchTheEvent (){
        
        var query = ParseEvent.query()
        
        query.getObjectInBackgroundWithId(self.eventObjectId ) { (object: PFObject!, error: NSError!) -> Void in
            if object != nil {
                let event = object as ParseEvent 
                self.thisEvent = event
                self.tableView.reloadData()
                
            } else {
                println("getting detail event error \(error) ")
            }
        }
    }

    //This function only change the look of the RSVPButton, it does not immediately update RSVP info on Parse
    // We do that when user dismiss this controller, just to save some bandwith
    func changeRSVPButtonState(updateState:Bool){
        //println("Changing RSVP from \(RSVPstate) to \(updateState)")
        if(updateState){
            rsvpButton.backgroundColor = cancelColor
            rsvpButton.tintColor = UIColor.blackColor()
            rsvpButton.setTitle("Cancel RSVP", forState: .Normal)
            addToCalendarButton.enabled = true
            rsvpEvent()
        }else{
            rsvpButton.backgroundColor = RSVPColor
            rsvpButton.tintColor = UIColor.whiteColor()
            rsvpButton.setTitle("RSVP", forState: .Normal)
            addToCalendarButton.enabled = false
            unRsvpEvent()
        }
        RSVPstate  = updateState
        
    }
    
    @IBAction func updateRSVP(sender: AnyObject) {
        changeRSVPButtonState(!RSVPstate)
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        println("in ViewWillDisappear")
//        if(self.RSVPstate){
//            rsvpEvent(self.eventObjectId!)
//        }else{
//            unRsvpEvent(self.eventObjectId!)
//        }
//        super.viewWillDisappear(true)
//    }
    
    func unRsvpEvent() {
        var user = PFUser.currentUser()
        var relation = user.relationForKey("rsvped")
        var events = ParseEvent.query() as PFQuery
        events.getObjectInBackgroundWithId(self.eventObjectId ) { (object: PFObject!, error: NSError!) -> Void in
            if object != nil {
                relation.removeObject(object)
                user.saveEventually()
 
//                user.saveInBackgroundWithBlock({ (succeed: Bool, error:NSError!) -> Void in
//                    if succeed {
//                        print("Succeed in cancel RSVP")
//                    } else  {
//                        println("rsvped error \(error)")
//                    }
//                })
            } else {
                println("rsvp event error \(error)")
            }
        }
    }
    
    
//    func rsvpEvent(selectedEventObjectId:String){
    func rsvpEvent(){
        var user = PFUser.currentUser()
        var relation = user.relationForKey("rsvped")
        var events = ParseEvent.query() as PFQuery
        events.getObjectInBackgroundWithId(self.eventObjectId ) { (object: PFObject!, error: NSError!) -> Void in
            if object != nil {
                relation.addObject(object)
                user.saveEventually()
 
                
//                user.saveInBackgroundWithBlock({ (succeed: Bool, error:NSError!) -> Void in
//                if succeed {
//                        println("Succeed RSVP")
//                        //self.fetchRsvpedEvents(true )
//                } else  {
//                        println("rsvped error \(error)")
//                    }
//                })
            } else {
                println("rsvp event error \(error)")
            }
        }
    }

    
 
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
//                    println("Getting new image!")
                }
            })
            return cell
            
        }else {
            //Time
             switch indexPath.row {	
                
            case 0:
                 var cell = tableView.dequeueReusableCellWithIdentifier("Time") as EventTimeTableViewCell
                cell.timeLabel.text = "\(self.thisEvent.eventDate!)"
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
                
//                if UIApplicationOpenSettingsURLString != nil {
//                    var appSettings = NSURL(string: UIApplicationOpenSettingsURLString)
//                   UIApplication.sharedApplication().openURL(appSettings!)
//                   // UIApplication.sharedApplication().openURL(NSURL(string: "checkInCodePath:\\")!)
//
//                }
            
           
            case EKAuthorizationStatus.NotDetermined:
                println("request access")
                requestEventAccess()
            
            default:
                return
        }
    }
   
    func addEventToCalendar(){
        //Add code to save event
        var startDate = self.thisEvent.eventDate?.dateByAddingTimeInterval(-60*60*24)
        var endDate = self.thisEvent.eventDate?.dateByAddingTimeInterval(60*60*24*3)
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
            
        }else{
            var event = EKEvent(eventStore: self.eventStore)
             event.title = self.thisEvent.EventName
            event.startDate = self.thisEvent.eventDate
            event.endDate = self.thisEvent.eventDate
            event.notes = "\(self.thisEvent.eventDetail!) \n\nLOCATION:\n\(self.thisEvent.fullAddress!)."
            event.calendar = self.eventStore.defaultCalendarForNewEvents
            var result = self.eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
            //println("add into calendar : \(result)")
            UIAlertView(title: "Calendar Item added", message: "Your event is added into your calendar on \(self.thisEvent.eventDate!). ", delegate: self, cancelButtonTitle: "OK").show()
        }

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


 