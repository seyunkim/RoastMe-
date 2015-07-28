//
//  MainMenuViewController.swift
//  Roast Me!
//
//  Created by Seyun Kim on 7/18/15.
//  Copyright (c) 2015 Zack S Kim. All rights reserved.
//

import UIKit



class MainMenuViewController: UIViewController  {
	
	@IBAction func logoutButton(sender: AnyObject) {
		PFUser.logOut()
		println("the user is now logged out")
	}
		override func viewDidLoad() {
			

	}
	
}
