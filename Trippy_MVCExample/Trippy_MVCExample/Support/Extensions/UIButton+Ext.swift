//
//  UIButton+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit


extension UIButton
{
    func setBottomBorder(bkcolor: UIColor, underlineColor: UIColor, fontColor : UIColor)
    {
        self.layer.backgroundColor  = bkcolor.cgColor
        self.layer.masksToBounds    = false
        self.layer.shadowColor      = underlineColor.cgColor
        self.layer.shadowOffset     = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity    = 1.0
        self.layer.shadowRadius     = 0.0
        self.setTitleColor(fontColor, for: .normal)
    }
    
    func setButtonStyle(text_color: UIColor)
    {
        self.layer.cornerRadius     = self.frame.size.height/2
        self.layer.borderWidth      = 1
        self.layer.borderColor      = text_color.cgColor
        self.backgroundColor        = UIColor.clear
        self.setTitleColor(text_color, for: .normal)
    }
    
    func setCornerRadius(radius: CGFloat)
    {
        self.layer.cornerRadius  = radius
        self.layer.masksToBounds = true
    }
    
}
