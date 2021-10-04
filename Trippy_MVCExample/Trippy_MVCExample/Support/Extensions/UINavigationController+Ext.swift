//
//  UINavigationController+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit


extension UINavigationController
{
    
    func containsViewController(ofKind kind: AnyClass) -> Bool
    {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
    
    func popToVC(ofKind kind: AnyClass, pushController: UIViewController)
    {
        if containsViewController(ofKind: kind)
        {
            for controller in self.viewControllers
            {
                if controller.isKind(of: kind)
                {
                    popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    
    /*
     func popPushToVC(ofKind kind: AnyClass, pushController: UIViewController)
     {
     if containsViewController(ofKind: kind)
     {
     for controller in self.viewControllers
     {
     if controller.isKind(of: kind)
     {
     popToViewController(controller, animated: true)
     break
     }
     }
     }
     else
     {
     pushViewController(pushController, animated: true)
     }
     }
     */
    
}
