//
//  ChangePasswordVC.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 30/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import UIKit
import FirebaseAuth


class ChangePasswordVC: UIViewController
{
    //MARK: -

    private var changePasswordRequest   : ChangePasswordRequest = ChangePasswordRequest()
    private var loginRequest            : LoginRequest = LoginRequest()
    
    let userValidation = UserValidations()
    
    
    //MARK: -
    
    @IBOutlet weak var scrollFormOutlet         : UIScrollView!
    @IBOutlet weak var txtNewPasswordOutlet     : UITextFieldX!
    @IBOutlet weak var txtConfirmPasswordOutlet : UITextFieldX!
    @IBOutlet weak var btnSaveOutlet            : UIButton!

    //MARK: -

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.initialConfiguration()

    }
    
    //MARK: - IBActions
    
    @IBAction func btnCloseAction(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSaveAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let validationResponse = self.userValidation.validateChangePasswordRequest(request: self.changePasswordRequest)
        guard validationResponse.isValid else {
            Utils.showToast(title: "Oops!", subtitle: validationResponse.error?.localizedDescription ?? validationResponse.message ?? "Something went wrong", icon: UIImage(systemName: "exclamationmark.triangle.fill"), buttonIcon: nil)
            return
        }
        
        self.doChangePassword()
    }
    

    /*
    // MARK: - Navigation
    */

}


//MARK: - Firebase Methods

extension ChangePasswordVC
{
    private func doChangePassword()
    {
        FBAuthenticationManager.shared.changePassword(password: self.changePasswordRequest.newPassword) { [weak self] (result, error) in
            guard let self = self else { return }
            
            if let terror = error as NSError?
            {
                switch AuthErrorCode(rawValue: terror.code) {
                case .operationNotAllowed:
                    // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                    break
                    
                case .requiresRecentLogin:
                    // Error: Updating a user’s password is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser.
                    self.reauthenticationAlert()
                    
                default:
                    print("Error message: \(error?.localizedDescription ?? "Something went wrong")")
                    break
                }
                
                return
            }
            
            
            Utils.showToast(title: "", subtitle: "Password Changed", icon: nil, buttonIcon: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func reauthenticateCurrentUser()
    {
        FBAuthenticationManager.shared.reauthenticateUser(parameters: self.loginRequest) { result, error in
            
            guard result else {
                Utils.showToast(title: "Oops!", subtitle: error ?? "Unable to edit user", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
                return
            }
            
            self.doChangePassword()
        }
    }
}


//MARK: -

extension ChangePasswordVC: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        switch textField.tag {
        case 101 : self.changePasswordRequest.newPassword       = textField.text ?? ""
        case 102 : self.changePasswordRequest.confirmPassword   = textField.text ?? ""
        default: break
        }
    }
}


//MARK: - Custom Functions

extension ChangePasswordVC
{
    private func initialConfiguration()
    {
        self.configureTextfield(self.txtNewPasswordOutlet, tag: 101)
        self.configureTextfield(self.txtConfirmPasswordOutlet, tag: 102)
        self.configureButton(self.btnSaveOutlet)
    }
    
    
    private func configureTextfield(_ textField: UITextField, tag: Int)
    {
        textField.layer.borderColor    = UIColor(named: "Color_Text4")?.cgColor
        textField.layer.borderWidth    = 1
        textField.tag = tag
        textField.delegate = self
    }
    
    
    private func configureButton(_ button: UIButton)
    {
        button.layer.cornerRadius = 6
        button.clipsToBounds      = true
    }
    
    
    private func reauthenticationAlert()
    {
        let alert = UIAlertController(title: "", message: "This operation is sensitive and requires recent authentication. Log in again before retrying this request", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder  = "Enter Email"
            textField.keyboardType = .emailAddress
            textField.textColor    = UIColor(named: "Color_Text1")
            textField.tintColor    = UIColor(named: "Color_Text1")
        }
        
        alert.addTextField { (textField) in
            textField.placeholder       = "Enter Old Password"
            textField.keyboardType      = .default
            textField.isSecureTextEntry = true
            textField.textColor         = UIColor(named: "Color_Text1")
            textField.tintColor         = UIColor(named: "Color_Text1")
        }
        
        alert.addAction (UIAlertAction(title: "Reauthenticate", style: .default) { (alertAction) in
            
            guard let txtEmail = alert.textFields?.first, let txtPWD = alert.textFields?.last else { return }
            
            self.view.endEditing(true)
            
            self.loginRequest.email     = Utils.trimString(txtEmail.text ?? "")
            self.loginRequest.password  = Utils.trimString(txtPWD.text ?? "")

            let validationResponse = self.userValidation.validateSignInRequest(request: self.loginRequest)
            guard validationResponse.isValid else {
                Utils.showToast(title: "Oops!", subtitle: validationResponse.error?.localizedDescription ?? validationResponse.message ?? "Something went wrong", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
                return
            }
                        
            self.reauthenticateCurrentUser()
        })
        
        
        //Cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated:true, completion: nil)
        }
    }

}
