//
//  ForgotPasswordVC.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 04/10/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import UIKit
import Blurberry
import Firebase


class ForgotPasswordVC: UIViewController
{
    //MARK: -
    private let network = NetworkManager.shared

    private var forgotPasswordRequest    : ForgotPasswordRequest = ForgotPasswordRequest()
    let userValidation = UserValidations()
    
    //MARK: -

    @IBOutlet weak var viewBlurOutlet       : UIVisualEffectView!
    @IBOutlet weak var txtEmailOutlet       : UITextFieldX!
    @IBOutlet weak var btnResetOutlet       : UIButton!
    
    //MARK: -

    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialConfiguration()
    }
    
    //MARK: -

    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnResetAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let validationResponse = self.userValidation.validateForgotPasswordRequest(request: self.forgotPasswordRequest)
        guard validationResponse.isValid else {
            Utils.showToast(title: "Oops!", subtitle: validationResponse.error?.localizedDescription ?? validationResponse.message ?? "Something went wrong", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
            return
        }
        
        FBAuthenticationManager.shared.resetPassword(email: forgotPasswordRequest.email) { [weak self] (result, error) in
            guard let _ = self else { return }

            guard result else {
                Utils.showToast(title: "Oops!", subtitle: error ?? "Unable to login", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
                return
            }
            
            Utils.showToast(title: "", subtitle: "Reset Password mail hase been sent to your email. Please check it.", icon: nil, buttonIcon: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    /*
    // MARK: - Navigation
    */
}


//MARK: -

extension ForgotPasswordVC: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        switch textField.tag {
        case 101 : self.forgotPasswordRequest.email = Utils.trimString(textField.text ?? "")
        default: break
        }
    }
}


//MARK: -

extension ForgotPasswordVC
{
    private func initialConfiguration()
    {
        configureBlurView()
        
        Utils.congfigureTextfield(textField: self.txtEmailOutlet, textFieldDelegate: self, tag: 101, borderColor: .placeholderText, borderWidth: 1, cornerRadius: self.txtEmailOutlet.height/2, tintColor: UIColor("Color_Text1"))
        Utils.congfigureButton(button: btnResetOutlet, font: btnResetOutlet.titleLabel?.font ?? UIFont.boldSystemFont(ofSize: 17), cornerRadius: btnResetOutlet.bounds.height/2)
        
        
        network.updateConnectionStatus = { [weak self] isReachable in
            print("$$$ hasConnectivity: \(isReachable)")
        }
    }
    
    
    private func configureBlurView()
    {
        self.viewBlurOutlet.blur.radius = 2.0
        self.viewBlurOutlet.blur.tintColor = .clear
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.viewBlurOutlet.blur.radius = 4.5
            self.viewBlurOutlet.blur.tintColor = .clear
        }
    }
}

