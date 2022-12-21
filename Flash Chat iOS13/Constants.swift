//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Jono Jono on 25/7/2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

struct K {
	static let appName = "💬Chatty"
	static let cellIdentifier = "ReusableCell"
	static let cellNibName = "MessageCell"
	static let registerSegue = "RegisterToChat"
	static let loginSegue = "LoginToChat"
	
	struct BrandColors {
		static let bgColor = "BGColor"
		static let gray = "BrandGray"
		static let lightPurple = "BrandLightPurple"
		static let blue = "BrandBlue"
		static let lighBlue = "BrandLightBlue"
		
	}
	
	struct FStore {
		static let collectionName = "messages"
		static let senderField = "sender"
		static let bodyField = "body"
		static let dateField = "date"
	}
}
