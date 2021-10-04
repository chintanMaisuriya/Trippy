//
//  TripRequest.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 03/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import Foundation

struct TripRequest: Encodable
{
    var title       : String
    var date        : String
    var address     : String
    var latitude    : Float
    var longitude   : Float
    var images      : [String]

    
    internal init(title: String = "", date: String = "", address: String = "Unknown Location", latitude: Float = 00.0000000, longitude: Float = 00.0000000, images: [String] = [])
    {
        self.title = title
        self.date = date
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.images = images
    }
    
    
    var asDictionary : [String : Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }
}
