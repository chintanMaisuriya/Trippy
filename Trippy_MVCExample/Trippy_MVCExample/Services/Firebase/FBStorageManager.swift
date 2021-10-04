//
//  FBStorageManager.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 25/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import Foundation
import Firebase


struct FBStorageManager
{
    //MARK: -
    
    static let shared = FBStorageManager()
}


// MARK:- User Database

extension FBStorageManager
{
    func uploadImage(type: StorageType, imageData: Data?, isShowLoader: Bool = false, completion: @escaping (_ url: String?) -> Void)
    {
        guard let data = imageData else { return completion(nil)}
        
        if isShowLoader { SVProgressHUD.show() }

        let storageRef = FBManager.shared.storageReference("images").child(type.rawValue).child("image_\(Date().dateString("yyyyMMdd_HHmmss")).jpeg")
        
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { SVProgressHUD.dismiss() })
            
            guard error == nil else {
                completion(nil)
                return
            }
            
            guard let metadata = metadata, let path = metadata.path, !path.isEmpty else {
                completion(nil)
                return
            }
            
            storageRef.downloadURL(completion: { (url, error) in
                
                guard error == nil else {
                    completion(nil)
                    return
                }
                
                guard let urlText = url?.absoluteString else {
                    completion(nil)
                    return
                }
                
                completion(urlText)
            })
        }
    }
    
    
    func deleteImage(url: String, completionHandler: @escaping(_ errorMessage: String?)-> Void)
    {
        FBManager.shared.storageReferenceToDelete(url).delete { error in
            
            guard error == nil else {
                completionHandler(error?.localizedDescription)
                return
            }
            
            completionHandler(nil)
        }
    }
}
