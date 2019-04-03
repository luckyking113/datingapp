//
//  TripInviteTableViewCell.swift
//  Chatripp
//
//  Created by Famousming on 2019/02/01.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import SDWebImage

class TripInviteTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnMsg: UIButton!
    var data : UserModal!
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

    func setData(data: UserModal) {
        
        self.data = data
        
        if let avatarURL = URL(string: data.avatar_url) {
            DispatchQueue.main.async {
//                self.imgAvatar.sd_setImage(with: avatarURL, completed: nil)
                self.imgAvatar.sd_setImage(with: avatarURL, placeholderImage: Helper.thumbnailImage(), options: [], completed: nil)
            }
        } else {
            self.imgAvatar.image = Helper.thumbnailImage()
        }
        
        self.lblName.text = "\(data.first_name) \(data.last_name)"
        self.lblCity.text = "\(data.location.city) \(data.location.country)"
    }
    
    @IBAction func clickAdd(_ sender: Any) {
        
        isAdded = !isAdded
        self.btnAdd.setImage(UIImage(named: isAdded ? "ic_btn_check" : "ic_add"), for: .normal)
    }
}
