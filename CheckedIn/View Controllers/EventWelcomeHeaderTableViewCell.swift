//
//  EventWelcomeHeaderTableViewCell.swift
//  CheckedIn
//
//  Created by Ya Kao on 10/28/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit

class EventWelcomeHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var eventLogoImage: UIImageView!
    @IBOutlet weak var welcomeTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor(red: 63/255, green: 195/255, blue: 168/255, alpha: 1)
        self.frame.size.height = 180
        self.eventLogoImage.layer.cornerRadius = 5.0
        self.eventLogoImage.clipsToBounds = true

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
