//
//  FriendCell.swift
//  vkProject
//
//  Created by Антон Григорьев on 14.04.2018.
//  Copyright © 2018 Антон Григорьев. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendAvatar: UIImageView!
    
    public var friend: Person! {
        didSet {
            friendSetConfigure()
        }
    }
    
    private func friendSetConfigure() {
        friendNameLabel.text = friend.fullname()
        friendAvatar.layer.cornerRadius = friendAvatar.frame.size.width / 2
        friendAvatar.clipsToBounds = true
        
        if let imageData = friend.info["avatar50_imageData"] {
            let image = UIImage(data: imageData as! Data)
            self.friendAvatar.image = image
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        self.friendNameLabel.text = ""
        self.friendAvatar.image = nil
        
    }

}
