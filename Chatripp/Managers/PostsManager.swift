//
//  PostsManager.swift
//  Chatripp
//
//  Created by Famousming on 2019/02/08.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation
import Parse

public class PostsManager {
    
    static let sharedInstance : PostsManager = {
        
        let instance = PostsManager()
        return instance
    }()
    
    var myposts = [PFObject]()
    var userObjId = ""
    
    init() {
        
        if let user = PFUser.current() {
            self.userObjId = user.objectId!
        }
    }
    
    func loadMyPosts() {
        
        self.getPostsFromServer(userObjID: userObjId) { (success, objs) in
            if success {
                self.myposts = objs ?? []
            }
        }
    }
    
    func getPostsFromLocalDB(userObjID : String , completion: @escaping (_ isSuccess: Bool, _ result: [PFObject]?) -> Void){
        
        let query = PFQuery(className: DBNames.posts)
        query.fromLocalDatastore()
        query.whereKey(DBNames.posts_userObjId, equalTo: userObjID)
        query.findObjectsInBackground { (results, error) in

            if let error = error {
                print("Local storage error : \(error)")
                completion(false, nil)
                
            } else {
                
                completion(true, results)
            }
        }
    }
    
    func getPostsFromServer(userObjID : String, completion: @escaping (_ isSuccess: Bool, _ result: [PFObject]?) -> Void){
        
        let query = PFQuery(className: DBNames.posts)
        query.whereKey(DBNames.posts_userObjId, equalTo: userObjID)
        query.order(byAscending: DBNames.posts_date)
        query.findObjectsInBackground { (results, error) in
            
            if let error = error {
                print("Local storage error : \(error)")
                completion(false, nil)
            } else {
                completion(true, results)
            }
        }
    }
    
    func createNewPost(obj : PFObject, completion : @escaping (_ isSuccess: Bool, _ error: Error?)->Void ) {
        
        obj.saveInBackground { (success, error) in
            if success {
                self.myposts.append(obj)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func getGroupedPost() -> [String:[PFObject]] {
        
        var groupedArray = [String:[PFObject]]()
        for post in self.myposts {
            
            let cityName = post[DBNames.posts_photoSetId] as? String ?? "empty"

            if groupedArray[cityName] != nil {

            } else {
                groupedArray[cityName] = [PFObject]()
            }
            groupedArray[cityName]?.append(post)
        }
        
        return groupedArray
    }
    
    func getGroupedPost(withPFObjs : [PFObject]) -> [String:[PFObject]] {
        
        var groupedArray = [String:[PFObject]]()
        for post in withPFObjs {
            
            let cityName = post[DBNames.posts_photoSetId] as? String ?? "empty"
            
            if groupedArray[cityName] != nil {
                
            } else {
                groupedArray[cityName] = [PFObject]()
            }
            groupedArray[cityName]?.append(post)
        }
        
        return groupedArray
    }
    
    func removePosts(with locationName : String, completion : @escaping (_ isSuccess: Bool, _ error: Error?)->Void) {
        
        if !locationName.isEmpty {
            
            let query = PFQuery(className: DBNames.posts)
            query.whereKey(DBNames.posts_location, equalTo: locationName)
            query.findObjectsInBackground() { (objs, error) in
                
                if error != nil {
                    completion(false,error)
                } else {
                    if let objs = objs {

                        PFObject.deleteAll(inBackground: objs, block: { (success, error) in
                            if success {
                                self.myposts.removeAll(where: { (pfObj) -> Bool in
                                    let location = pfObj[DBNames.posts_location] as? String ?? ""
                                    return location == locationName
                                })
                            }
                            completion(success,error)
                        })
                        
                    }
                }
            }
        } else {
            completion(false,nil)
        }
    }
}
