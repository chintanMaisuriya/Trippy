//
//  LoginVC.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 21/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import UIKit
import Blurberry
import Firebase


class LoginVC: UIViewController
{
    //MARK: -
    private let network = NetworkManager.shared

    private var loginRequest    : LoginRequest = LoginRequest()
    let userValidation = UserValidations()
    
    //MARK: -

    @IBOutlet weak var viewBlurOutlet       : UIVisualEffectView!
    @IBOutlet weak var txtEmailOutlet       : UITextFieldX!
    @IBOutlet weak var txtPasswordOutlet    : UITextFieldX!
    @IBOutlet weak var btnSignInOutlet      : UIButton!
    
    //MARK: -

    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialConfiguration()
    }
    
    //MARK: -

    @IBAction func btnForgotPasswordAction(_ sender: UIButton)
    {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "ForgotPasswordVC") as? ForgotPasswordVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnSignInAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let validationResponse = self.userValidation.validateSignInRequest(request: self.loginRequest)
        guard validationResponse.isValid else {
            Utils.showToast(title: "Oops!", subtitle: validationResponse.error?.localizedDescription ?? validationResponse.message ?? "Something went wrong", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
            return
        }
        
        FBAuthenticationManager.shared.signIn(parameters: self.loginRequest) { [weak self] (result, error) in
            guard let _ = self else { return }

            guard result else {
                Utils.showToast(title: "Oops!", subtitle: error ?? "Unable to login", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
                return
            }
            
            FBAuthenticationManager.shared.doesMailVerified { isVerified in
                guard isVerified else {
                    FBAuthenticationManager.shared.signOut()
                    return
                }
                
                Application.appDelegate.setMainTab()
            }
            
        }
    }
    
    
    @IBAction func btnSignUpAction(_ sender: UIButton)
    {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "RegistrationVC") as? RegistrationVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /*
    // MARK: - Navigation
    */

}


//MARK: -

extension LoginVC: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        switch textField.tag {
        case 101 : self.loginRequest.email      = Utils.trimString(textField.text ?? "")
        case 102 : self.loginRequest.password   = Utils.trimString(textField.text ?? "")
        default: break
        }
    }
}


//MARK: -

extension LoginVC
{
    private func initialConfiguration()
    {
        configureBlurView()
        
        Utils.congfigureTextfield(textField: self.txtEmailOutlet, textFieldDelegate: self, tag: 101, borderColor: .placeholderText, borderWidth: 1, cornerRadius: self.txtEmailOutlet.height/2, tintColor: UIColor("Color_Text1"))
        Utils.congfigureTextfield(textField: self.txtPasswordOutlet, textFieldDelegate: self, tag: 102, borderColor: .placeholderText, borderWidth: 1, cornerRadius: self.txtEmailOutlet.height/2, tintColor: UIColor("Color_Text1"))
        Utils.congfigureButton(button: btnSignInOutlet, font: btnSignInOutlet.titleLabel?.font ?? UIFont.boldSystemFont(ofSize: 17), cornerRadius: btnSignInOutlet.bounds.height/2)
        
        
        network.updateConnectionStatus = { [weak self] isReachable in
            print("$$$ hasConnectivity: \(isReachable)")
        }
    }
    
    
    private func configureBlurView()
    {
        self.viewBlurOutlet.blur.radius = 2.0
        self.viewBlurOutlet.blur.tintColor = .clear
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewBlurOutlet.blur.radius = 4.5
            self.viewBlurOutlet.blur.tintColor = .clear
        }
    }
}
