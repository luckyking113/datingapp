//
//  TripsManager.swift
//  Chatripp
//
//  Created by Famousming on 2019/02/26.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation
import Parse

public class TripsManager {
    
    static let sharedInstance : TripsManager = {
        
        let instance = TripsManager()
        return instance
    }()
    
    var myTrips = [Trip]()
    var userObjId = ""
    
    init() {
        
        if let user = PFUser.current() {
            self.userObjId = user.objectId!
        }
    }
    
    func loadMyTrips() {
        
        self.getTripsFromServer(userObjID: userObjId) { (success, objs) in

            if success {

                if let tripObjs = objs {
                    self.myTrips = []
                    for obj in tripObjs {
                        self.myTrips.append(Trip.create(obj))
                    }
                } else {
                    self.myTrips = []
                }
            }
        }
    }
    
    func getTripsFromServer(userObjID : String, completion: @escaping (_ isSuccess: Bool, _ result: [PFObject]?) -> Void){
        
        let query = PFQuery(className: DBNames.trips)
        query.whereKey(DBNames.trips_userObjId, equalTo: userObjID)
        query.order(byAscending: DBNames.trips_leavingDate)
        query.findObjectsInBackground { (results, error) in
            
            if let error = error {
                print("Local storage error : \(error)")
                completion(false, nil)
            } else {
                completion(true, results)
            }
        }
    }
    
    func createNewTrip(obj : PFObject, completion : @escaping (_ isSuccess: Bool, _ error: Error?)->Void ) {
        
        obj.saveInBackground { (success, error) in
            
            if success {
                self.myTrips.append(Trip.create(obj))
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func deleteTrip(trip: Trip , completion : @escaping(_ isSuccess: Bool, _ error: Error?)->Void ){
        
		if !trip.objectId()!.isEmpty {
            
            let query = PFQuery(className: DBNames.trips)
			query.getObjectInBackground(withId: trip.objectId()!) { (obj, error) in
                
                if error != nil {
                    completion(false,error)
                } else {
                    if let obj = obj {
                        obj.deleteInBackground(block: { (success, error) in
                            if success {
                                self.myTrips.removeAll(where: { (one) -> Bool in
                                    return one.objectId() == trip.objectId()
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
