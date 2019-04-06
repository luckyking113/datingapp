//
//  TripInviteTableViewCell.swift
//  Chatripp
//
//  Created by Famousming on 2019/02/01.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import SDWebImage
import Parse

class TripInviteTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: PFImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnMsg: UIButton!
    var data : Profile!
    var isAdded = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnAdd.setShadowToBottomOnly()
        btnMsg.setShadowToBottomOnly()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(data: Profile) {
        
        self.data = data
        
        if let avatarFile = data.avatar() as? PFFileObject {
			self.imgAvatar.file = avatarFile
			self.imgAvatar.loadInBackground()
        } else {
            self.imgAvatar.image = Helper.thumbnailImage()
        }
        
        self.lblName.text = data.fullName()
        self.lblCity.text = "\(data.city() ?? "") \(data.country() ?? "")"
    }
    
    @IBAction func clickAdd(_ sender: Any) {        
        isAdded = !isAdded
        self.btnAdd.setImage(UIImage(named: isAdded ? "ic_btn_check" : "ic_add"), for: .normal)
    }
}
