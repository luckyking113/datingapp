//
//  ChatHomeTableViewCell.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/31.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit

class ChatHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLastMsg: UILabel!
    @IBOutlet weak var lblLastTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
