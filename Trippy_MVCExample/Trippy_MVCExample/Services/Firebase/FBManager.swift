//
//  FBManager.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 24/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import Foundation
import Firebase


class FBManager
{
    //MARK: -
    
    static let shared = FBManager()
    
    fileprivate let auth        = Auth.auth()
    fileprivate let database    = Database.database()
    fileprivate let storage     = Storage.storage()
    
    
    //MARK: -

    private init() {}
    
    
    func authReference() -> Auth
    {
        return auth
    }
    
    
    func databaseReference(_ path: String? = nil) -> DatabaseReference
    {
        guard let path = path else { return database.reference() }
        return database.reference().child(path)
    }
        
    
    func storageReference(_ path: String? = nil) -> StorageReference
    {
        guard let path = path else { return storage.reference() }
        return storage.reference().child(path)
    }
    
    
    func storageReferenceToDelete(_ urlString: String? = nil) -> StorageReference
    {
        guard let urlString = urlString else { return storage.reference() }
        return storage.reference(forURL: urlString)
    }
        
}
