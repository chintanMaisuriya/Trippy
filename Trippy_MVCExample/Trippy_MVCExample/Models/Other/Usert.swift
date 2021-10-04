//
//  Usert.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 24/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import Foundation
import Firebase

//==================

struct Usert: Codable
{
    var id              : String?   = nil
    var name            : String?   = nil
    var email           : String?   = nil
    var imageURL        : String?   = nil
    var isOnline        : Bool?     = false
    var lastOnlineDate  : Double?   = nil
    
    private enum CodingKeys : String, CodingKey { case id, name, email, imageURL, isOnline, lastOnlineDate }

    internal init(id: String? = nil, name: String? = nil, email: String? = nil, imageURL: String? = nil, isOnline: Bool? = false, lastOnlineDate: Double? = nil)
    {
        self.id = id
        self.name = name
        self.email = email
        self.imageURL = imageURL
        self.isOnline = isOnline
        self.lastOnlineDate = lastOnlineDate
    }
    
    init(snapshot: DataSnapshot)
    {
        guard let snapshotValue = snapshot.value as? NSMutableDictionary else { return }
        
        self.id             = snapshotValue["id"] as? String    ?? nil
        self.name           = snapshotValue["name"] as? String  ?? nil
        self.email          = snapshotValue["email"] as? String ?? nil
        self.imageURL       = snapshotValue["imageURL"] as? String ?? nil
        self.isOnline       = snapshotValue["status"] as? Bool ?? false
        self.lastOnlineDate = snapshotValue["lastOnlineDate"] as? Double ?? nil
    }
    
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? nil
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? nil
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? nil
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL) ?? nil
        isOnline = try container.decodeIfPresent(Bool.self, forKey: .isOnline) ?? false
        lastOnlineDate = try container.decodeIfPresent(Double.self, forKey: .lastOnlineDate) ?? nil
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(isOnline, forKey: .isOnline)
        try container.encode(lastOnlineDate, forKey: .lastOnlineDate)
    }
}


//MARK: -

struct CurrentUser
{
    static let shared = CurrentUser()
    
    static var isLoggedIn: Bool { return Defaults.shared.getBool(forKey: Default.isLoggedIn) }
    
    static var userInfo     : Usert? { return Defaults.shared.getCurrentUser(forKey: Default.user) }
    static var id           : String? { return userInfo?.id ?? "" }
    static var name         : String? { return userInfo?.name ?? "" }
    static var email        : String? { return userInfo?.email ?? "" }
    static var imageURL     : String? { return userInfo?.imageURL ?? "" }
    
    static var image        : UIImage? {
        guard let url = URL(string: imageURL ?? "") else { return UIImage(named: "mtpUser") }
        guard let data = try? Data(contentsOf: url) else { return UIImage(named: "mtpUser") }
        return UIImage(data: data) ?? UIImage(named: "mtpUser")
    }
}

