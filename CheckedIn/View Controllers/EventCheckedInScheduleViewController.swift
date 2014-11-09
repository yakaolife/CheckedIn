//
//  EventCheckedInScheduleViewController.swift
//  CheckedIn
//
//  Created by Cindy Zheng on 11/8/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit

class EventCheckedInScheduleViewController: UIViewController {
    var eventObjectId:String?
    var thisEvent:ParseEvent!

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Schedule"
        fetchTheEvent()

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
                self.greetingLabel.text = "Welcome to event: \(self.thisEvent.EventName!)"
                
                let urlString = "http://www.aaomp.org/annual-meeting/2014%20Schedule%20at%20a%20Glance.pdf"
                let url = NSURL(string: urlString)
                self.webView.loadRequest(NSURLRequest(URL: url!))
                self.webView.scalesPageToFit = true
 
                
             } else {
                println("getting detail event error \(error) ")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
