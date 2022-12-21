//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
		// optional chaining on 2 constants at the same time
		if let email = emailTextfield.text, let password = passwordTextfield.text {

		Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
			if let e = error {
				// error.localizedDescription will get hold of the error message in String format in user's local language
				self.emailTextfield.text = e.localizedDescription
				print(e.localizedDescription)
			} else {
				// trigger Segue way and Navigate to ChatViewController
				// we are able to use the K.registerSegue value without creating a new object outta K(Constants) struct cuz it was created as a static aka typeProperty
				self.performSegue(withIdentifier: K.registerSegue, sender: self)
			}

		}
		}
    }
    
}
