//
//  ProfilePhotoCollectionCell.swift
//  Chatripp
//
//  Created by Famousming on 2019/02/20.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse
class ProfilePhotoCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgPhoto: PFImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgPhoto.addOverlay(opacity: 0.1)
    }

    func setData(obj : PFObject){
        
        self.imgPhoto.image = Helper.thumbnailImage()
        if let photo = obj[DBNames.posts_photo] as? PFFileObject {
            self.imgPhoto.file = photo
            self.imgPhoto.loadInBackground()
        }
    }
}
