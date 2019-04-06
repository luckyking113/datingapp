//
//  TripHomeTableViewCell.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/31.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse

class TripHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCity: PFImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    
    @IBOutlet weak var viewSchedule: UIView!
    @IBOutlet weak var lblDateLeave: UILabel!
    @IBOutlet weak var lblDateArrive: UILabel!
    
    var trip : Trip!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgCity.addOverlay(opacity: 0.2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTrip(_ trip : Trip) {		
		let isNew = trip.isNew()
		
        self.trip = trip
        self.lblCity.text = trip.city()!
        self.lblCountry.text = trip.country()!
        self.viewSchedule.isHidden = isNew
        
        if !isNew {
			self.lblDateArrive.text = self.trip.arrivingDate()?.toString(withFormat: Constants.dateFormatDM)
            self.lblDateLeave.text = self.trip.leavingDate()?.toString(withFormat: Constants.dateFormatDM)
		} else {
			self.lblDateArrive.text = ""
			self.lblDateLeave.text = ""
		}
		
		if let landscapeFile = self.trip.landscape() as? PFFileObject {
			self.imgCity.file = landscapeFile
			self.imgCity.loadInBackground()
		}
    }
}
