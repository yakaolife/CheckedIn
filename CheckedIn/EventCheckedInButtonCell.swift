//
//  EventCheckedInButtonCell.swift
//  CheckedIn
//
//  Created by Cindy Zheng on 11/7/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit

class EventCheckedInButtonCell: UITableViewCell {

    @IBOutlet weak var checkedInButton: UIButton!
    
    
    
    @IBAction func onCheckedIn(sender: UIButton) {
        
        println("\n[ ]>>>>>> \(__FILE__.pathComponents.last!) >> \(__FUNCTION__) < \(__LINE__) >")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
