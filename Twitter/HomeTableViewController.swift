//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Jarod Wellinghoff on 9/25/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
	
	var tweetArray = [NSDictionary]()
	var numberOfTweets: Int!
	
	let myRefreshControl = UIRefreshControl()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
		self.tableView.refreshControl = myRefreshControl
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = 100

    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		self.loadTweets()
	}

	@IBAction func onLogout(_ sender: Any) {
		UserDefaults.standard.set(false, forKey: "userLoggedIn")
		TwitterAPICaller.client?.logout()
		self.dismiss(animated: true, completion: nil)
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
		let user = tweetArray[indexPath.row]["user"] as! NSDictionary
		let tweetDateString = tweetArray[indexPath.row]["created_at"] as! String

		let handle = user["screen_name"] as!  String
		let username = user["name"] as! String
		let tweetContent = tweetArray[indexPath.row]["text"] as! String
		
		let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
		let data = try? Data(contentsOf: imageUrl!)
		if let imageData = data {
			cell.profileImageView.image = UIImage(data: imageData)?.circleMasked
			
		}
		cell.elapsedTimeLabel.text = getRelativeTime(tweetDateString)
		cell.handleLabel.text = "@\(handle)"
		cell.usernameLabel.text = username
		cell.tweetContentLabel.text = tweetContent
		cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
		cell.setRetweet(tweetArray[indexPath.row]["retweeted"] as! Bool)
		cell.tweetID = tweetArray[indexPath.row]["id"] as! Int
		
		return cell
	}
	
	// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
    }

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tweetArray.count
		
	}
	
	@objc func loadTweets() {
		let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
		numberOfTweets = 20
		let myParams = ["count" : numberOfTweets!]
		TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: {
			(tweets: [NSDictionary]) in
			self.tweetArray.removeAll()
			for tweet in tweets {
				self.tweetArray.append(tweet)
			}
			self.tableView.reloadData()
			self.myRefreshControl.endRefreshing()
//			print(self.tweetArray)
			
		}, failure: { (Error) in
			print("Could not retreive tweets...")
			print(Error.localizedDescription)
		})
	}

	func getRelativeTime(_ timeString:String) -> String {
		let tweetDateFormatter = DateFormatter()
		tweetDateFormatter.dateFormat = "E MMM d HH:mm:ss Z yyyy"
		let tweetDate = tweetDateFormatter.date(from:timeString)!
		let tweetCalendar = Calendar.current
		let tweetComponents = tweetCalendar.dateComponents([.year, .month, .minute], from: tweetDate, to: Date())
		let minutes = tweetComponents.minute!
		let hours = minutes / 60
		let days = hours / 24
		let weeks = days / 7
		let months = tweetComponents.month!
		let years = tweetComponents.year!

		if (minutes < 1) {
			return "Just now"
		} else if (minutes == 1) {
			return "A minute ago"
		} else if (hours < 1) {
			return "\(minutes) minutes ago"
		} else if (hours == 1) {
			return "An hour ago"
		} else if (days < 1) {
			return "\(hours) hours ago"
		} else if (days == 1) {
			return "A day ago"
		} else if (weeks < 1) {
			return "\(days) days ago"
		} else if (weeks == 1) {
			return "A week ago"
		} else if (months < 1) {
			return "\(weeks) weeks ago"
		} else if (months == 1) {
			return "A month ago"
		} else if (years < 1) {
			return "\(months) months ago"
		} else if (years == 1) {
			return "A year ago"
		} else {
			return "\(years) ago"
		}

	}
	
	func loadMoreTweets() {
		let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
		numberOfTweets += 20
		let myParams = ["count" : numberOfTweets!]
		TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: {
			(tweets: [NSDictionary]) in
			self.tweetArray.removeAll()
			for tweet in tweets {
				self.tweetArray.append(tweet)
			}
			self.tableView.reloadData()
			self.myRefreshControl.endRefreshing()
//			print(self.tweetArray)
			
		}, failure: { (Error) in
			print("Could not retreive tweets...")
			print(Error.localizedDescription)
		})
	}
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row + 1 == tweetArray.count {
			loadMoreTweets()
		}
	}

}
extension UIImage {
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
	   guard let cgImage = cgImage?
		  .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
									 y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
						  size: breadthSize)) else { return nil }
	   let format = imageRendererFormat
	   format.opaque = false
	   return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
		  UIBezierPath(ovalIn: breadthRect).addClip()
		  UIImage(cgImage: cgImage, scale: format.scale, orientation: imageOrientation)
		  .draw(in: .init(origin: .zero, size: breadthSize))
	   }
    }
}

