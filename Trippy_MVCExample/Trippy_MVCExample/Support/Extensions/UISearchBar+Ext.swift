//
//  UISearchBar+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit


extension UISearchBar
{
    var textField: UITextField?
    {
        func findInView(_ view: UIView) -> UITextField?
        {
            for subview in view.subviews
            {
                if let textField = subview as? UITextField
                {
                    return textField
                }
                else if let v = findInView(subview)
                {
                    return v
                }
            }
            
            return nil
        }
        
        return findInView(self)
    }
}
