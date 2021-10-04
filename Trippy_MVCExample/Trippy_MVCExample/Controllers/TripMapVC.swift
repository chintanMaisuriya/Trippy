//
//  TripMapVC.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit
import MapViewPlus
import CoreLocation


class TripMapVC: UIViewController, CLLocationManagerDelegate
{
    //MARK: -
    
    let locationManager = CLLocationManager()
    weak var currentCalloutView: UIView?
    
    
    //MARK: -
    
    @IBOutlet weak var mapOutlet: MapViewPlus!
    
    
    //MARK: -
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialConfiguration()
    }
    
    
    //MARK: -
    
    /*
     // MARK: - Navigation
     */
    
}



//MARK: - Custom Annotation

extension TripMapVC: MapViewPlusDelegate
{
    func mapView(_ mapView: MapViewPlus, imageFor annotation: AnnotationPlus) -> UIImage
    {
        return UIImage(named: "mtPin")!
    }
    
    func mapView(_ mapView: MapViewPlus, calloutViewFor annotationView: AnnotationViewPlus) -> CalloutViewPlus{
        let calloutView = Bundle.main.loadNibNamed("customCallOut", owner: nil, options: nil)!.first as! customCallOut
        calloutView.calloutViewDelegate = self
        currentCalloutView              = calloutView
        return calloutView
    }
    
    // Optional
    func mapView(_ mapView: MapViewPlus, didAddAnnotations annotations: [AnnotationPlus])
    {
        mapView.showAnnotations(annotations, animated: true)
    }
}

extension TripMapVC: AnchorViewCustomizerDelegate
{
    func mapView(_ mapView: MapViewPlus, fillColorForAnchorOf calloutView: CalloutViewPlus) -> UIColor
    {
        return currentCalloutView?.backgroundColor ?? mapView.defaultFillColorForAnchors
    }
    
    func mapView(_ mapView: MapViewPlus, heightForAnchorOf calloutView: CalloutViewPlus) -> CGFloat
    {
        return 8
    }
}

extension TripMapVC: calloutViewDelegate
{
    func didTapped(forID id: String)
    {        
        guard arrTrips.count > 0 else { return }
        guard let index = arrTrips.firstIndex(where: { $0.id == id }) else { return }
        self.displayUtityOptions(tripInfo: arrTrips[index])
    }
}



//MARK: -

extension TripMapVC
{
    private func initialConfiguration()
    {
        self.mapOutlet.delegate                     = self
        self.mapOutlet.anchorViewCustomizerDelegate = self
        self.mapOutlet.showsUserLocation            = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setAnnotations), name: NSNotification.Name(rawValue: "notifyToReloadMap"), object: nil)
    }
    
    
    @objc func setAnnotations()
    {
        self.mapOutlet.removeAllAnnotations()
        guard arrTrips.count > 0 else { return }
        
        var annotations: [AnnotationPlus] = []
        
        for i in 0..<arrTrips.count
        {
            let tripInfo    = arrTrips[i]
            let model       = calloutViewModel(trip: tripInfo)
                
            annotations.append(AnnotationPlus.init(viewModel: model, coordinate: CLLocationCoordinate2D(latitude: tripInfo.latitude, longitude: tripInfo.longitude)))
        }
        
        self.mapOutlet.setup(withAnnotations: annotations)
    }
    
    
    private func displayUtityOptions(tripInfo: Trip)
    {
        let alert = UIAlertController(title: Application.displayName, message: "Would you like to?", preferredStyle: .actionSheet)
        
        let btnEdit = UIAlertAction(title: "Edit Trip", style: .default) { (_)-> Void in
            guard let vc = self.storyboard?.instantiateViewController(identifier: "AddTripVC") as? AddTripVC else { return }
            vc.editTripConfiguration(tripInfo: tripInfo)
            self.present(vc, animated: true, completion: nil)
        }
        
        let btnCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(btnEdit)
        alert.addAction(btnCancel)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
