//
//  ProfileVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/31.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse
enum ProfileTabType : Int {
    case PHOTOS
    case TRIPS
    case FOLLOWING
    case FOLLOWERS
}

class ProfileVC: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var viewFocus: UIView!
    @IBOutlet weak var viewTypes: UIView!
    @IBOutlet weak var imgCover: PFImageView!
    @IBOutlet weak var imgAvatar: PFImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblPhotos: UILabel!
    @IBOutlet weak var lblTrips: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    
    var photosGroup = [String:[PFObject]]()
    var photosGroupKeys = [String]()
    var tabType : ProfileTabType = .PHOTOS
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.mTableView.sizeHeaderToFit()
    }
    
    func setupView() {
        
        self.imgCover.addOverlay(opacity: 0.3)
        self.mTableView.delegate = self
        self.mTableView.dataSource = self
        
    }
    
    func loadData() {
        
        self.imgCover.image = Helper.thumbnailImage()
        self.imgAvatar.image = Helper.thumbnailImage()
        
        if let profile = UserManager.sharedInstance.profile {
            
            if let coverPhoto = profile.cover() as? PFFileObject {
                self.imgCover.file = coverPhoto
                self.imgCover.loadInBackground()
            }
            
            if let avatar = profile.avatar() as? PFFileObject {
                self.imgAvatar.file = avatar
                self.imgAvatar.loadInBackground()
            }
            
			self.lblBio.text = profile.bio() ?? "Unknown"
			self.lblCity.text = profile.city() ?? "Unknown"
            self.lblName.text = UserManager.sharedInstance.profile?.fullName()
        }
        
        
        self.lblTrips.text = "0"
        self.lblFollowing.text = "0"
        self.lblFollowers.text = "0"

        self.loadPhotos()
        self.mTableView.reloadData()
    }
    
    func loadPhotos() {
        
        self.lblPhotos.text = "\(PostsManager.sharedInstance.myposts.count)"
        self.photosGroup = PostsManager.sharedInstance.getGroupedPost()
        self.photosGroupKeys = Array(self.photosGroup.keys)
    }
    
    @IBAction func clickViewType(_ sender: UIButton) {
        
        let cPoint =  sender.convert(sender.center, to: viewTypes)
        let newPoint  = CGPoint(x: cPoint.x, y: self.viewFocus.center.y)
        UIView.animate(withDuration: 0.2) {
            self.viewFocus.center = newPoint
        }
        
        self.tabType = ProfileTabType(rawValue: sender.tag) ?? .PHOTOS
        self.mTableView.reloadData()
    }
    
    @IBAction func clickProfileSettings(_ sender: Any) {
        
        let profileSetVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileSettingsVC") as! ProfileSettingsVC
        self.navigationController?.pushViewController(profileSetVC, animated: true)
    }

}

extension ProfileVC : UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tabType == .PHOTOS ?  photosGroup.count : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let photoCell = tableView.dequeueReusableCell(withIdentifier: "ProfilePhotoTableViewCell", for: indexPath) as! ProfilePhotoTableViewCell
        photoCell.setData(objs: photosGroup[photosGroupKeys[indexPath.section]] ?? [])
        photoCell.delegate = self
        return photoCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 20
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.mTableView {
            if scrollView.contentOffset.y <= 0 {
                scrollView.contentOffset = CGPoint.zero
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let deleteAction = UITableViewRowAction(style: .default, title: "") { (action, indexPath) in
            
            let postGroup = self.photosGroup[self.photosGroupKeys[indexPath.section]] ?? []
            let location = postGroup.first?[DBNames.posts_location] as? String ?? ""
            if location.isEmpty { return }
            
            Helper.showLoading(target: self)
            PostsManager.sharedInstance.removePosts(with: location, completion: { (success, error) in
                Helper.hideLoading(target: self)
                
                if success {

                    self.loadPhotos()
                    self.mTableView.reloadData()
                    
                } else {
                    Helper.showAlert(target: self, title: "", message: error?.localizedDescription ?? "Please try again")
                }
            })

        }
//        deleteAction.backgroundColor = UIColor(patternImage: UIImage(named:"ic_delete")!)
        deleteAction.backgroundColor = Constants.colorRedLight
        
        return [deleteAction]
        
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            // Call edit action
            
            let postGroup = self.photosGroup[self.photosGroupKeys[indexPath.section]] ?? []
            let location = postGroup.first?[DBNames.posts_location] as? String ?? ""
            if location.isEmpty { return }
            
            Helper.showLoading(target: self)
            PostsManager.sharedInstance.removePosts(with: location, completion: { (success, error) in
                Helper.hideLoading(target: self)
                
                if success {
                    
                    self.loadPhotos()
                    self.mTableView.reloadData()
                    
                } else {
                    Helper.showAlert(target: self, title: "", message: error?.localizedDescription ?? "Please try again")
                }
            })
            
            // Reset state
            success(true)
        })
        deleteAction.image = UIImage(named: "ic_delete")
        deleteAction.backgroundColor = Constants.colorRedLight
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
}

extension ProfileVC : ProfilePhotoTableViewCellDelegate {

    func clickedPhoto(objs: [PFObject], index: Int) {
        
        let imgFullVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageFullscreenVC") as! ImageFullscreenVC
        imgFullVC.setImage(objs: objs, currentIndex: index)
        self.present(imgFullVC, animated: true, completion: nil)
    }
}
