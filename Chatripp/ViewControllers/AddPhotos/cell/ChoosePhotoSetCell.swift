//
//  ChoosePhotoSetCell.swift
//  Chatripp
//
//  Created by Famousming on 2019/03/05.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse

class ChoosePhotoSetCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(obj : PFObject){
        
        let title = obj[DBNames.photoSets_setname] as? String ?? ""
        self.lblTitle.text = title
        print("photo set objid : \(obj.objectId)")
    }

}
