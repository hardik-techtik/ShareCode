//
//  SettingsVC.swift
//  MySchollKinect
//
//  Created by Admin on 01/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SettingsVC: BaseVC {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var btnUserAgreement: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var viewChangePassword: UIView!
    
        override func viewDidLoad() {
        
        super.viewDidLoad()
            if(UserDefaults.standard.value(forKey: "isSocialLogin") as? Bool ?? false == true){
                self.viewChangePassword.isHidden = true
            }
        self.btnAccount.addTarget(self, action: #selector(Accounts(_:)), for: .touchUpInside)
        self.btnNotification.addTarget(self, action: #selector(Notifications(_:)), for: .touchUpInside)
        self.btnPrivacyPolicy.addTarget(self, action: #selector(PrivacyPolicy(_:)), for: .touchUpInside)
        self.btnUserAgreement.addTarget(self, action: #selector(UserAgreement(_:)), for: .touchUpInside)
        self.btnLogout.addTarget(self, action: #selector(Logout(_:)), for: .touchUpInside)
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backView.AddDefaultShadow()
    }
    
    @IBAction func changePassword(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC else {return}
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func Accounts(_ button:UIButton)
    {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AccountsVC") as? AccountsVC else {return}
        self.navigationController?.show(vc, sender: nil)

    }
    
    @objc func Notifications(_ button:UIButton)
    {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationsVc") as? NotificationsVc else {return}
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func PrivacyPolicy(_ button:UIButton)
    {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVc") as? PrivacyPolicyVc else {return}
        self.navigationController?.show(vc, sender: nil)
    }
    @IBAction func openChangePassword(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC else {return}
        self.navigationController?.show(vc, sender: nil)
        
    }
    
    @objc func UserAgreement(_ button:UIButton)
    {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TermsOfUseVC") as? TermsOfUseVC else {return}
        self.navigationController?.show(vc, sender: nil)
    }
     
    @objc func Logout(_ button:UIButton)
    {
        let StoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let alert = UIAlertController.init(title: "Are you sure you want to logout?", message: nil, preferredStyle: .alert)
        let yes = UIAlertAction.init(title: "Yes", style: .default) { (action) in
            guard let vc = StoryBoard.instantiateViewController(withIdentifier: "GetStartedVC") as? GetStartedVC else {return}
            UserDefaults.standard.removeObject(forKey: "User")
            UserDefaults.standard.removeObject(forKey: "SchoolName")
            UserDefaults.standard.removeObject(forKey: "isSocialLogin")
            self.navigationController?.setViewControllers([vc], animated: true)
        }
        
        let No = UIAlertAction.init(title: "No", style: .default)
        
        alert.addAction(yes)
        alert.addAction(No)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
