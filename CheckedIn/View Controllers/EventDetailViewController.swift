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
    var isRsvped:Bool?
    
    @IBOutlet weak var tableView: UITableView!
    
    var sectionKey = ["Header", "TimeInfo", "Map"] //We can add more here
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Event Detail"
    //    println("segue to \(self.eventNameAndRsvped!)")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 96
        // Do any additional setup after loading the view.
        if self.eventNameAndRsvped != nil {
            self.eventObjectId = eventNameAndRsvped?.objectForKey("objectId") as String?

        }
        
        fetchTheEvent()
    }
    
    func fetchTheEvent (){
        var query = ParseEvent.query()
        
        query.getObjectInBackgroundWithId(self.eventObjectId!) { (object: PFObject!, error: NSError!) -> Void in
            if object != nil {
                let event = object as ParseEvent
                
                //fetch view control outlet here!!!
                println("EVENT : \(event.EventName!)  detail: \(event.eventDetail? ) ")
                
                
            } else {
                println("getting detail event error \(error) ")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Current behavior:
        //only "TimeInfo" section contains 2 rows, 1 is Time, 1 is Event info
        if(sectionKey[section] == "TimeInfo"){
            return 2
        }else{
            return 1
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
            return cell
            
        }else if (indexPath.section == 1){
            //Time
            if(indexPath.row == 0){
                var cell = tableView.dequeueReusableCellWithIdentifier("Time") as UITableViewCell
                return cell
            }else{ //Event description
                var cell = tableView.dequeueReusableCellWithIdentifier("Description") as UITableViewCell
                return cell
            }
        }else{
            //Map
            var cell = tableView.dequeueReusableCellWithIdentifier("Map") as UITableViewCell
            return cell
        }
        
        
        
    }
    
    
    
    
    
}
