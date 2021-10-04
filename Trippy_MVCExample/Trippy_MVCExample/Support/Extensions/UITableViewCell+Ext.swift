//
//  UITableViewCell+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit


extension UITableViewCell
{
    /// Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView?
    {
        get {
            var table: UIView? = superview
            
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            
            return table as? UITableView
        }
    }
    
    
    func changePressDownColor(to Color: UIColor)
    {
        let bgColorView = UIView()
        bgColorView.backgroundColor = Color
        self.selectedBackgroundView = bgColorView
    }
}
