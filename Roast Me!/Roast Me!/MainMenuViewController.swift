//
//  MainMenuViewController.swift
//  Roast Me!
//
//  Created by Seyun Kim on 7/18/15.
//  Copyright (c) 2015 Zack S Kim. All rights reserved.
//

import UIKit
import Firebase


class MainMenuViewController: UIViewController  {
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBAction func logoutButton(sender: AnyObject) {
		let ref = Firebase(url: "https://roastme.firebaseio.com")
		ref.unauth()
		println("the user is now logged out")
		self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
		
	}
		override func viewDidLoad() {
			self.nameLabel.text = PFUser.currentUser()?.username
			

	}
	
}
