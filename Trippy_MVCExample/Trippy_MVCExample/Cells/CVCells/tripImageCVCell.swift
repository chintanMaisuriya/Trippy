//
//  tripImageCVCell.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit

class tripImageCVCell: UICollectionViewCell
{
    //MARK:  -
    var btnDeleteclick: ((_ aCell: tripImageCVCell) -> Void)?
    
    //MARK: -
    
    @IBOutlet weak var ivTripImageOutlet            : UIImageViewX!
    @IBOutlet weak var viewAddImageIndicatorOutlet  : UIViewX!
    
    //MARK: -
    
    @IBAction func btnDeleteAction(_ sender: UIButton)
    {
        if ((self.btnDeleteclick) != nil)
        {
            self.btnDeleteclick!(self)
        }
    }
    
}
