//
//  MessageManager.swift
//  Chatripp
//
//  Created by developer on 2019/4/3.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse

class MessageManager: NSObject {
	private static var instance:MessageManager!
	static func sharedInstance() -> MessageManager! {
		if instance == nil {
			instance = MessageManager.init()
		}
		return instance
	}
	
	let friends: NSMutableArray = []
	let profiles: NSMutableArray = []
	var messages: [String: NSMutableArray]! = [String: NSMutableArray]()
	
	var completionHandler: ((_ error: Any?) -> Void)!
	
	public static func fromMe(_ message: PFObject!) -> Bool {
		let senderId = message["senderId"] as? String
		return (senderId == PFUser.current()?.objectId)
	}
	
	public static func isImage(_ message: PFObject!) -> Bool {
		let image = message["image"]
		return (image != nil)
	}
	
	public func loadFriends(callback: @escaping ((_ error: Any?) -> Void)) {
		self.completionHandler = callback
		
		self.friends.removeAllObjects()
		self.profiles.removeAllObjects()
		
		let userQuery = PFUser.query()
		userQuery?.whereKey("email", notEqualTo: PFUser.current()?.email as Any)
		userQuery?.findObjectsInBackground(block: { (result, error) in
			DispatchQueue.global(qos: .background).async {
				for friendUser in result! {
					do {
						let profileQuery = PFQuery(className: "Profile")
						profileQuery.whereKey("userObjId", equalTo:friendUser.objectId as Any)
						let profile = try profileQuery.getFirstObject()
						self.profiles.add(profile)
						
						self.friends.add(friendUser)
					} catch {}
				}
				
				DispatchQueue.main.async(execute: {
					self.completionHandler(error)
				})
			}
		})
	}
	
	public func reloadMessage(friend: PFUser!, callback: @escaping ((_ error: Any?) -> Void)) {
		self.completionHandler = callback
		
		let results: NSMutableArray = []
		
		let senderQuery = PFQuery(className: "Messages")
		senderQuery.whereKey("senderId", equalTo:PFUser.current()?.objectId as Any)
		senderQuery.whereKey("receiverId", equalTo:friend.objectId as Any)
		
		let receiverQuery = PFQuery(className: "Messages")
		receiverQuery.whereKey("senderId", equalTo:friend.objectId as Any)
		receiverQuery.whereKey("receiverId", equalTo:PFUser.current()?.objectId as Any)
		
		let messageQuery = PFQuery.orQuery(withSubqueries: [senderQuery, receiverQuery])
		messageQuery.order(byAscending: "updatedAt")
		messageQuery.findObjectsInBackground { (messages, error) in
			for message in messages! {
				results.add(message)
			}
			
			self.messages[friend.objectId!] = results
			
			DispatchQueue.main.async(execute: {
				self.completionHandler(error)
			})
		}
	}
	
	public func loadMessage(user: PFUser!, callback: @escaping ((_ error: Any?) -> Void)) {
		self.completionHandler = callback
		
		if self.messages[user.objectId!] != nil {
			DispatchQueue.main.async {
				self.completionHandler(nil)
			}
			return
		}
		
		self.reloadMessage(friend: user, callback: self.completionHandler)
	}
	
	func sendMessage(_ receiver:PFUser, content: String!, callback: @escaping ((_ error: Any?) -> Void)) {
		/// Save
		let message = PFObject(className: "Messages")
		message["senderId"] = PFUser.current()?.objectId
		message["receiverId"] = receiver.objectId
		message["content"] = content
		message.saveInBackground { (success: Bool, error: Error?) in
			if error != nil {
				DispatchQueue.main.async(execute: {
					callback(error)
				})
				print("Failed to send message!!!")
				return
			}
			
			let messages = self.messages?[receiver.objectId!]
			messages?.add(message)
			
			/// Send Push Notification
			self.sendPush(receiver, content: content)
			
			DispatchQueue.main.async(execute: {
				callback(nil)
			})
			
			print("Sent message!!!")
		}
	}
	
	public func sendImage(_ receiver:PFUser, image: UIImage!, callback: @escaping ((_ error: Any?) -> Void)) {
		let data = image.pngData()
		let file = PFFileObject(name: "image", data: data!)
		/// Save
		let message = PFObject(className: "Messages")
		message["senderId"] = PFUser.current()?.objectId
		message["receiverId"] = receiver.objectId
		message["image"] = file
		message.saveInBackground { (success: Bool, error: Error?) in
			if error != nil {
				DispatchQueue.main.async(execute: {
					callback(error)
				})
				print("Failed to send message!!!")
				return
			}
			
			let messages = self.messages?[receiver.objectId!]
			messages?.add(message)
			
			/// Send Push Notification
			self.sendPush(receiver, content: "Image")
			
			DispatchQueue.main.async(execute: {
				callback(nil)
			})
			
			print("Sent message!!!")
		}
	}
	
	func sendPush(_ receiver: PFUser!, content: String!) {
		let pushDictionary = ["alert": content, "badge": "increment", "sound":"default"]
		
		let query: PFQuery = PFInstallation.query()!
		query.whereKey("channels", contains: receiver.objectId)
		
		let push: PFPush = PFPush()
		push.setQuery(query as? PFQuery<PFInstallation>)
		push.setMessage(content)
		push.setData(pushDictionary)
		push.sendInBackground(block: { (success:Bool, error:Error?) in
			if error != nil {
				print(error as Any)
			} else {
				print("Sent Push Notification for Message!!!")
			}
		})
	}
	
	public func messages(user:PFUser!) -> NSMutableArray! {
		let messages = self.messages[user.objectId!]
		return messages
	}
	
	public func messageCount(user: PFUser!) -> Int {
		let messages = self.messages(user: user) as NSMutableArray
		return messages.count as Int
	}
}
