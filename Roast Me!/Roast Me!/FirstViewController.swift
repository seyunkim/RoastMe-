//
//  FirstController.swift
//  Roast Me!
//
//  Created by Seyun Kim on 7/20/15.
//  Copyright (c) 2015 Zack S Kim. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {
	
	var loggedin:Bool = false
	
	override func viewDidLoad() {
	
	}
	override func viewDidAppear(animated: Bool) {
		
		println("checking to see if there is a user logged in...")
		
		let ref = Firebase(url: "https://roastme.firebaseio.com")
		ref.observeAuthEventWithBlock({ authData in
			if authData != nil {
				// user authenticated
				// Do stuff with the user
				println("yes there is!!  will commence to main menu...")
				self.performSegueWithIdentifier("moveToMainMenu", sender: self)
				println(authData)
			} else {
				// No user is signed in
				println("the user is not logged in! Presenting Login Screen--->")
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let LoginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
				self.presentViewController(LoginViewController, animated:true, completion:nil)
				// Show the signup or login screen

			}
		})
		
		

	}
	
	
}
