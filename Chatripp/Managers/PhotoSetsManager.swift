//
//  PhotoSetsManager.swift
//  Chatripp
//
//  Created by Famousming on 2019/03/05.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation
import Parse

public class PhotoSetsManager {
    
    static let sharedInstance : PhotoSetsManager = {
        
        let instance = PhotoSetsManager()
        return instance
    }()
    
    var photoSets = [PFObject]()
    
    init() {
        
    }
    
    func loadAllPhotoSets() {
        
        self.getPhotoSetsFromServer() { (success, objs) in
            if success {
                if let objs = objs{
                    self.photoSets = objs
                }
            }
        }
    }
    
    func getPhotoSetsFromServer( completion: @escaping (_ isSuccess: Bool, _ result: [PFObject]?) -> Void){
        
        let query = PFQuery(className: DBNames.photoSets)
        query.order(byAscending: DBNames.photoSets_setname)
        query.findObjectsInBackground { (results, error) in
            
            if let error = error {
                print("Local storage error : \(error)")
                completion(false, nil)
            } else {
                completion(true, results)
            }
        }
    }
    
    func createNewPhotoSet(obj : PFObject, completion : @escaping (_ isSuccess: Bool, _ error: Error?)->Void ) {
        
        obj.saveInBackground { (success, error) in
            if success {
                
                self.getPhotoSetsFromServer() { (success, objs) in
                    if success {
                        if let objs = objs{
                            self.photoSets = objs
                        }
                        completion(true, nil)
                    } else {
                        completion(false, nil)
                    }
                }
                
            } else {
                completion(false, error)
            }
        }
    }
    
    func getPhotoSetNameWith(objId : String) -> String {
        
        if objId.isEmpty {
            return "No set name"
        }
        
        let sets = photoSets.filter { (obj) -> Bool in
            return obj.objectId == objId
        }
        
        return sets.count > 0 ? sets.first![DBNames.photoSets_setname] as! String : "No set name"
    }
}
