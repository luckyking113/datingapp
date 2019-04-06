//
//  OtherProfileVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/03/21.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse

class OtherProfileVC: UIViewController {
    
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
    
    @IBOutlet weak var btnAdd: UIButton!
    
    var isFollowed = false
    var photosGroup = [String:[PFObject]]()
    var photosGroupKeys = [String]()
    var tabType : ProfileTabType = .PHOTOS
    var opponent = Profile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupView()
        self.loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
		if let avatarFile = opponent.avatar() {
			self.imgAvatar.file = (avatarFile as! PFFileObject)
			imgAvatar.loadInBackground()
		} else {
			self.imgAvatar.image = Helper.thumbnailImage()
		}
		
		if let coverFile = opponent.cover() {
			self.imgCover.file = (coverFile as! PFFileObject)
			self.imgCover.loadInBackground()
		} else {
			self.imgCover.image = Helper.thumbnailImage()
		}
		
        self.lblBio.text = opponent.bio()
		if !opponent.country()!.isEmpty {
			self.lblCity.text = "\(opponent.city()!) , \(opponent.country()!)"
        } else {
            self.lblCity.text = "\(opponent.city()!)"
        }
        
        self.lblName.text = opponent.fullName()
        
        self.lblTrips.text = "0"
        self.lblFollowing.text = "0"
        self.lblFollowers.text = "0"
        
        self.loadPhotos()
        self.mTableView.reloadData()
    }
    
    func loadPhotos() {
        
        self.lblPhotos.text = "0"
        
        Helper.showLoading(target: self)
		PostsManager().getPostsFromServer(userObjID: opponent.userId()!) { (success, pfObjs) in            
            if success {
                
                self.photosGroup = PostsManager().getGroupedPost(withPFObjs: pfObjs ?? [])
                self.photosGroupKeys = Array(self.photosGroup.keys)
                
                self.lblPhotos.text = "\(pfObjs?.count ?? 0)"
                self.mTableView.reloadData()
            }
            
            Helper.hideLoading(target: self)
        }
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
        
        isFollowed = !isFollowed
        self.btnAdd.setImage(UIImage(named: isFollowed ? "ic_btn_check" : "ic_add"), for: .normal)
    }
    
    @IBAction func clckBack(_ sender: Any) {
        
        self.goBackVC()
    }
}

extension OtherProfileVC : UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate{
    
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
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//
//        let deleteAction = UITableViewRowAction(style: .default, title: "") { (action, indexPath) in
//
//            let postGroup = self.photosGroup[self.photosGroupKeys[indexPath.section]] ?? []
//            let location = postGroup.first?[DBNames.posts_location] as? String ?? ""
//            if location.isEmpty { return }
//
//            Helper.showLoading(target: self)
//            PostsManager.sharedInstance.removePosts(with: location, completion: { (success, error) in
//                Helper.hideLoading(target: self)
//
//                if success {
//
//                    self.loadPhotos()
//                    self.mTableView.reloadData()
//
//                } else {
//                    Helper.showAlert(target: self, title: "", message: error?.localizedDescription ?? "Please try again")
//                }
//            })
//
//        }
//        //        deleteAction.backgroundColor = UIColor(patternImage: UIImage(named:"ic_delete")!)
//        deleteAction.backgroundColor = Constants.colorRedLight
//
//        return [deleteAction]
//
//    }
//
//    @available(iOS 11.0, *)
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            // Call edit action
//
//            let postGroup = self.photosGroup[self.photosGroupKeys[indexPath.section]] ?? []
//            let location = postGroup.first?[DBNames.posts_location] as? String ?? ""
//            if location.isEmpty { return }
//
//            Helper.showLoading(target: self)
//            PostsManager.sharedInstance.removePosts(with: location, completion: { (success, error) in
//                Helper.hideLoading(target: self)
//
//                if success {
//
//                    self.loadPhotos()
//                    self.mTableView.reloadData()
//
//                } else {
//                    Helper.showAlert(target: self, title: "", message: error?.localizedDescription ?? "Please try again")
//                }
//            })
//
//            // Reset state
//            success(true)
//        })
//        deleteAction.image = UIImage(named: "ic_delete")
//        deleteAction.backgroundColor = Constants.colorRedLight
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//
//    }
}

extension OtherProfileVC : ProfilePhotoTableViewCellDelegate {
    
    func clickedPhoto(objs: [PFObject], index: Int) {
        
        let imgFullVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageFullscreenVC") as! ImageFullscreenVC
        imgFullVC.setImage(objs: objs, currentIndex: index)
        self.present(imgFullVC, animated: true, completion: nil)
    }
}

