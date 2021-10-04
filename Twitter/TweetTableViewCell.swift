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
	@IBOutlet var elapsedTimeLabel: UILabel!
	@IBOutlet var handleLabel: UILabel!
	@IBOutlet var favoriteButton: UIButton!
	@IBOutlet var retweetButton: UIButton!

	var favorited:Bool = false
	var retweeted:Bool = false
	var tweetID = Int()


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setFavorite(_ isFavorited:Bool) {
		favorited = isFavorited
		if (favorited) {
			favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
		} else {
			favoriteButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
		}
	}
	
	func setRetweet(_ isRetweeted:Bool) {
		retweeted = isRetweeted
		if (retweeted) {
			retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
		} else {
			retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
		}
	}

	@IBAction func favoriteTweet(_ sender: Any) {
		let toBeFavorited = !favorited
		if (toBeFavorited) {
			TwitterAPICaller.client?.favoriteTweet(tweetID: tweetID, success: {
				self.setFavorite(true)
			}, failure: { Error in
				print("Favorite did not succeed\n \(Error)")
			})
		} else {
			TwitterAPICaller.client?.unfavoriteTweet(tweetID: tweetID, success: {
				self.setFavorite(false)
			}, failure: { Error in
				print("Unfavorite did not succeed\n \(Error)")
			})

		}
	}

	@IBAction func retweet(_ sender: Any) {
		let toBeRetweeted = !retweeted
		if (toBeRetweeted) {
			TwitterAPICaller.client?.retweet(tweetID: tweetID, success: {
				self.setRetweet(true)
			}, failure: { Error in
				print("Retweet did not succeed\n \(Error)")
			})
		} else {
			TwitterAPICaller.client?.unRetweet(tweetID: tweetID, success: {
				self.setRetweet(false)
			}, failure: { Error in
				print("Unfavorite did not succeed\n \(Error)")
			})

		}
	}

}
