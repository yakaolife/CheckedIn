//
//  MapViewViewController.swift
//  CheckedIn
//
//  Created by Cindy Zheng on 10/29/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit

class MapViewViewController: UIViewController {

    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true , completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
