//
//  MainMenuViewController.swift
//  Roast Me!
//
//  Created by Seyun Kim on 7/18/15.
//  Copyright (c) 2015 Zack S Kim. All rights reserved.
//

import UIKit



class MainMenuViewController: UIViewController, FBSDKLoginButtonDelegate {
	
		override func viewDidLoad() {
			var loginButton = FBSDKLoginButton()
			loginButton.delegate = self
			loginButton.frame = CGRectMake(100, 100, 150, 40)
			self.view.addSubview(loginButton)

	}
	func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
		
		println("User Logged In")
	}
	func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
		
		println("User Logged Out")
	}


}
