//
//  DBNames.swift
//  Chatripp
//
//  Created by Famousming on 2019/02/07.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation

public class DBNames {
    //Posts
    static let posts = "Posts"
    static let posts_userObjId = "userObjId"
    static let posts_photo = "photo"
    static let posts_location = "location"
    static let posts_date = "posted_date"
    static let posts_photoSetId = "photoSetId"
    
    //Trips
    static let trips = "Trips"
    static let trips_userObjId = "userObjId"
    static let trips_arrivingDate = "arrivingDate"
    static let trips_leavingDate = "leavingDate"
    static let trips_city = "location_city"
    static let trips_country = "location_country"
    static let trips_isOriginalTrip = "isOriginalTrip"
    
    //PhotoSets
    static let photoSets = "PhotoSets"
    static let photoSets_setname = "set_name"
    static let photoSets_userObjId = "userObjId"
	
	/// Messages
	public class Messages {
		static let className = "Messages"
		static let senderId = "senderId"
		static let receiverId = "receiverId"
		static let content = "content"
		static let photo = "image"
	}
}
