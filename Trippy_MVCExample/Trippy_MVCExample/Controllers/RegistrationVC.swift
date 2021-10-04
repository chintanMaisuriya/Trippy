//
//  RegistrationVC.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 22/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import UIKit
import Blurberry


class RegistrationVC: UIViewController
{
    //MARK: -
    
    private var imagePicker : ImagePicker?
    private var registerRequest: RegisterRequest = RegisterRequest()
    let userValidation = UserValidations()
    
    private var image = UIImage() {
        didSet { profileImageOutlet.setImage(image, for: .normal) }
    }
    
    //MARK: -

    @IBOutlet weak var viewBlurOutlet       : UIVisualEffectView!
    @IBOutlet weak var profileImageOutlet   : UIButton!
    @IBOutlet weak var txtNameOutlet        : UITextFieldX!
    @IBOutlet weak var txtEmailOutlet       : UITextFieldX!
    @IBOutlet weak var txtPasswordOutlet    : UITextFieldX!
    @IBOutlet weak var btnSignUpOutlet      : UIButton!

    
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
    
    
    @IBAction func btnPickImageAction(_ sender: UIButton)
    {
        self.view.endEditing(true)

        guard let imagePicker = self.imagePicker else {
            Utils.showToast(title: "Caution", subtitle: "Please initialise image picker", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
            return
        }
        
        imagePicker.present(from: sender)
    }
    
    
    @IBAction func btnSignUpAction(_ sender: UIButton)
    {
        self.view.endEditing(true)

        let validationResponse = self.userValidation.validateSignUpRequest(request: self.registerRequest)
        guard validationResponse.isValid else {
            Utils.showToast(title: "Oops!", subtitle: validationResponse.error?.localizedDescription ?? validationResponse.message ?? "Something went wrong", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
            return
        }
        
        FBAuthenticationManager.shared.signUp(parameters: self.registerRequest) { [weak self] (result, error) in
            guard let _ = self else { return }

            guard result else {
                Utils.showToast(title: "Oops!", subtitle: error ?? "Unable to register user", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
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
    
    
    /*
    // MARK: - Navigation
    */
}


//MARK: -

extension RegistrationVC: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        switch textField.tag {
        case 101 : self.registerRequest.name        = Utils.trimString(textField.text ?? "")
        case 102 : self.registerRequest.email       = Utils.trimString(textField.text ?? "")
        case 103 : self.registerRequest.password    = Utils.trimString(textField.text ?? "")
        default: break
        }
    }
}


extension RegistrationVC: ImagePickerDelegate
{
    func didSelect(image: UIImage?)
    {
        guard let image = image else { return }
        self.image = image
        self.registerRequest.image = image
    }
}


//MARK: -

extension RegistrationVC
{
    private func initialConfiguration()
    {
        configureBlurView()
        
        Utils.congfigureRoundedButton(button: profileImageOutlet, borderColor: .placeholderText, borderWidth: 1)
        Utils.congfigureTextfield(textField: self.txtNameOutlet, textFieldDelegate: self, tag: 101, borderColor: .placeholderText, borderWidth: 1, cornerRadius: self.txtNameOutlet.height/2, tintColor: UIColor("Color_Text1"))
        Utils.congfigureTextfield(textField: self.txtEmailOutlet, textFieldDelegate: self, tag: 102, borderColor: .placeholderText, borderWidth: 1, cornerRadius: self.txtEmailOutlet.height/2, tintColor: UIColor("Color_Text1"))
        Utils.congfigureTextfield(textField: self.txtPasswordOutlet, textFieldDelegate: self, tag: 103, borderColor: .placeholderText, borderWidth: 1, cornerRadius: self.txtEmailOutlet.height/2, tintColor: UIColor("Color_Text1"))
        Utils.congfigureButton(button: btnSignUpOutlet, font: btnSignUpOutlet.titleLabel?.font ?? UIFont.boldSystemFont(ofSize: 17), cornerRadius: btnSignUpOutlet.bounds.height/2)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
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
