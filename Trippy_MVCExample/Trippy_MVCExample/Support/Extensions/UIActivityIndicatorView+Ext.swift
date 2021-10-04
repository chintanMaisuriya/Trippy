//
//  UIActivityIndicatorView+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit


extension UIActivityIndicatorView
{
    convenience init(activityIndicatorStyle: UIActivityIndicatorView.Style, color: UIColor, placeInTheCenterOf parentView: UIView)
    {
        self.init(style: activityIndicatorStyle)
        center = parentView.center
        self.color = color
        self.hidesWhenStopped = true
        parentView.addSubview(self)
    }
}
