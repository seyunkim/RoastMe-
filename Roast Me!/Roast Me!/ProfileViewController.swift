//
//  ProfileViewController.swift
//  Roast Me!
//
//  Created by Seyun Kim on 7/29/15.
//  Copyright (c) 2015 Zack S Kim. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
	@IBOutlet weak var profileImageView: UIImageView!
	override func viewDidLoad() {
//		var facebookProfileUrl = "http://graph.facebook.com/\(userID)/picture?type=large"
//		
//		FBRequestConnection.startWithGraphPath("me?fields=feed", completionHandler: { (connection, result, error) -> Void in
//			if( error == nil){
//				
//				let fbGraphObject = result as FBGraphObject
//				
//				let feed = fbGraphObject.objectForKey("feed") as NSMutableDictionary
//				let data = feed.objectForKey("data") as NSMutableArray
//				
//				let postDescription = data[0].objectForKey("description") as String
//				
//				//println( post )
//				
//				self.fbu.initialUserFeed = feed
//				self.performSegueWithIdentifier("SelectStreams", sender: self)
//				
//			}else
//			{
//				//TODO Allert to user that something went wrong
//				println(error)
//			}
//			
//		})
	}
	
}

