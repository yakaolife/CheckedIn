//
//  EventCheckedInViewController.swift
//  CheckedIn
//
//  Created by Ya Kao on 10/26/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit

class EventCheckedInViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var sectionInfo = ["Welcome", "Schedule","Map"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 96


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionInfo.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            var cell = tableView.dequeueReusableCellWithIdentifier("WelcomeCell") as EventWelcomeHeaderTableViewCell
            return cell
        case 1:
            var cell = tableView.dequeueReusableCellWithIdentifier("Schedule") as UITableViewCell
            return cell
        case 2:
            var cell = tableView.dequeueReusableCellWithIdentifier("Map") as UITableViewCell
            return cell
        default:
            var cell = UITableViewCell()
            return cell
        }

    }

}
