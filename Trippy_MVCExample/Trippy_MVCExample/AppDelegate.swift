//
//  AppDelegate.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        
        //---
        
        Utils.setSVprogress()
        
        CBFlashyTabBar.appearance().tintColor       = UIColor(named: "Color_Text1")
        CBFlashyTabBar.appearance().barTintColor    = UIColor(named: "Color_Theme")
        
        //---
        
        /* To enable IQKeyboardManager */
        IQKeyboardManager.shared.enable                     = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarTintColor           = UIColor(named: "Color_Text1")
        //---
        
        FirebaseApp.configure()
        
        if CurrentUser.id == nil
        {
            FBAuthenticationManager.shared.signOut()
        }
        else
        {
            FBDatabaseManager.shared.updateUserStatus(isOnline: true)
        }

        //---
        
        sleep(1)
        return true
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


//MARK: -

extension AppDelegate
{
    func setLoginVC()
    {
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            
            guard let nvc = storyBoard.instantiateViewController(withIdentifier: "navLoginVC") as? UINavigationController else { return }
            nvc.isNavigationBarHidden = true
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
            sceneDelegate.window?.rootViewController = nil
            sceneDelegate.window?.rootViewController = nvc
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    
    func setMainTab()
    {
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let nvc = storyBoard.instantiateViewController(withIdentifier: "navTabVC") as? UINavigationController else { return }
                        
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
            sceneDelegate.window?.rootViewController = nil
            sceneDelegate.window?.rootViewController = nvc
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}


