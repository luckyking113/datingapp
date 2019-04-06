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
    var profile : Profile?
    var allUsers : [Profile] = []
    
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
        let query = PFQuery(className: Profile.className)
        query.whereKey(Profile.userId, equalTo: user.objectId!)
        query.limit = 1
        query.getFirstObjectInBackground { (obj, error) in
            if let obj = obj {
                self.profile = Profile.create(obj)
            }
            
            if (completion != nil) {
                completion!()
            }
        }
    }
	
    func saveProfile(completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {
        if self.profile != nil{
            self.profile?.object.saveInBackground { (success, error) in
                completion(success, error)
            }
        } else {
            completion(false, nil)
        }
    }

    func getAllUsers(completion: @escaping (_ isSuccess: Bool, _ result: [Profile]? ) -> Void) {
        let query = PFQuery(className: Profile.className)
        query.whereKey(Profile.userId, notEqualTo: self.user!.objectId!)
        query.limit = 100
        query.findObjectsInBackground { (objs, error) in
            
            if let error = error {
                print("Server error : \(error)")
                completion(false, nil)
            } else {
                if let objs = objs {
                    
                    var users : [Profile] = []
                    for obj in objs {
                        users.append(Profile.create(obj))
                    }
                    completion(true, users)
                } else {
                    completion(true, [])
                }
            }
        }
    }
}
