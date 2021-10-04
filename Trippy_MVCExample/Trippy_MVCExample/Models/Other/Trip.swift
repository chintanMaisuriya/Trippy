//
//  Trip.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 02/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit
import Firebase

//==================

struct Trip
{
    var id                  : String   = ""
    var title              : String   = ""
    var date               : String   = ""
    var address            : String   = ""
    var latitude           : Double   = 0.00
    var longitude          : Double   = 0.00
    var images             : [String]   = []
    
    
    internal init(id: String = "", title: String = "", date: String = "", address: String = "", latitude: Double = 0.00, longitude: Double = 0.00, images: [String] = [])
    {
        self.id         = id
        self.title     = title
        self.date      = date
        self.address   = address
        self.latitude  = latitude
        self.longitude = longitude
        self.images    = images
    }
    
    
    init(snapshot: DataSnapshot?)
    {
        guard let snapshot = snapshot else { return }
        guard let snapshotValue = snapshot.value as? NSMutableDictionary else { return }
        guard let details       = snapshotValue["details"] as? NSMutableDictionary else { return }

        self.id = snapshot.key
        
        if let tTitle = (details["title"])
        {
            self.title = tTitle as? String ?? ""
        }
        
        if let tDate = (details["date"])
        {
            self.date = tDate as? String ?? ""
        }
        
        if let tAddress = (details["address"])
        {
            self.address = tAddress as? String ?? ""
        }
        
        if let tLatitude = (details["latitude"])
        {
            self.latitude = (tLatitude is NSNumber) ? (tLatitude as! NSNumber).doubleValue : 0.00
        }
        
        if let tLongitude = (details["longitude"])
        {
            self.longitude = (tLongitude is NSNumber) ? (tLongitude as! NSNumber).doubleValue : 0.00
        }
        
        if let tImages = (details["images"])
        {
            self.images = tImages as? [String] ?? []
        }
        
    }
    
    func toDictionary() -> NSMutableDictionary
    {
        return [
            "id"            : self.id,
            "title"        : self.title,
            "date"         : self.date,
            "address"      : self.address,
            "latitude"     : self.latitude,
            "longitude"    : self.longitude,
            "images"       : self.images
        ]
    }
}
