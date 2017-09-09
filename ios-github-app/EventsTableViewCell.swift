//
//  EventsTableViewCell.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 8/30/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var eventTextView: UITextView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatarImageView?.backgroundColor = UIColor.red
        avatarImageView?.layer.cornerRadius = (avatarImageView?.frame.width)! / 2
        avatarImageView?.layer.masksToBounds = true
        avatarImageView?.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }

}
