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

class EventDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var eventNameAndRsvped:NSDictionary?
    var eventObjectId:String?
    var thisEvent: ParseEvent!
    var RSVPstate = true
    
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
         if self.eventNameAndRsvped != nil {
            self.eventObjectId = eventNameAndRsvped?.objectForKey("objectId") as String?
            self.RSVPstate = eventNameAndRsvped?.objectForKey("isRsvped") as Bool
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
        }else{
            rsvpButton.backgroundColor = RSVPColor
            rsvpButton.tintColor = UIColor.whiteColor()
            rsvpButton.setTitle("RSVP", forState: .Normal)
        }
        RSVPstate  = updateState
        
    }
    
    @IBAction func updateRSVP(sender: AnyObject) {
        changeRSVPButtonState(!RSVPstate)
    }
    
    override func viewWillDisappear(animated: Bool) {
        println("in ViewWillDisappear")
        if(self.RSVPstate){
            rsvpEvent(self.eventObjectId!)
        }else{
            unRsvpEvent(self.eventObjectId!)
        }
        super.viewWillDisappear(true)
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
                        print("Succeed in cancel RSVP")
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
                        println("Succeed RSVP")
                        //self.fetchRsvpedEvents(true )
                    } else  {
                        println("rsvped error \(error)")
                    }
                })
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
            println("First header section height is set to 0")
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
}

 