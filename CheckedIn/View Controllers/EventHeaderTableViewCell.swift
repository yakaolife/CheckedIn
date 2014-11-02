//
//  EventHeaderTableViewCell.swift
//  CheckedIn
//
//  Created by Ya Kao on 10/27/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit

class EventHeaderTableViewCell: UITableViewCell {


    @IBOutlet weak var rsvpButton: UIButton!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var eventLogoImage: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    var RSVPstate = true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.contentView.backgroundColor = UIColor(red: 63/255, green: 195/255, blue: 168/255, alpha: 1)
        self.frame.size.height = 180
        self.eventLogoImage.layer.cornerRadius = 5.0
        self.eventLogoImage.clipsToBounds = true
        self.rsvpButton.backgroundColor = UIColor.clearColor()
        self.changeRSVP()

        rsvpButton.addTarget(self, action: "changeRSVP", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    //TODO: RSVP to parse
    //RSVPstate is current state that will be changed
    func changeRSVP(){
        //println("Changing RSVP from \(RSVPstate) to \(!RSVPstate)")
        if(RSVPstate){
            rsvpButton.setImage(UIImage(named:"rsvpHover.png"), forState: UIControlState.Normal)
            RSVPstate = false
        }else{
            rsvpButton.setImage(UIImage(named:"rsvpCancel.png"), forState: UIControlState.Normal)
            RSVPstate = true
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
