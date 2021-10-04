//
//  customCallOut.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 02/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit
import MapViewPlus
import SDWebImage

public protocol calloutViewDelegate: AnyObject
{
    func didTapped(forID id: String)
}

class customCallOut: UIView
{
    weak var calloutViewDelegate: calloutViewDelegate?
    
    private var tripID: String = ""
    
    @IBOutlet weak var lblTripTitleOutlet       : UILabelX!
    @IBOutlet weak var lblTripDetailsOutlet     : UILabelX!
    @IBOutlet weak var ivTripOutlet             : UIImageView!
    @IBOutlet weak var btnDetails               : UIButton!

    
    @IBAction func btnDetailsAction(_ sender: Any)
    {
        calloutViewDelegate?.didTapped(forID: tripID)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}


extension customCallOut: CalloutViewPlus
{
    func configureCallout(_ viewModel: CalloutViewModel)
    {
        guard  let viewModel = viewModel as? calloutViewModel else { return }

        self.tripID                 = viewModel.id
        lblTripTitleOutlet.text     = viewModel.title
        lblTripDetailsOutlet.text   = viewModel.details
        
        self.sd_imageIndicator = SDWebImageActivityIndicator.medium
        self.sd_imageIndicator?.startAnimatingIndicator()
        
        if let url = URL(string: viewModel.image)
        {
            ivTripOutlet.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "mtpPost"), options: .highPriority){ (image, error, cache, url) in
                self.sd_imageIndicator?.stopAnimatingIndicator()
            }
        }
    }
}
