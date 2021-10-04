//
//  EditProfileVC.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 29/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import UIKit


class EditProfileVC: UIViewController
{
    //MARK: -
    
    private var imagePicker : ImagePicker?
    private var editRequest: EditProfileRequest = EditProfileRequest()
    let userValidation = UserValidations()
    
    private var image: UIImage? {
        didSet { profileImageOutlet.setImage(image, for: .normal) }
    }
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var scrollFormOutlet             : UIScrollView!
    @IBOutlet weak var profileImageOutlet           : UIButton!
    @IBOutlet weak var txtNameOutlet                : UITextFieldX!
    @IBOutlet weak var btnSaveOutlet                : UIButton!
    
    
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
    
    
    @IBAction func btnPickImageAction(_ sender: UIButton)
    {
        self.view.endEditing(true)

        guard let imagePicker = self.imagePicker else {
            Utils.showToast(title: "Caution", subtitle: "Please initialise image picker", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
            return
        }
        
        imagePicker.present(from: sender)
    }
    
    
    @IBAction func btnSaveAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let validationResponse = self.userValidation.validateEditProfileRequest(request: self.editRequest)
        guard validationResponse.isValid else {
            Utils.showToast(title: "Oops!", subtitle: validationResponse.error?.localizedDescription ?? validationResponse.message ?? "Something went wrong", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
            return
        }
        
        self.editProfile()
    }
    
    
    /*
     // MARK: - Navigation
     */
    
}


//MARK: - Firebase Methods

extension EditProfileVC
{
    private func editProfile()
    {
        let strUserImage = CurrentUser.imageURL ?? ""
        
        FBDatabaseManager.shared.editUser(parameters: self.editRequest) { [weak self] (result, error) in
            guard let self = self else { return }
            
            guard result else {
                Utils.showToast(title: "Oops!", subtitle: error ?? "Unable to edit user", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
                return
            }
            
            if (self.editRequest.isImageUpdated && !strUserImage.isEmpty)
            {
                FBStorageManager.shared.deleteImage(url: strUserImage) { error in
                    
                    guard (error == nil) else { return }

                    Utils.showToast(title: "", subtitle: "Profile updated", icon: nil, buttonIcon: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifyToReloadUserData"), object: nil)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            else
            {
                Utils.showToast(title: "", subtitle: "Profile updated", icon: nil, buttonIcon: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifyToReloadUserData"), object: nil)

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            
        }
    }
    
}


//MARK: -

extension EditProfileVC: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        switch textField.tag {
        case 101 : self.editRequest.name   = textField.text ?? ""
        default: break
        }
    }
}


extension EditProfileVC: ImagePickerDelegate
{
    func didSelect(image: UIImage?)
    {
        guard let image = image else { return }
        self.image                      = image
        self.editRequest.image          = image
        self.editRequest.isImageUpdated = true
    }
}


//MARK: - Custom Functions

extension EditProfileVC
{
    private func initialConfiguration()
    {
        Utils.congfigureRoundedButton(button: profileImageOutlet, borderColor: .placeholderText, borderWidth: 1)
        self.configureTextfield(self.txtNameOutlet, tag: 101)
        self.configureButton(self.btnSaveOutlet)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

        self.setInfoToEdit()
    }
    
    
    private func configureTextfield(_ textField: UITextField, tag: Int)
    {
        textField.layer.borderColor     = UIColor(named: "Color_Text4")?.cgColor
        textField.layer.borderWidth     = 1
        textField.tag                   = tag
        textField.delegate              = self
    }
    
    
    private func configureButton(_ button: UIButton)
    {
        button.layer.cornerRadius = 6
        button.clipsToBounds      = true
    }
    
    
    //--
    
    private func setInfoToEdit()
    {
        profileImageOutlet.sd_setImage(with: URL(string: CurrentUser.imageURL ?? ""), for: .normal, placeholderImage: UIImage(named: "mtpUser"))
        
        self.txtNameOutlet.text = CurrentUser.name ?? ""
        self.editRequest.name   = CurrentUser.name ?? ""
    }    
}
