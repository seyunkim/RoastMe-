//
//  RoastGame.swift
//  Roast Me!
//
//  Created by Seyun Kim on 8/14/15.
//  Copyright (c) 2015 Zack S Kim. All rights reserved.
//

import UIKit
import Firebase
class RoastGame :UIViewController {
	@IBOutlet weak var picture1: UIImageView!
	@IBOutlet weak var picture2: UIImageView!
	@IBOutlet weak var picture3: UIImageView!
	@IBOutlet weak var picture4: UIImageView!
	@IBOutlet weak var picture5: UIImageView!
    var ref = Firebase(url: "https://roastme.firebaseio.com/web/data/users/883117308373977")
	override func viewDidLoad() {
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            println("\n\n\n")
            println(snapshot.value.objectForKey("profilePicURL"))
            let data = NSData(contentsOfURL: snapshot.value.objectForKey("profilePicURL")! as! NSURL)
            self.picture1.image = UIImage(data: data!)
        })
      
	}
    override func viewDidLayoutSubviews() {
        self.picture1.layer.cornerRadius = self.picture1.frame.size.width/2
        self.picture1.layer.masksToBounds = true
        self.picture1.layer.borderColor = UIColor.redColor().CGColor
        self.picture1.layer.borderWidth = 5
    }
}