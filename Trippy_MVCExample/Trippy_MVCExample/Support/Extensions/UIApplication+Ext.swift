//
//  UIApplication+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit


extension UIApplication
{
    var keyWindowInConnectedScenes: UIWindow?
    {
        return windows.first(where: { $0.isKeyWindow })
    }
    
    var visibleViewController: UIViewController?
    {
        guard let rootViewController = keyWindowInConnectedScenes?.rootViewController else { return nil }
        return getVisibleViewController(rootViewController)
    }
    
    private func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController?
    {
        
        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }
        
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }
        
        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController
        }
        
        return rootViewController
    }
}
