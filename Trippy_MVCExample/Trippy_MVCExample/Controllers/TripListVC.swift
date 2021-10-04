//
//  TripListVC.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit
import SDWebImage

class TripListVC: UIViewController
{
    //MARK: -

    var cvOffsets = [Int: CGFloat]()
    
    //MARK: -

    @IBOutlet weak var tblTripsOutlet: UITableView!
    
    //MARK: -


    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tblTripsOutlet.tableFooterView = UIView()
    }
    
    //MARK: -

    /*
    // MARK: - Navigation
    */

}


//MARK: - UITableview

extension TripListVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (arrTrips.count == 0)
        {
            tableView.showNoDataLabel(Constant.placeholderNoTrip, isScrollable: true)
            return 0
        }
        else
        {
            tableView.removeNoDataLabel()
            return arrTrips.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        guard arrTrips.count > 0 else { return }
        let tripInfo = arrTrips[indexPath.row]
        
        guard let cell = cell as? tripTVCell else { return }
        
        if tripInfo.images.isEmpty
        {
            cell.cvImagesHeightConstant.constant = 0
            cvOffsets[indexPath.row] = 0
        }
        else
        {
            cell.cvImagesHeightConstant.constant = (tripInfo.images.count > 1) ? 44 : 0
            cell.setCollectionViewDataSourceDelegate(self, forTag: indexPath.row)
            cell.collectionViewOffset = cvOffsets[indexPath.row] ?? 0
        }
        
        cell.layoutIfNeeded()
        cell.layoutSubviews()
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        guard arrTrips.count > 0 else { return }
        guard cell is tripTVCell else { return }
        cvOffsets[indexPath.row] = 0
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard arrTrips.count > 0 else { return UITableViewCell() }
        let tripInfo = arrTrips[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tripTVCell") as? tripTVCell else { return UITableViewCell() }
        cell.configureCell(tripInfo: tripInfo)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard arrTrips.count > 0 else { return }
        self.displayUtityOptions(tripInfo: arrTrips[indexPath.row])
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        guard arrTrips.count > 0 else { return 0.0 }
        return (self.view.width * 0.846875)
    }
}



//MARK: - UICollectionview

extension TripListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard arrTrips.count > 0 else { return 0 }
        
        let tripInfo = arrTrips[collectionView.tag]
        return tripInfo.images.count > 1 ? (tripInfo.images.count - 1) : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard arrTrips.count > 0 else { return UICollectionViewCell() }
        let tripInfo = arrTrips[collectionView.tag]

        
        let cvCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tripImageCVCell", for: indexPath) as! tripImageCVCell
        cvCell.sd_imageIndicator = SDWebImageActivityIndicator.medium
        cvCell.sd_imageIndicator?.startAnimatingIndicator()
        
        if let url = URL(string: (tripInfo.images.count > 1) ? tripInfo.images[indexPath.item + 1] : "")
        {
            cvCell.ivTripImageOutlet.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "mtpPost"), options: .continueInBackground){ (image, error, cache, url) in
                cvCell.sd_imageIndicator?.stopAnimatingIndicator()
            }
        }
        
        return cvCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        guard arrTrips.count > 0 else { return .zero }
        let tripInfo = arrTrips[collectionView.tag]

        return (!(tripInfo.images.isEmpty) && (tripInfo.images.count > 1)) ? CGSize(width: 44.0, height: 44.0) : .zero
    }
    
}


//MARK: -

extension TripListVC
{
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
