//
//  LocaltionModal.swift
//  Chatripp
//
//  Created by Famousming on 2019/02/14.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation
import GooglePlaces
import Parse

class LocationModal {
    
    var city = ""
    var country = ""
    var formattedAddress = ""
    var lat = ""
    var lon = ""
    
    init(){
        
    }
    
    init ( withPlace: GMSPlace ) {
        
        self.city = withPlace.addressComponents?.first(where: { $0.type == "locality" })?.name ?? ""
        self.country = withPlace.addressComponents?.first(where: { $0.type == "country" })?.name ?? ""
        self.formattedAddress = withPlace.formattedAddress ?? "'"
        self.lat = String(withPlace.coordinate.latitude)
        self.lon = String(withPlace.coordinate.longitude)
    }
    
    init (withPFObj : PFObject){
        
        self.city = withPFObj[DBNames.profile_city] as? String ?? ""
        self.country = withPFObj[DBNames.profile_country] as? String ?? ""
        self.formattedAddress = withPFObj[DBNames.profile_formatted_address] as? String ?? ""
        self.lat = withPFObj[DBNames.profile_latitude] as? String ?? ""
        self.lon = withPFObj[DBNames.profile_longitude] as? String ?? ""
    }
}
