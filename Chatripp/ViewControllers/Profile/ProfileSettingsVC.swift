//
//  ProfileSettingsVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/31.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse

class ProfileSettingsVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgAvatar: PFImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var switchPrivate: UISwitch!
    @IBOutlet weak var switchRestrict: UISwitch!
	@IBOutlet weak var bithdayLabel: UILabel!
	@IBOutlet weak var nationalityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
 
    override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
        self.loadData()
    }
    
    func loadData() {
        
        self.imgAvatar.image = Helper.thumbnailImage()
        
        if let profile = UserManager.sharedInstance.profile {

            if let avatar = profile.avatar() as? PFFileObject {
                self.imgAvatar.file = avatar
                self.imgAvatar.loadInBackground()
            }
			
            self.lblName.text = UserManager.sharedInstance.profile?.fullName()
			self.switchPrivate.isOn = profile.isPrivate()!
			self.switchRestrict.isOn = profile.isRestrictFollow()!
			
			self.bithdayLabel.text = profile.birthday()
			self.nationalityLabel.text = profile.nationality()
		}
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.goBackVC()
    }
    
    @IBAction func clickEdit(_ sender: Any) {
        
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileEditVC") as! ProfileEditVC
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func makePrivate(_ sender: UISwitch) {
        
        if let profile = UserManager.sharedInstance.profile {
            profile.setIsPrivate(sender.isOn)
            profile.saveInBackground()
        }
    }
    
    @IBAction func restrictFollower(_ sender: UISwitch) {
        if let profile = UserManager.sharedInstance.profile {
            profile.setIsRestrictFollow(sender.isOn)
            profile.saveInBackground()
        }
    }
}
