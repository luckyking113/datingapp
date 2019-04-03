//
//  ChatHomeVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/31.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery

class ChatHomeVC: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mTableView.dataSource = self
        self.mTableView.delegate = self
        
        loadFriends()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBAction func clickAddNew(_ sender: Any) {
        
    }
	
	func loadFriends() {
		Helper.showLoading(target: self)
		MessageManager.sharedInstance()?.loadFriends(callback: { (error:Any?) in
			Helper.hideLoading(target: self)
			
			if error != nil {
				print(error!)
				return
			}
			
			self.mTableView.reloadData()
		})
	}
}

extension ChatHomeVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return MessageManager.sharedInstance()?.friends.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell = tableView.dequeueReusableCell(withIdentifier: "ChatHomeTableViewCell", for: indexPath) as! ChatHomeTableViewCell
		
		let profile = MessageManager.sharedInstance()?.profiles[indexPath.row] as! PFObject
		
        chatCell.imgAvatar.image = UIImage(named: "img_sample_avatar\(indexPath.row % 2)")
		chatCell.lblName.text = String(format: "%@ %@", profile["first_name"] as! String, profile["last_name"] as! String)
        chatCell.lblLastMsg.text = "Are ou there? test \(indexPath.row)"
        chatCell.lblLastTime.text = "1\(indexPath.row):30"
		
        return chatCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let friend = MessageManager.sharedInstance()?.friends[indexPath.row] as! PFUser
		let profile = MessageManager.sharedInstance()?.profiles[indexPath.row] as! PFObject
		
		let chatSingleVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatSingleVC") as! ChatSingleVC
		chatSingleVC.friend = friend
		chatSingleVC.profile = profile
		self.navigationController?.pushViewController(chatSingleVC, animated: true)
    }
}
