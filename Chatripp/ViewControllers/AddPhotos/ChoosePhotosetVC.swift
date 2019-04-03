//
//  ChoosePhotosetVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/03/05.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse

class ChoosePhotosetVC: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    var photoSets = [PFObject]()
    var addPhotoVCdelegate : GetPhotosVCDelegate?
    @IBOutlet weak var viewAddNew: UIView!
    @IBOutlet weak var txtPhotoSetName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mTableView.register(UINib(nibName: "TableCellNoData", bundle: nil), forCellReuseIdentifier: "TableCellNoData")
        self.mTableView.delegate = self
        self.mTableView.dataSource = self
        viewAddNew.isHidden = true
        
        photoSets = PhotoSetsManager.sharedInstance.photoSets
        self.mTableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBAction func clickCreate(_ sender: UIButton) {
        
        if txtPhotoSetName.text == "" {
            Helper.showAlert(target: self, title: "", message: "Please input new Photoset name")
        } else {
            
            self.txtPhotoSetName.endEditing(true)
            let obj = PFObject(className: DBNames.photoSets)
            obj[DBNames.photoSets_setname] = txtPhotoSetName.text
            obj[DBNames.photoSets_userObjId] = UserManager.sharedInstance.user?.objectId
            
            Helper.showLoading(target: self)
            PhotoSetsManager.sharedInstance.createNewPhotoSet(obj: obj) { (success, error) in
                Helper.hideLoading(target: self)
                if success {
                    self.photoSets = PhotoSetsManager.sharedInstance.photoSets
                    self.mTableView.reloadData()
                    self.viewAddNew.isHidden = true
                    self.txtPhotoSetName.text = ""
                }
            }
        }
    }
    
    @IBAction func clickBack(_ sender: UIButton) {
        self.goBackVC()
    }
    
    @IBAction func clickAdd(_ sender: UIButton) {
        
        self.viewAddNew.isHidden = false
    }
}

extension ChoosePhotosetVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoSets.count == 0 ? 1 : photoSets.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return photoSets.count > 0 ? 60 : 200
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if photoSets.count > 0 {
            let setCell = tableView.dequeueReusableCell(withIdentifier: "ChoosePhotoSetCell", for: indexPath) as! ChoosePhotoSetCell
            setCell.setData(obj: photoSets[indexPath.row])
            return setCell
            
        } else {
            let noTripCell = tableView.dequeueReusableCell(withIdentifier: "TableCellNoData", for: indexPath) as! TableCellNoData
            noTripCell.imgIcon.image = UIImage(named: "ic_photoset")
            noTripCell.lblTitle.text = "no_photosets_title".localized
            noTripCell.lblContent.text = "no_photosets_content".localized
            
            //            emptyCell.lblContent.text = "no_trips_coming".localized
            return noTripCell
        }
    }    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if photoSets.count > 0 {
            self.addPhotoVCdelegate?.setPhotoSet(obj: photoSets[indexPath.row])
            self.goBackVC()
        }
    }
}
