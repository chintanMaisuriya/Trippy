//
//  UITextField+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit


extension UITextField
{
    func setBottomLine(withColor color: UIColor, linewidth: CGFloat)
    {
        self.borderStyle      = UITextField.BorderStyle.none
        self.backgroundColor  = UIColor.clear
        let hwidth: CGFloat   = linewidth
        
        /*
         if let lineView = self.viewWithTag(10000)
         {
         lineView.removeFromSuperview()
         }
         */
        
        let borderLine = UIView(frame: CGRect(x: 0, y: self.frame.height - hwidth, width: self.frame.width, height: hwidth))
        //borderLine.tag = 10000
        borderLine.backgroundColor = color
        
        self.addSubview(borderLine)
    }
    
    func setBottomBorder(bkcolor: UIColor, underlineColor: UIColor, bHeight: CGFloat)
    {
        self.borderStyle = .none
        
        self.layer.backgroundColor = bkcolor.cgColor
        self.layer.masksToBounds   = false
        self.layer.shadowColor     = underlineColor.cgColor
        self.layer.shadowOffset    = CGSize(width: 0.0, height: bHeight)
        self.layer.shadowOpacity   = 1.0
        self.layer.shadowRadius    = 0.0
    }
    
    func setTextFieldAppearance(backgoundColor: UIColor, borderColor: UIColor, borderWidth: CGFloat, cornorRadius: CGFloat, shadowColor: UIColor, shadowOffset: CGSize, shadowRadius: CGFloat, shadowOpacity: Float )
    {
        
        //Basic texfield Setup
        self.borderStyle     = .none
        self.backgroundColor = backgoundColor // Use anycolor that give you a 2d look.
        
        //To apply corner radius
        self.layer.cornerRadius = cornorRadius
        
        //To apply border
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
        //To apply Shadow
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius  = shadowRadius
        self.layer.shadowOffset  = shadowOffset
        self.layer.shadowColor   = shadowColor.cgColor
        
        //To apply padding
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height))
        self.leftView     = paddingView
        self.leftViewMode = UITextField.ViewMode.always
        
        
    }
    
    func setRightPaddingToTextFields(paddingImageName: String) -> Void
    {
        self.rightViewMode = .always
        
        let paddingView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
        paddingView.image       = UIImage(named: paddingImageName)
        paddingView.contentMode = .center
        
        self.rightView    = paddingView
    }
    
}
