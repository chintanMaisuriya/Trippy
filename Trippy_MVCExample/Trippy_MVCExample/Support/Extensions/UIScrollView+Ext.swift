//
//  UIScrollView+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit


extension UIScrollView
{
    var content_x: CGFloat
    {
        set(f) { contentOffset.x = f }
        get { return contentOffset.x }
    }
    
    var content_y: CGFloat
    {
        set(f) { contentOffset.y = f }
        get { return contentOffset.y }
    }
}
