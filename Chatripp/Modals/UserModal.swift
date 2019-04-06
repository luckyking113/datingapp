//
//  UserModal.swift
//  Chatripp
//
//  Created by Famousming on 2019/03/20.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation
import GooglePlaces
import Parse

class Profile {

    var objID = ""
    var userObjID = ""
    var first_name = ""
    var last_name = ""
    var avatar_url = ""
    var coverImg_url = ""
    var bio = ""
    var location = LocationModal()
    var isPrivate = false
    var isRestrictFollow = false
    
    init(){
        
    }
    
    init (with pfObj : PFObject){
        
        self.objID = pfObj.objectId ?? ""
        self.userObjID = pfObj[DBNames.profile_userObjId] as? String ?? ""
        self.first_name = pfObj[DBNames.profile_firstname] as? String ?? ""
        self.last_name = pfObj[DBNames.profile_lastname] as? String ?? ""
        
        if let avatar = pfObj[DBNames.profile_avatar] as? PFFileObject {
            self.avatar_url = avatar.url ?? ""
        }
        
        if let cover = pfObj[DBNames.profile_coverphoto] as? PFFileObject {
            self.coverImg_url = cover.url ?? ""
        }
        self.bio = pfObj[DBNames.profile_bio] as? String ?? ""
        self.location = LocationModal(withPFObj: pfObj)
        self.isPrivate = pfObj[DBNames.profile_settingprivate] as? Bool ?? true
        self.isRestrictFollow = pfObj[DBNames.profile_restrictfollow] as? Bool ?? true
    }
}
