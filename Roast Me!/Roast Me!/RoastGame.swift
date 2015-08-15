//
//  RoastGame.swift
//  Roast Me!
//
//  Created by Seyun Kim on 8/14/15.
//  Copyright (c) 2015 Zack S Kim. All rights reserved.
//

import UIKit

class RoastGame :UIViewController {
	@IBOutlet weak var picture1: UIImageView!
	@IBOutlet weak var picture2: UIImageView!
	@IBOutlet weak var picture3: UIImageView!
	@IBOutlet weak var picture4: UIImageView!
	@IBOutlet weak var picture5: UIImageView!
	override func viewDidLoad() {
		self.picture1.layer.cornerRadius = self.picture1.frame.width/2
		
		
	}
}