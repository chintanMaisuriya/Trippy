//
//  HomeContainerVC.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit
import Firebase

var arrTrips  = [Trip]()

class HomeContainerVC: UIViewController
{
    
    //MARK: -
    
    private lazy var tripListVC: TripListVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "TripListVC") as! TripListVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var tripMapVC: TripMapVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "TripMapVC") as! TripMapVC
        self.add(asChildViewController: viewController)
        return viewController
    }()

    
    //MARK: -
    
    @IBOutlet weak var viewContainerOutlet  : UIView!
    @IBOutlet weak var btnTabUtilityOutlet  : UIButton!
    
    
    //MARK: -
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setTabSelected(sender: self.btnTabUtilityOutlet)
        SVProgressHUD.show()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.observerTrips()
    }
    
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        FBDatabaseManager.shared.removeTripsObserver()
    }
    
    
    //MARK: -
    
    @IBAction func btnTabUtilityAction(_ sender: UIButton)
    {
        self.setTabSelected(sender: sender)
    }
    
    
    @IBAction func btnAddAction(_ sender: UIButton)
    {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "AddTripVC") as? AddTripVC else { return }
        self.present(vc, animated: true, completion: nil)
    }

    
    
    /*
     // MARK: - Navigation
     */
    
}


//MARK:- Firebase Methods
//

extension HomeContainerVC
{
    func observerTrips()
    {
        FBDatabaseManager.shared.getTrips { [weak self] snapshot in
            
            SVProgressHUD.dismiss()
            
            guard let snapshot = snapshot else {
                arrTrips.removeAll()
                self?.reloadDataOnSelectedTab()
                return
            }
            
            let tempTrips = snapshot.children.map({ return Trip(snapshot: $0 as? DataSnapshot) })
           
            arrTrips.removeAll()
            arrTrips.append(contentsOf: tempTrips)
            self?.reloadDataOnSelectedTab()
        }
    }
}


//MARK: -

extension HomeContainerVC
{
    func reloadDataOnSelectedTab()
    {
        if (self.btnTabUtilityOutlet.isSelected)
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifyToReloadMap"), object: nil)
        }
        else
        {
            self.tripListVC.tblTripsOutlet.reloadData()
        }
    }
    
    
    func setTabSelected(sender: UIButton)
    {
        DispatchQueue.main.async {
            
            if (sender.isSelected)
            {
                self.btnTabUtilityOutlet.isSelected = false
                self.remove(asChildViewController: self.tripMapVC)
                self.add(asChildViewController: self.tripListVC)
            }
            else
            {
                self.btnTabUtilityOutlet.isSelected = true
                self.remove(asChildViewController: self.tripListVC)
                self.add(asChildViewController: self.tripMapVC)
            }
            
            self.reloadDataOnSelectedTab()
        }
    }
    
    
    private func add(asChildViewController viewController: UIViewController)
    {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        self.viewContainerOutlet.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = self.viewContainerOutlet.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    
    private func remove(asChildViewController viewController: UIViewController)
    {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
}
