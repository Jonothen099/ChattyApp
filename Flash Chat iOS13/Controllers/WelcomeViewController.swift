//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		

		titleLabel.text = ""
		var charIndex = 0.0
		let titleText = K.appName
		for letter in titleText{
			// this will create animation on the app logo when runs by typing out the chatty slowly, so to do that we put em in for loop and add timer since computer print it immediately otherwise
			Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
				self.titleLabel.text?.append(letter)
			}
			charIndex += 1
		}
		setGradientBackground()

		
    }
	
	
	func setGradientBackground() {
//		rgb(39, 123, 192)
//		rgb(23, 70, 162)
		let colorTop =  UIColor(red: 39/255.0, green: 123/255.0, blue: 192/255.0, alpha: 1.0).cgColor
		let colorBottom = UIColor(red: 23/255.0, green: 70/255.0, blue: 162/255.0, alpha: 1.0).cgColor
		
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = [colorTop, colorBottom]
		gradientLayer.locations = [0.0, 1.0]
		gradientLayer.frame = self.view.bounds
		
		self.view.layer.insertSublayer(gradientLayer, at:0)
	}
    

}
 
