	//
	//  ChatViewController.swift
	//  Flash Chat iOS13
	//
	//  Created by Angela Yu on 21/10/2019.
	//  Copyright © 2019 Angela Yu. All rights reserved.
	//

import UIKit
import Firebase

class ChatViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var messageTextfield: UITextField!
	
	let db = Firestore.firestore()
	
	var messages: [Message] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = self
		title = K.appName
		// use to hide go back button when not needed 
		navigationItem.hidesBackButton = true
			// to use any custom UIView we need to give the class an identifier as well as the forCellReuseIdentifier then we use this code to register em here
			// so once loaded, this will load the MessageCell.xib file UI into the chat window
		tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
			// calling load messages func
		loadMessages()
		
	}
		// this func will be called upon loading up the chat window, where it will clear the messages dict and grab data from the fireStore database and load it into it
	func loadMessages(){
		db.collection(K.FStore.collectionName)
			// .order(by: "String") will sort ur message according to date in this instance
			.order(by: K.FStore.dateField)
			// add the data into the field, literally listen to the real time update as we sending message and update it
			.addSnapshotListener{ querySnapshot, error in
			// by emptying our dict/array here, this func will listen to a new update
			// if there is a new update to the dict then it will empty the dict and add the new update and load it
			self.messages = []

			if let e = error {
				print("There was an issue retrieving data from FireStore.\(e.localizedDescription)")
			} else {
				if let snapShotDocuments = querySnapshot?.documents{
					for doc in snapShotDocuments {
						let data = doc.data()
						if let messageSender = data[K.FStore.senderField] as? String,
						   let messageBody = data[K.FStore.bodyField] as? String {
								// making a new object outta Message struct and assign values to it
							let newMessage = Message(sender: messageSender, body: messageBody)
							self.messages.append(newMessage)
							// all above code will not load if you don't do this, this will load the func above into the foreground tableView
							
							DispatchQueue.main.async { [self] in
								tableView.reloadData()
								// this will view the newest messages instead of the oldest messages
								let indexPath = IndexPath(row: messages.count - 1, section: 0)
								tableView.scrollToRow(at: indexPath, at: .top, animated: true)
							}
						}
					}
				}
			}
		}
	}
	
	@IBAction func sendPressed(_ sender: UIButton) {
		// saving messages and sender into the database
		if let messageBody = messageTextfield.text
			,let messageSender = Auth.auth().currentUser?.email {
			//  once the send button is pressed we want to saved all these data
			db.collection(K.FStore.collectionName).addDocument(data: [
				K.FStore.senderField: messageSender,
		 		K.FStore.bodyField:messageBody,
				// this will get the number of sec since 1970 in the form of Int, that way we can figure out which message is send first or latest message so we can sort em out properly.
				K.FStore.dateField: Date().timeIntervalSince1970
			]) { (error) in
				if let e = error{
					print("there was issue saving data to fireStore, \(e)")
				} else{
					print("Successfully saved data.")
					DispatchQueue.main.async {
							// once the send button is pressed, then we empty the textfield
						self.messageTextfield.text = ""
					}
				}
			}
		}
		

	}
	
	@IBAction func logOutPressed(_ sender: UIBarButtonItem) {
			// signing out account
		let firebaseAuth = Auth.auth()
		do {
			try firebaseAuth.signOut()
				// once log out button is clicked, user will navigate back to RootViewController which is the entry screen when app first launched
			navigationController?.popToRootViewController(animated: true)
		} catch let signOutError as NSError {
			print("Error signing out: %@", signOutError)
		}
		
	}
	
}
	//MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource{
		// this responsible for telling the tableview how many row the table view will have
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
		// this responsible for telling the tableview what data to insert into the tableview
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			// setting the cellview as the custom MessageCell class that we made
		let message = messages[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
		// setting up the what data goes into the message buble
		cell.label.text = message.body
		
		// this is a message from the current user
		if message.sender == Auth.auth().currentUser?.email {
			cell.rightImageView.isHidden = false
			cell.leftImageView.isHidden = true
			cell.messageBuble.backgroundColor = UIColor(named: K.BrandColors.blue)
			cell.label.textColor = UIColor(named: K.BrandColors.lighBlue)

		}
		// this is a message from another user
		else{
			cell.rightImageView.isHidden = true
			cell.leftImageView.isHidden = false
			cell.messageBuble.backgroundColor = UIColor(named: K.BrandColors.gray)
			cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
			
		}
		
		return cell
		
	}
}


