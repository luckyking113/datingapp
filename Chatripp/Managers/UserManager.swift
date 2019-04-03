//
//  UserManager.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/24.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation
import UIKit
import Parse

public class UserManager {
    
    static let sharedInstance : UserManager = {
        
        let instance = UserManager()
        return instance
    }()

    var user : PFUser?
    var profile : PFObject?
    var allUsers : [UserModal] = []
    
    init() {
        
        if let user = PFUser.current() {
            self.user = user
            loadDBData()
        }
    }
    
    func initWithPFUser(pfUser : PFUser){
        
        self.user = pfUser
        self.user!.saveInBackground()
        
        loadDBData()
    }
    
    func loadDBData() {
        
        if user == nil { return }
        self.loadProfile(user: user!, nil)
        PostsManager.sharedInstance.loadMyPosts()
        TripsManager.sharedInstance.loadMyTrips()
        PhotoSetsManager.sharedInstance.loadAllPhotoSets()
    }
    
    func loadProfile(user : PFUser, _ completion : (() -> Void)?) {
     
        let query = PFQuery(className: DBNames.profile)
        query.whereKey(DBNames.profile_userObjId, equalTo: user.objectId!)
        query.limit = 1
        query.getFirstObjectInBackground { (obj, error) in
            
            if let obj = obj {
                self.profile = obj
            }
            
            if (completion != nil) {
                completion!()
            }
        }
    }
    
    func getUserFullname() -> String {
        if profile == nil {
            return ""
        }
        let firstName = profile![DBNames.profile_firstname] as? String ?? ""
        let lastName  = profile![DBNames.profile_lastname] as? String ?? ""
        return "\(firstName) \(lastName)"
    }
    
    func saveProfile(completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {

        if self.profile != nil{
            self.profile!.saveInBackground { (success, error) in
                completion(success, error)
            }
        } else {
            completion(false, nil)
        }
    }
    
    func getUserLocation() -> LocationModal {
        
        return profile == nil ? LocationModal() : LocationModal(withPFObj: self.profile!)
    }

    func getAllUsers(completion: @escaping (_ isSuccess: Bool, _ result: [UserModal]? ) -> Void) {
        
        let query = PFQuery(className: DBNames.profile)
        query.whereKey(DBNames.profile_userObjId, notEqualTo: self.user!.objectId!)
        query.limit = 100
        query.findObjectsInBackground { (objs, error) in
            
            if let error = error {
                print("Server error : \(error)")
                completion(false, nil)
            } else {
                if let objs = objs {
                    
                    var users : [UserModal] = []
                    for obj in objs {
                        users.append(UserModal(with: obj))
                    }
                    completion(true, users)
                } else {
                    completion(true, [])
                }
            }
        }
    }
}
