//
//  FirstController.swift
//  Roast Me!
//
//  Created by Seyun Kim on 7/20/15.
//  Copyright (c) 2015 Zack S Kim. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
	
	var loggedin:Bool = false
	
	override func viewDidLoad() {
	
	}
	override func viewDidAppear(animated: Bool) {
		var currentUser = PFUser.currentUser()
		if currentUser != nil {
			// Do stuff with the user
			
		} else {
			println("the user is not logged in!")
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let LoginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
			self.presentViewController(LoginViewController, animated:true, completion:nil)
			// Show the signup or login screen
		}

	}
	
	
}