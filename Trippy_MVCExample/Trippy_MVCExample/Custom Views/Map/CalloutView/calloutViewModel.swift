//
//  calloutViewModel.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 02/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit
import MapViewPlus

class calloutViewModel: CalloutViewModel
{
    var id      : String
    var title   : String
    var details : String
    var image   : String
    
    init(id: String, title: String, details: String, image: String)
    {
        self.id         = id
        self.title      = title
        self.details    = details
        self.image      = image
    }
    
    init(trip: Trip)
    {
        self.id         = trip.id
        self.title      = trip.title
        self.details    = "\(trip.address)\n\(trip.date)"
        self.image      = trip.images.first ?? ""
    }
}
