//
//  FBDatabaseManager.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 24/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import Foundation
import Firebase


struct FBDatabaseManager
{
    //MARK: -
    
    static var shared = FBDatabaseManager()
    
    private var refTrips    : DatabaseReference?
    private var refHandle   : DatabaseHandle?
}


// MARK:- User Database

extension FBDatabaseManager
{
    func doesUserExistInDatabase(_ email: String, complation: @escaping (_ result: Bool) -> ())
    {
        FBManager.shared.databaseReference("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { snapshot in
            complation(snapshot.exists())
        }
    }
    
    
    func addUser(parameters: RegisterRequest, complation: @escaping(_ errorMessage: String?)-> Void)
    {
        FBManager.shared.databaseReference("users").child(parameters.id).setValue(parameters.asDictionary, withCompletionBlock: { (error, reference) in
          
            guard error == nil else {
                complation(error?.localizedDescription)
                return
            }

            FBDatabaseManager.shared.getCurrentUserDetails { error in
                
                guard let error = error, !error.isEmpty else {
                    complation(nil)
                    return
                }
                
                complation(error)
            }
        })
    }
    
    
    func editUser(parameters: EditProfileRequest, complation: @escaping(_ result: Bool, _ errorMessage: String?) -> ())
    {
        SVProgressHUD.show()
        
        var requestParam = parameters

        if let imageData = parameters.image?.jpegData(compressionQuality: 0.5)
        {
            FBStorageManager.shared.uploadImage(type: .profileImage, imageData: imageData) { imageURL in
                
                guard let imageURL = imageURL else {
                    complation(false, "There was a problem, Please try again later!!!")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { SVProgressHUD.dismiss() })
                    return
                }
                
                requestParam.imageURL = imageURL
                
                updateCurrentUser(parameters: requestParam) { result, error in
                    complation(result, error)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { SVProgressHUD.dismiss() })
                }
            }
        }
        else
        {
            updateCurrentUser(parameters: requestParam) { result, error in
                complation(result, error)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { SVProgressHUD.dismiss() })
            }
        }
    }

    
    private func updateCurrentUser(parameters: EditProfileRequest, complation: @escaping(_ result: Bool, _ errorMessage: String?) -> ())
    {
        guard let user = FBAuthenticationManager.shared.authUser else {
            complation(false, "Unable to update user's profile. Please try to login into the application again")
            return
        }
        
        let referencePath = "users/" + user.uid
        
        FBManager.shared.databaseReference(referencePath).updateChildValues(parameters.asDictionary) { (error, reference) in
            
            guard error == nil else {
                complation(false, error?.localizedDescription)
                return
            }
            
            FBDatabaseManager.shared.getCurrentUserDetails { error in
                
                guard let error = error, !error.isEmpty else {
                    FBManager.shared.databaseReference(referencePath + "/meta").updateChildValues(["updatedAt": Date().timeIntervalSince1970])
                    complation(true, nil)
                    return
                }
                
                complation(false, error)
            }            
        }
    }
    
    

    func getCurrentUserDetails(_ complation: @escaping (_ errorMessage: String?) -> ())
    {
        guard let user = FBAuthenticationManager.shared.authUser else {
            complation("Unable to get current user. Please try to login into the application again")
            return
        }
        
        self.getUserDetails(for: user.uid) { result, errorMessage in
            
            guard let user = result else {
                complation(errorMessage)
                return
            }
            
            Defaults.shared.setCurrentUser(user, forKey: Default.user)
            complation(nil)
        }
    }
    
    
    func getUserDetails(for uid: String, complation: @escaping(_ result: Usert?, _ errorMessage: String?) -> ())
    {
        let referencePath = "users/" + uid
        
        FBManager.shared.databaseReference(referencePath).observeSingleEvent(of: .value) { snapshot in
            
            guard snapshot.exists() else {
                complation(nil, "The user is not exist")
                return
            }
            
            let user = Usert(snapshot: snapshot)
            complation(user, nil)
        }
    }
    
    
    func updateUserStatus(isOnline: Bool)
    {
        guard let uid = FBAuthenticationManager.shared.authUser?.uid else { return }
        let referencePath = "users/" + uid

        if isOnline {
            FBManager.shared.databaseReference(referencePath).updateChildValues(["status": true])
            FBManager.shared.databaseReference(referencePath).child("lastOnlineDate").removeValue()
        } else {
            FBManager.shared.databaseReference(referencePath).updateChildValues(["status": false, "lastOnlineDate": Date().timeIntervalSince1970])
        }
    }
}


// MARK:- Trips Database

extension FBDatabaseManager
{
    func addTrip(tripData: TripRequest, complation: @escaping(_ errorMessage: String?)-> Void)
    {
        guard let user = FBAuthenticationManager.shared.authUser else {
            complation("Unable to get current user. Please try to login into the application again")
            return
        }
        
        let timestamp   = Date().timeIntervalSince1970
        let tripInfo    = tripData.asDictionary
        
        var trip = Dictionary<String, Any>()
        trip["details"] = tripInfo
        trip["meta"] = ["createdAt": timestamp, "creator": user.uid]
        
        FBManager.shared.databaseReference("trips").childByAutoId().setValue(trip, withCompletionBlock: { (error, reference) in
          
            guard error == nil else {
                complation(error?.localizedDescription)
                return
            }

            complation(nil)
        })
    }
    
    
    func editTrip(tripID: String, tripData: TripRequest, complation: @escaping(_ errorMessage: String?)-> Void)
    {
        let tripInfo    = tripData.asDictionary
        
        var trip = Dictionary<String, Any>()
        trip["details"] = tripInfo
        
        let referencePath = "trips/" + tripID
        
        FBManager.shared.databaseReference(referencePath).updateChildValues(trip) { (error, reference) in
            
            guard error == nil else {
                complation(error?.localizedDescription)
                return
            }
            
            FBManager.shared.databaseReference(referencePath + "/meta").updateChildValues(["updatedAt": Date().timeIntervalSince1970])

            complation(nil)
        }
    }
        
    
    func deleteTrip(tripID: String, arrPhotos: [String], complation: @escaping(_ errorMessage: String?)-> Void)
    {
        let referencePath = "trips/" + tripID
        
        FBManager.shared.databaseReference(referencePath).removeValue { (error, reference) in
            
            guard error == nil else {
                complation(error?.localizedDescription)
                return
            }
            
            arrPhotos.forEach { imageURL in
                let storageRef = Storage.storage().reference(forURL: imageURL)
                storageRef.delete(completion: nil)
            }
            
            complation(nil)
        }
    }
    
    
    mutating func getTrips(complation: @escaping(_ snapshot: DataSnapshot?)-> Void)
    {
        guard let user = FBAuthenticationManager.shared.authUser else {
            print("Unable to get current user. Please try to login into the application again")
            complation(nil)
            return
        }
        
        let referencePath = "trips"
        self.refTrips = FBManager.shared.databaseReference(referencePath)
        
        self.refHandle = self.refTrips?.queryOrdered(byChild: "meta/creator").queryEqual(toValue: user.uid).observe(.value, with: { snapshot in
            complation(snapshot.exists() ? snapshot : nil)
        }) { (error) in
            print("\(error.localizedDescription)")
            complation(nil)
        }
    }
    
    
    func removeTripsObserver()
    {
        guard let refeHandle = self.refHandle else { return }
        self.refTrips?.removeObserver(withHandle: refeHandle)
    }
}
