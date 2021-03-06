//
//  DatabaseManager.swift
//  Uber-Clone
//
//  Created by Saad Sherif on 1/9/21.
//

import CoreLocation
import Firebase
import GeoFire

// MARK: - DatabaseRefs

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("Users")
let REF_DRIVER_LOCATIONS = DB_REF.child("diver-locations")
let REF_TRIPS = DB_REF.child("Trips")

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    public func insertNewUser(values: [String: Any], uid: String) {
        REF_USERS.child(uid).setValue(values) { (error, ref) in
            if let error = error {
                print("Failed to save data to realTime database with error \(error.localizedDescription)")
                return
            }
            print("Successfully saved data to database")
        }
    }
    
    func fetchUserData(uid: String, completion: @escaping(User) -> Void) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uId = snapshot.key
            let user = User(uid: uId, dicationary: dictionary)
            
            completion(user)
        }
    }
}
