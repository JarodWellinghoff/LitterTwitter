//
//  TweetViewController.swift
//  Twitter
//
//  Created by Jarod Wellinghoff on 10/2/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
	@IBOutlet var tweetTextView: UITextView!
	@IBOutlet var profileImageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tweetTextView.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	@IBAction func cancel(_ sender: Any) {
		dismiss(animated: true, completion: nil)
		
	}
	
	@IBAction func tweet(_ sender: Any) {
		if (!tweetTextView.text.isEmpty) {
			TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
				self.dismiss(animated: true, completion: nil)
			}, failure: { (error) in
				print("Error posting tweet\n \(error)")
				self.dismiss(animated: true, completion: nil)
			})
		}
		
	}
}
