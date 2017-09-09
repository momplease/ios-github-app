//
//  NewsTableViewCell.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 7/25/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var newsTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatarImageView?.backgroundColor = UIColor.red
        avatarImageView?.layer.cornerRadius = (avatarImageView?.frame.width)! / 2
        avatarImageView?.layer.masksToBounds = true
        avatarImageView?.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func updateAvatarInMainQueue(_ avatar: UIImage?) {
        weak var ws = self
        DispatchQueue.main.async {
            ws?.avatarImageView.image = avatar
        }
    }
    
}
