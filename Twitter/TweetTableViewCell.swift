//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Jarod Wellinghoff on 9/25/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
	@IBOutlet var profileImageView: UIImageView!
	@IBOutlet var usernameLabel: UILabel!
	@IBOutlet var tweetContentLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
