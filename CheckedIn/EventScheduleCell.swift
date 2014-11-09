//
//  EventScheduleCell.swift
//  CheckedIn
//
//  Created by Cindy Zheng on 11/8/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit

class EventScheduleCell: UITableViewCell {

    @IBOutlet weak var webView: UIWebView!
//    var ulr:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadSchedulePDF (urlString:String?) {
        
        let url = NSURL(string: urlString!)
        self.webView.loadRequest(NSURLRequest(URL: url!))
        self.webView.scalesPageToFit = true
    }
 
}
