//
//  UILabel+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit


extension UILabel
{
    func textDropShadow(color: UIColor , radius: CGFloat, opacity: Float)
    {
        self.layer.shadowColor   = color.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowRadius  = radius
        self.layer.shadowOpacity = opacity
        
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
