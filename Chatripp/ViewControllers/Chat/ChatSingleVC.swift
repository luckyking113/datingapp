//
//  ChatSingleVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/31.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse

class ChatSingleVC: UIViewController {
	
	var friend: PFUser? = nil
	var profile: PFObject? = nil
	var messages: NSMutableArray! = []
	var tableCells: NSMutableArray! = []
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var tripInfoLabel: UILabel!
	@IBOutlet weak var avatarImageView: PFImageView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var contentTextField: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		(UIApplication.shared.delegate as? AppDelegate)?.chatSingleVC = self
		
		self.nameLabel.text = String(format: "%@ %@", self.profile!["first_name"] as! String, self.profile!["last_name"] as! String)
		
		reload()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		(UIApplication.shared.delegate as? AppDelegate)?.chatSingleVC = nil
	}

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func setupView() {
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.goBackVC()
    }
	
	public func load() {
		if self.messages.count > 0 {
			return
		}
		
		reload()
	}
	
	public func reload() {
		MessageManager.sharedInstance()?.reloadMessage(user: friend, callback: { (error) in
			if error != nil {
				print(error as Any)
				return
			}
			
			self.messages = MessageManager.sharedInstance()?.messages(user: self.friend)
			
			self.tableCells.removeAllObjects()
			for message in self.messages {
				let cell = ChatSingleMessageCell.create(message as? PFObject)
				self.tableCells.add(cell)
			}
			
			self.tableView.reloadData()
			if (self.messages.count > 0) {
				self.tableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: true)
			}
		})
	}
}


extension ChatSingleVC : UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let cell = self.tableCells![indexPath.row] as! ChatSingleMessageCell
		print(cell.height())
		return cell.height()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.tableCells.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return self.tableCells![indexPath.row] as! UITableViewCell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}
}

extension ChatSingleVC : UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == contentTextField {
			let content = contentTextField.text
			MessageManager.sharedInstance()?.sendMessage(self.friend!, content: content, callback: { (error: Any?) in
				if error != nil {
					print(error as Any)
					return
				}
				
				self.messages = MessageManager.sharedInstance()?.messages(user: self.friend)
				
				let cell = ChatSingleMessageCell.create(self.messages!.lastObject as? PFObject)
				self.tableCells.add(cell)
				
				self.tableView.reloadData()
			})
			
			contentTextField.text = ""
		}
		
		return true
	}
}
