//
//  ProfilePhotoTableViewCell.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/31.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse

protocol ProfilePhotoTableViewCellDelegate {
    
    func clickedPhoto(objs: [PFObject], index : Int)
}

class ProfilePhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var mCollectionView: UICollectionView!
    var objs : [PFObject] = []
    
    @IBOutlet weak var lblPhotos: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    var delegate : ProfilePhotoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mCollectionView.register(UINib(nibName: "ProfilePhotoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProfilePhotoCollectionCell")
        
        self.mCollectionView.delegate = self
        self.mCollectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(objs: [PFObject]) {        
        self.objs = objs
        self.mCollectionView.reloadData()
        self.lblCity.text = PhotoSetsManager.sharedInstance.getPhotoSetNameWith(objId: objs.first?[DBNames.posts_photoSetId] as? String ?? "")
        self.lblPhotos.text = "\(objs.count) Photo\(objs.count > 1 ? "s" : "")"
    }
   
}

extension ProfilePhotoTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePhotoCollectionCell", for: indexPath) as! ProfilePhotoCollectionCell
        cell.setData(obj: objs[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.frame.size.width, height: 237)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegate?.clickedPhoto(objs: objs, index: indexPath.item)
    }
}
