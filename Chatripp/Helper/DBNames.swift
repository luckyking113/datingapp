//
//  DBNames.swift
//  Chatripp
//
//  Created by Famousming on 2019/02/07.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation

public class DBNames {
    
    // Profile 
    static let profile = "Profile"
    static let profile_userObjId = "userObjId"
    static let profile_firstname = "first_name"
    static let profile_lastname = "last_name"
    static let profile_avatar = "avatar"
    static let profile_bio = "bio"
    static let profile_coverphoto = "cover_photo"
    static let profile_settingprivate = "setting_private"
    static let profile_restrictfollow = "restrict_follow"
    static let profile_city = "city"
    static let profile_country = "country"
    static let profile_formatted_address = "formatted_address"
    static let profile_latitude = "latitude"
    static let profile_longitude = "longitude"
    
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
}
