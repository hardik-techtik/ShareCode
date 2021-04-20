//
//  AccountsVC.swift
//  MySchollKinect
//
//  Created by Admin on 01/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class AccountsVC: BaseVC {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var BackView2: UIView!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var btnChangeSchool: CornerButton!
    @IBOutlet weak var txtLastName: UIView!
    @IBOutlet weak var txtSchool: UITextField!
    @IBOutlet weak var lastNamr: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSave: CornerButton!
    @IBOutlet weak var btnDeactiveAccount: CornerButton!
    
    @IBOutlet weak var btnChangePassword: CornerButton!
    
    
    var Deactivate = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UserDefaults.standard.value(forKey: "isSocialLogin") as? Bool ?? false == true){
            self.btnChangePassword.isHidden = true
        }
        self.btnChangeSchool.addTarget(self, action: #selector(ChangeSchool(_:)), for: .touchUpInside)
        btnSave.addTarget(self, action: #selector(Save(_:)), for: .touchUpInside)
         
    }

    
    @IBAction func MaleSElecrted(_ sender: UIButton) {
        
        self.view.endEditing(true)
        btnMale.isSelected = !btnMale.isSelected
        btnFemale.isSelected = !btnFemale.isSelected
    }
    
    
    @IBAction func FemaleSelected(_ sender: UIButton) {
        self.view.endEditing(true)
         btnMale.isSelected = !btnMale.isSelected
         btnFemale.isSelected = !btnFemale.isSelected
    }
    
    @objc func DeactivateAccount(_ button:UIButton) {
        
        self.view.endEditing(true)
        
         let alert = UIAlertController.init(title: "Are you sure want to deactivate your account?", message: nil, preferredStyle: .alert)
                   
                   let ok = UIAlertAction.init(title: "Yes", style: .default) { (action) in
                       self.Deactivate = 0
                       self.AccountsSettings()
                       
                   }
                   
                   let no = UIAlertAction.init(title: "No", style: .default) { (action) in
                       
                   }
               
                   alert.addAction(ok)
                   alert.addAction(no)
                   
                   self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    @objc func Save(_ button:UIButton) {
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
        if !(txtname.text?.isEmpty ?? false) {
            let Inputcharatcter = CharacterSet.init(charactersIn: self.txtname.text ?? "")
            let Characters = CharacterSet.init(charactersIn: allowedCharacters)
            if Characters.isSuperset(of: Inputcharatcter) {
                if !(lastNamr.text?.isEmpty ?? false) {
                    self.AccountsSettings()
                } else {
                     RDalertcontoller().presentAlertWithMessage(Message:"Please enter last name",onVc:self)
                }
            } else {
                RDalertcontoller().presentAlertWithMessage(Message:"please enter first name",onVc:self)
            }
        } else {
             RDalertcontoller().presentAlertWithMessage(Message:"please enter last name",onVc:self)
        }
    }
    
    @objc func ChangeSchool(_ button:UIButton) {
        self.view.endEditing(true)
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchoolSearchVC") as? SchoolSearchVC  else {return}
        vc.UnhideBackbutton = true
        vc.from = "Accounts"
        self.navigationController?.show(vc, sender: nil)
    }
    
    @IBAction func chnagePassword(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC else {return}
        self.navigationController?.show(vc, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backView.AddDefaultShadow()
        BackView2.AddDefaultShadow()
        self.txtname.text = User.shared.firstName
        self.lastNamr.text = User.shared.lastName
        self.txtEmail.text = User.shared.email
        
        var schoolName = ""
        
        if let tpl = Utility.shared.accountSchoolInfo {
            
            schoolName = tpl.1
            
        }else {
            if let strSchoolName : String = UserDefaults.standard.value(forKey: "SchoolName") as? String {
                schoolName = strSchoolName
            }else {
                schoolName = "\(User.shared.schoolusers?.last?.school?.theNameOfYourSchool ?? "")"
            }
        }
        
        self.txtSchool.text = schoolName
        
        if User.shared.gender == "Male"
        {
            self.btnMale.isSelected = true
            self.btnFemale.isSelected = false
        }
        else
        {
            self.btnFemale.isSelected = true
            self.btnMale.isSelected = false
        }
        
        self.btnDeactiveAccount.addTarget(self, action: #selector(DeactivateAccount(_:)), for: .touchUpInside)
    }
    
}
extension AccountsVC  {
    
    @objc func AccountsSettings() {
        let serviceManager = ServiceManager<AccountUser>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "account"
        serviceManager.Parameters = [
            "first_name":txtname.text ?? "",
            "last_name":lastNamr.text ?? "",
            "gender":btnMale.isSelected ? "Male":"Female",
            "is_active":Deactivate,
            "school_id": Utility.shared.accountSchoolInfo?.0 ?? User.shared.schoolID ?? 0
        ]
        User.shared.schoolID = Utility.shared.accountSchoolInfo?.0 ?? User.shared.schoolID ?? 0
        serviceManager.MakeServiceCall(httpMethod: .post) { (response) in
            print(response)
            
            let user = response as? ResponseModelDic<AccountUser>
            
            do
            {
                User.shared.firstName = user?.Data?.firstName ?? User.shared.firstName
                User.shared.lastName = user?.Data?.lastName ?? User.shared.lastName
                User.shared.schoolusers = user?.Data?.schoolusers ?? User.shared.schoolusers
                User.shared.gender = user?.Data?.gender ?? User.shared.gender
                
                //Utility.shared.accountSchoolInfo?.1 ?? "\(User.shared.schoolusers?.last?.school?.theNameOfYourSchool ?? "")"
                UserDefaults.standard.set(Utility.shared.accountSchoolInfo?.1 ?? "\(User.shared.schoolusers?.last?.school?.theNameOfYourSchool ?? "")", forKey: "SchoolName")

                let data = try JSONEncoder().encode(User.shared)
                UserDefaults.standard.set(data, forKey: "User")
                
                Utility.shared.accountSchoolInfo = nil
                
                if self.Deactivate == 0 {
                    UserDefaults.standard.removeObject(forKey: "User")
                    UserDefaults.standard.removeObject(forKey: "SchoolName")
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "GetStartedVC") as? GetStartedVC else {return}
                    self.navigationController?.setViewControllers([vc], animated: true)

                }else {
                    self.navigationController?.popViewController(animated: true)
                }
                
                
                //
                
            }
            catch {
                print(error)
            }
            
        }
    }
    
}





