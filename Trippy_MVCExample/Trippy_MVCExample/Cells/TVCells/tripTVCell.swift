//
//  tripTVCell.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit
import SDWebImage

class tripTVCell: UITableViewCell
{
    //MARK: -

    @IBOutlet weak var lblLocationOutlet        : UILabelX!
    @IBOutlet weak var lblTripTitleOutlet       : UILabelX!
    @IBOutlet weak var lblTripDetailsOutlet     : UILabelX!
    @IBOutlet weak var ivTripOutlet             : UIImageView!
    @IBOutlet weak var cvImagesOutlet           : UICollectionView!
    @IBOutlet weak var cvImagesHeightConstant: NSLayoutConstraint!
    
    //MARK: -

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

}

//MARK: - CollectionView Setup

extension tripTVCell
{
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forTag tag: Int)
    {
        cvImagesOutlet.delegate             = dataSourceDelegate
        cvImagesOutlet.dataSource           = dataSourceDelegate
        cvImagesOutlet.tag  = tag
        
        cvImagesOutlet.setContentOffset(cvImagesOutlet.contentOffset, animated:false) // Stops collection view if it was scrolling.
        cvImagesOutlet.reloadData()
        cvImagesOutlet.layoutIfNeeded()
        cvImagesOutlet.layoutSubviews()
        
        self.layoutIfNeeded()
    }
    
    var collectionViewOffset: CGFloat
    {
        set { cvImagesOutlet.contentOffset.x = newValue }
        get { return cvImagesOutlet.contentOffset.x }
    }
}


//MARK: -

extension tripTVCell
{
    func configureCell(tripInfo: Trip)
    {
        lblLocationOutlet.text      = tripInfo.address
        lblTripTitleOutlet.text     = tripInfo.title
        lblTripDetailsOutlet.text   = "\(tripInfo.address)\n\(tripInfo.date)"
        
        self.sd_imageIndicator = SDWebImageActivityIndicator.medium
        self.sd_imageIndicator?.startAnimatingIndicator()
        
        if let url = URL(string: tripInfo.images.first ?? "")
        {
            ivTripOutlet.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "mtpPost"), options: .highPriority){ [weak self] (image, error, cache, url) in
                self?.sd_imageIndicator?.stopAnimatingIndicator()
            }
        }
    }
}
