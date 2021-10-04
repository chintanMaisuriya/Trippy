//
//  FBAuthenticationManager.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 24/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import Foundation
import Firebase


class FBAuthenticationManager
{
    public static let shared = FBAuthenticationManager()
    
    var authUser : User? {
        FBManager.shared.authReference().currentUser?.reload()
        return FBManager.shared.authReference().currentUser
    }
    
    
    func doesMailVerified(_ complation: @escaping (_ result: Bool) -> ())
    {
        guard let fbUser = authUser, let email = fbUser.email else {
            complation(false)
            return
        }
        
        if fbUser.isEmailVerified
        {
            complation(true)
        }
        else
        {
            let actionCodeSettings =  ActionCodeSettings.init()
            actionCodeSettings.handleCodeInApp = true

            // This URL will be the deep link of the FDL. It is useful for
            // passing state back to your iOS app to let it know that you were
            // verifying a user of email user.email. This is also useful
            // in case the user clicks the continue button a non iOS device.
            // You should own this link.
            
            let strURL = String(format: "https://trippyverifyuser.page.link/verifyEmail")
            actionCodeSettings.url = URL(string: strURL)
                
            // This is your iOS app bundle ID. It will try to redirect to your
            // app via Firebase dynamic link.
            actionCodeSettings.setIOSBundleID(Application.bundleID)
            actionCodeSettings.dynamicLinkDomain = "trippyverifyuser.page.link"

            fbUser.sendEmailVerification(with: actionCodeSettings) { [weak self] error in
                
                guard error == nil else {
                    Utils.showToast(title: "Oops!", subtitle: "Unable to send verification mail. Please try to login again", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
                    self?.signOut()
                    complation(false)
                    return
                }
                
                Utils.showToast(title: "Caution", subtitle: "The verification mail has been sent to your email address. Please verify it and do login in the app again.", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
                complation(false)
            }
        }
    }
    
    
    func doesUserAleradyAuthorized(_ email: String, complation: @escaping (_ result: Bool) -> ())
    {
        FBManager.shared.authReference().fetchSignInMethods(forEmail: email) { result, error in
            
            guard error == nil else {
                complation(false)
                return
            }
            
            guard let result = result else {
                complation(false)
                return
            }
            
            complation(result.isEmpty)
        }
    }
    
    
    func signIn(parameters: LoginRequest, complation: @escaping(_ result: Bool, _ errorMessage: String?) -> ())
    {
        SVProgressHUD.show()
        
        let credential = EmailAuthProvider.credential(withEmail: parameters.email, password: parameters.password)
        
        FBManager.shared.authReference().signIn(with: credential) { result, error in
            
            guard error == nil else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { SVProgressHUD.dismiss() })
                complation(false, error?.localizedDescription)
                return
            }
            
            guard let _ = result?.user else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { SVProgressHUD.dismiss() })
                complation(false, "There was a problem, Please try again later")
                return
            }
            

            FBDatabaseManager.shared.getCurrentUserDetails { error in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { SVProgressHUD.dismiss() })
                
                guard let error = error, !error.isEmpty else {
                    FBDatabaseManager.shared.updateUserStatus(isOnline: true)

                    Defaults.shared.setBool(true, forKey: Default.isLoggedIn)
                    complation(true, nil)
                    return
                }
                
                complation(false, error)
            }
        }
    }
    
    
    func signUp(parameters: RegisterRequest, complation: @escaping(_ result: Bool, _ errorMessage: String?) -> ())
    {
        SVProgressHUD.show()
        
        FBDatabaseManager.shared.doesUserExistInDatabase(parameters.email) { isExist in
            
            guard !isExist else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { SVProgressHUD.dismiss() })
                complation(false, "Sorry, A user with same email address is already exist")
                return
            }
            
            self.createUser(parameters: parameters) { result, errorMessage in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { SVProgressHUD.dismiss() })
                complation(result, errorMessage)
            }
        }
    }
    
    
    func reauthenticateUser(parameters: LoginRequest, complation: @escaping(_ result: Bool, _ errorMessage: String?) -> ())
    {
        SVProgressHUD.show()
        let credential = EmailAuthProvider.credential(withEmail: parameters.email, password: parameters.password)
        
        FBAuthenticationManager.shared.authUser?.reauthenticate(with: credential, completion: { result, error in
            
            guard error == nil else {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { SVProgressHUD.dismiss() })
                complation(false, error?.localizedDescription)
                return
            }
            
            guard let _ = result?.user else {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { SVProgressHUD.dismiss() })
                complation(false, "There was a problem, Please try again later")
                return
            }
            
            complation(true, nil)
        })
    }
    
    
    func changePassword(password: String, complation: @escaping(_ result: Bool,_ error: Error?) -> ())
    {
        SVProgressHUD.show()

        FBAuthenticationManager.shared.authUser?.updatePassword(to: password, completion: { (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { SVProgressHUD.dismiss() })
            error == nil ? complation(true, nil) : complation(false, error)
        })
    }
    
    
    func resetPassword(email: String, complation: @escaping(Bool, String?) -> ()) {
        FBManager.shared.authReference().sendPasswordReset(withEmail: email) { (error) in
            error == nil ? complation(true, nil) : complation(false, error?.localizedDescription) }
    }
    
    
    fileprivate func createUser(parameters: RegisterRequest, complation: @escaping(_ result: Bool, _ errorMessage: String?) -> ())
    {
        FBManager.shared.authReference().createUser(withEmail: parameters.email, password: parameters.password) { result, error in
            
            guard error == nil else {
                complation(false, error?.localizedDescription)
                return
            }
            
            guard let user = result?.user else {
                complation(false, "There was a problem, Please try again later!")
                return
            }
            
            var requestParam = parameters
            requestParam.id = user.uid
            
            if let imageData = parameters.image?.jpegData(compressionQuality: 0.5)
            {
                FBStorageManager.shared.uploadImage(type: .profileImage, imageData: imageData) { imageURL in
                    
                    guard let imageURL = imageURL else {
                        user.delete()
                        complation(false, "There was a problem, Please try again later!!!")
                        return
                    }
                    
                    requestParam.imageURL = imageURL
                    
                    FBDatabaseManager.shared.addUser(parameters: requestParam) { error in
                        
                        guard error == nil else {
                            complation(false, error)
                            return
                        }
                        
                        Defaults.shared.setBool(true, forKey: Default.isLoggedIn)
                        complation(true, nil)
                    }
                }
            }
            else
            {
                FBDatabaseManager.shared.addUser(parameters: requestParam) { error in
                    
                    guard error == nil else {
                        complation(false, error)
                        return
                    }
                    
                    Defaults.shared.setBool(true, forKey: Default.isLoggedIn)
                    complation(true, nil)
                }
            }
        }
    }
    
    
    func signOut()
    {
        SVProgressHUD.show()

        do {
            try FBManager.shared.authReference().signOut()
            Defaults.shared.removeDefaults(Default.isLoggedIn)
            Defaults.shared.removeDefaults(Default.user)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                SVProgressHUD.dismiss()
                Application.appDelegate.setLoginVC()
            }

        } catch let error {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { SVProgressHUD.dismiss() })
            Utils.showToast(title: "Oops!", subtitle: error.localizedDescription, icon: UIImage(systemName: "exclamationmark.triangle.fill"))
        }
    }
    
    
    func deleteAccount(complation: @escaping(_ result: Bool,_ error: Error?) -> ())
    {
        SVProgressHUD.show()

        FBAuthenticationManager.shared.authUser?.delete(completion: { (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { SVProgressHUD.dismiss() })
            error == nil ? complation(true, nil) : complation(false, error)
        })
    }
}
