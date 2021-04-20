//
//  WelcomeCollegeVC.swift
//  MySchollKinect
//
//  Created by Admin on 24/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class WelcomeCollegeVC: BaseVC {

    @IBOutlet weak var btnNext: CornerButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var backVew: UIView!
    @IBOutlet weak var btnCheckUncheck: UIButton!
    @IBOutlet weak var btnDefaultSchool: UIButton!
    @IBOutlet weak var lblSchool: UILabel!
    @IBOutlet weak var lblSchoolDetail: UILabel!
    
    var makeDefault = false
    var tplSchoolDetail : (String?, String?, String?)

    var selectedschool:Schools?
    var isFromMyAccount = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.addTarget(self, action: #selector(Next), for: .touchUpInside)
        btnBack.addTarget(self, action: #selector(Back), for: .touchUpInside)
        btnCheckUncheck.imageView?.contentMode = .scaleAspectFit
        btnDefaultSchool.addTarget(self, action: #selector(CheckUnchekSchool(_:)), for: .touchUpInside)
        
        var schoolName = ""
        if isFromMyAccount {
            schoolName = Utility.shared.accountSchoolInfo?.1 ?? ""
        }else {
            if let strSchoolName : String = UserDefaults.standard.value(forKey: "SchoolName") as? String {
                schoolName = strSchoolName
            }else {
                schoolName = "\(User.shared.schoolusers?.last?.school?.theNameOfYourSchool ?? "")"
            }
        }
        self.lblSchool.text = "\(schoolName)"
        
        if let strAddress = tplSchoolDetail.0,let strState = tplSchoolDetail.1,let strZip = tplSchoolDetail.2 {
            self.lblSchoolDetail.text = strAddress + ", " + strState + " " + strZip
        }else {
            self.lblSchoolDetail.text = ""
        }
        
        self.backVew.AddDefaultShadow()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @objc func CheckUnchekSchool(_ button:UIButton) {
        self.makeDefault = !self.makeDefault
        if self.makeDefault {
            self.btnDefaultSchool.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
        } else {
            self.btnDefaultSchool.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
        }
    }
    @objc func Back() {
        //self.navigationController?.popViewController(animated: true)
    }
    @objc func Next() {
        
        if isFromMyAccount {
            for vc in self.navigationController?.viewControllers ?? []
            {
                if vc is AccountsVC
                {
                    self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        }else {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC else { return }
            self.navigationController?.setViewControllers([vc], animated: false)
        }
        
//        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as? HomeScreenVC else {return}
//        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    /*func getLoggedInUserProfile() {
        let serviceManager = ServiceManager<UserProfile>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "users-detail/\(User.shared.id ?? 0)"
        
        serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
            let user = Response as? ResponseModel<UserProfile>
            
            User.shared = user?.Data?.first
            
            let data = try JSONEncoder().encode(User.shared)
            UserDefaults.standard.set(data, forKey: "User")
        }
    }*/
}
