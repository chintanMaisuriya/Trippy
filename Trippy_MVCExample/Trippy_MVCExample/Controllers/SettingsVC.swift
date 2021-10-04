//
//  SettingsVC.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 29/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController
{
    //MARK: -
    
    @IBOutlet weak var viewHeaderOutlet     : UIView!
    @IBOutlet weak var ivProfileOutlet      : UIImageView!
    @IBOutlet weak var lblUserOutlet        : UILabelX!
    @IBOutlet weak var tblUtilitiesOutlet   : UITableView!
    
    //MARK: -
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialConfiguration()
    }
    
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        ivProfileOutlet.layer.cornerRadius = ivProfileOutlet.frame.height / 2
    }
    
    
    //MARK: -
    
    
    /*
     // MARK: - Navigation
     */
}


//MARK: - UITableview

extension SettingsVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return (section == 0) ? viewHeaderOutlet : nil
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return (section == 0) ? 220 : 12
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (section == 0) ? 2 : 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell    = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row     = indexPath.row
        let section = indexPath.section
        
        cell.textLabel?.textColor   = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.accessoryType          = .disclosureIndicator

        if row == 0 && section == 0
        {
            cell.textLabel?.text = "Edit Profile"
        }
        else if row == 1 && section == 0
        {
            cell.textLabel?.text = "Change Password"
        }
        else if row == 0 && section == 1
        {
            cell.textLabel?.text = "Sign Out"
            cell.textLabel?.textColor = #colorLiteral(red: 1, green: 0.3032806202, blue: 0.02296007777, alpha: 1)
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0 && indexPath.row == 0 {
            guard let vc = self.storyboard?.instantiateViewController(identifier: "EditProfileVC") as? EditProfileVC else { return }
            self.navigationController?.present(vc, animated: true, completion: nil)
        } else if indexPath.section == 0 && indexPath.row == 1 {
            guard let vc = self.storyboard?.instantiateViewController(identifier: "ChangePasswordVC") as? ChangePasswordVC else { return }
            self.navigationController?.present(vc, animated: true, completion: nil)            
        } else if indexPath.section == 1 && indexPath.row == 0 {
            displayLogoutAlert()
        }
    }
}


//MARK: -

extension SettingsVC
{
    private func initialConfiguration()
    {
        self.setUserDetails()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getUserDetails), name: NSNotification.Name(rawValue: "notifyToReloadUserData"), object: nil)
    }
    
    
    @objc private func getUserDetails()
    {
        FBDatabaseManager.shared.getCurrentUserDetails { error in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { SVProgressHUD.dismiss() })
            
            guard (error == nil) else {
                Utils.showToast(title: "Oops!", subtitle: error ?? "Unable to get user", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
                return
            }
            
            self.setUserDetails()
        }
    }
    
    
    private func setUserDetails()
    {
        self.ivProfileOutlet.downloadImage(url: CurrentUser.imageURL, placeholderImage: "mtpUser")
        
        let name    = CurrentUser.name ?? ""
        let email   = CurrentUser.email ?? ""
        
        if !name.isEmpty, !email.isEmpty
        {
            let sName = "\(name)\n".customAttributedString(UIColor(named: "Color_Text1") ?? .black, font: UIFont(name: "Comfortaa-Bold", size: Utils.setCustomFontSize(noramlSize: 18)))
            let sEmail = email.customAttributedString(UIColor(named: "Color_Text2") ?? .darkGray, font: UIFont(name: "Comfortaa-Medium", size: Utils.setCustomFontSize(noramlSize: 14)))
            
            let str = NSMutableAttributedString(attributedString: sName)
            str.append(sEmail)
            
            self.lblUserOutlet.attributedText = str
        }
        else if !name.isEmpty, email.isEmpty
        {
            self.lblUserOutlet.text = name
        }
        else if name.isEmpty, !email.isEmpty
        {
            self.lblUserOutlet.text = email
        }
        else
        {
            self.lblUserOutlet.text = ""
        }
        
        DispatchQueue.main.async { self.tblUtilitiesOutlet.reloadData() }
    }
    
    
    private func displayLogoutAlert()
    {
        let alrt = UIAlertController(title: "", message: "Sure you want to logout?", preferredStyle: .alert)
        
        let alrtOkAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            FBAuthenticationManager.shared.signOut()
        }
        
        let alrtCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alrt.addAction(alrtCancelAction)
        alrt.addAction(alrtOkAction)
        self.present(alrt, animated: true, completion: nil)
    }
}
