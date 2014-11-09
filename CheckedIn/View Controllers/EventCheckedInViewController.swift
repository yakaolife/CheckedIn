//
//  EventCheckedInViewController.swift
//  CheckedIn
//
//  Created by Ya Kao on 10/26/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit

class EventCheckedInViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var eventObjectId:String?
    var thisEvent: ParseEvent!

    
    @IBOutlet weak var tableView: UITableView!
    
    var rowInfo = ["Welcome", "Description","Schedule","Bottom"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 96
        
        fetchTheEvent ()


        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if thisEvent == nil {
            return 0
        } else {
              return rowInfo.count + 1
        }
    
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         switch indexPath.row{
        case 0:
            var cell = tableView.dequeueReusableCellWithIdentifier("WelcomeCell") as EventWelcomeHeaderTableViewCell
            cell.welcomeTextLabel.text = "Welcome, you are @\n\(self.thisEvent.EventName!).  "
            return cell
        case 1:
            var cell = tableView.dequeueReusableCellWithIdentifier("Description2") as EventCheckedInDescriptionCell
            cell.descriptionLabel.text = self.thisEvent.fullAddress!
             return cell
        case 2:
            var cell = tableView.dequeueReusableCellWithIdentifier("Schedule") as EventScheduleCell
           tableView.rowHeight = 600
            cell.loadSchedulePDF("http://www.aaomp.org/annual-meeting/2014%20Schedule%20at%20a%20Glance.pdf")
            return cell
 
        default:
            var cell = tableView.dequeueReusableCellWithIdentifier("bottom") as myTableViewCell
            return cell
        }

    }

}
