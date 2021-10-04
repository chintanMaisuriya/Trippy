//
//  MKMapView+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 04/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import UIKit
import MapKit


extension MKMapView
{
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 50000)
    {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
        
        DispatchQueue.main.async {
            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 20000)
            self.setCameraZoomRange(zoomRange, animated: true)
        }        
    }
}
