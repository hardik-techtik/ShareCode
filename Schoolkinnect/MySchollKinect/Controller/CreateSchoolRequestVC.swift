//
//  CreateSchoolRequestVC.swift
//  MySchollKinect
//
//  Created by Admin on 23/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CreateSchoolRequestVC: BaseVC {

    @IBOutlet weak var BackView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSubmit: CornerButton!
    @IBOutlet weak var txtFirstName: RDTextField!
    
    @IBOutlet weak var txtLastname: RDTextField!
    @IBOutlet weak var txtschoolname: RDTextField!
    @IBOutlet weak var state: RDTextField!
    @IBOutlet weak var txtSchoolMascot: RDTextField!
    @IBOutlet weak var city: RDTextField!
    @IBOutlet weak var txtZipCode: RDTextField!
    @IBOutlet weak var txtemailaddress: RDTextField!
    @IBOutlet weak var txtPhone: RDTextField!
    @IBOutlet weak var txtSchoolType: RDTextFieldDropDown!
    
    
    var from = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //btnBack.addTarget(self, action: #selector(Back), for: .touchUpInside)
        btnSubmit.addTarget(self, action: #selector(Submit(_:)), for: .touchUpInside)
        self.txtSchoolType.dropDownMode = .textPicker
        self.txtSchoolType.itemList = Utility.shared.schoolType
    }
    @objc func Back() {
        //self.navigationController?.popViewController(animated: true)
    }
    @objc func Submit(_ button:UIButton) {
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        if !(txtFirstName.text?.isEmpty ?? false) {
            let Inputcharatcter = CharacterSet.init(charactersIn: self.txtFirstName.text ?? "")
            let Characters = CharacterSet.init(charactersIn: allowedCharacters)
            if Characters.isSuperset(of: Inputcharatcter) {
                if !(txtLastname.text?.isEmpty ?? false) {
                    let Inputcharatcter = CharacterSet.init(charactersIn: self.txtLastname.text ?? "")
                    let Characters = CharacterSet.init(charactersIn: allowedCharacters)
                     
                        if !(txtSchoolMascot.text?.isEmpty ?? false) {
                            if !(city.text?.isEmpty ?? false) {
                                if !(state.text?.isEmpty ?? false) {
                                    if !(txtZipCode.text?.isEmpty ?? false) {
                                        if !(txtemailaddress.text?.isEmpty ?? false) {
                                            if (self.txtemailaddress.text?.count ?? 0) > 0 {
                                                if self.txtemailaddress.text?.isValidEmail() ?? false {
                                                    if !(txtPhone.text?.isEmpty ?? false) {
                                                        if self.txtSchoolType.selectedItem != nil {
                                                            self.createSchool()
                                                        }else {
                                                            RDalertcontoller().presentAlertWithMessage(Message:"Please select school type",onVc:self)
                                                        }
                                                    } else {
                                                        RDalertcontoller().presentAlertWithMessage(Message:"Please enter phone number",onVc:self)
                                                    }
                                                } else {
                                                    RDalertcontoller().presentAlertWithMessage(Message:"Please enter valid email",onVc:self)
                                                }
                                            } else {
                                                RDalertcontoller().presentAlertWithMessage(Message:"Please enter email",onVc:self)
                                            }
                                        } else {
                                            RDalertcontoller().presentAlertWithMessage(Message:"Please enter state",onVc:self)
                                        }
                                    } else {
                                        RDalertcontoller().presentAlertWithMessage(Message:"Please enter state",onVc:self)
                                    }
                                } else {
                                    RDalertcontoller().presentAlertWithMessage(Message:"Please enter state",onVc:self)
                                }
                            } else {
                                RDalertcontoller().presentAlertWithMessage(Message:"Please enter city",onVc:self)
                            }
                        } else  {
                            RDalertcontoller().presentAlertWithMessage(Message:"Please enter school mascot",onVc:self)
                        }
                    
                } else {
                    RDalertcontoller().presentAlertWithMessage(Message:"Please enter first name",onVc:self)
                }
            } else {
                RDalertcontoller().presentAlertWithMessage(Message:"Please enter valid name",onVc:self)
            }
        } else {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter first name",onVc:self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        BackView.AddDefaultShadow()
    }
}
//MARK:- webservice
extension CreateSchoolRequestVC {
    func createSchool() {
        let serviceManager = ServiceManager<School>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "school"
        serviceManager.Parameters = [
            "firstname":self.txtFirstName.text ?? "",
            "lastname":self.txtLastname.text ?? "",
            "email":txtemailaddress.text ?? "",
            "school_mascot":txtSchoolMascot.text ?? "",
            "the_name_of_your_school":self.txtschoolname.text ?? "",
            "city":city.text ?? "",
            "state":state.text ?? "",
            "zip_code":txtZipCode.text ?? "",
            "phone":txtPhone.text ?? "",
            "school_type":self.txtSchoolType.selectedItem ?? ""
        ]
        
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let school = Response as? ResponseModelDic<School>
            Print(object: school)
            self.createSchoolForUser(SchoolID: school?.Data?.id ?? 0)
        }
    }
    func createSchoolForUser(SchoolID:Int) {
        let serviceManager = ServiceManager<School>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "school-user"
        serviceManager.Parameters = [
            "school_id":SchoolID
        ]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            do{
            let school = Response as? ResponseModelDic<School>
            
            UserDefaults.standard.set(self.txtschoolname.text, forKey: "SchoolName")
            
                User.shared.schoolID = school?.Data?.id ?? 0
                User.shared.schoolName = self.txtschoolname.text
                if(User.shared.schoolusers?.count ?? 0  > 0){
                    User.shared.schoolusers?[0].school?.theNameOfYourSchool = self.txtschoolname.text
                }else{
                    let school = Schooluser.init(id: nil, userID: nil, schoolID: nil, createdAt: nil, updatedAt: nil, school: UserSchool.init(id: nil, firstname: nil, lastname: nil, userID: nil, theNameOfYourSchool: self.txtschoolname.text, schoolMascot: nil, email: nil, phone: nil, city: nil, state: nil, zipCode: nil, country: nil, address: nil, latitude: nil, longitude: nil, createdAt: nil, updatedAt: nil))
                    
                    User.shared.schoolusers?.insert(school, at: 0)
                }
                
            let data = try JSONEncoder().encode(User.shared)
            UserDefaults.standard.set(data, forKey: "User")
            
            if self.from == "Accounts"
            {
                
                let tpl : (Int,String) = (school?.Data?.id ?? 0, self.txtschoolname.text ?? "")
                
                Utility.shared.accountSchoolInfo = tpl
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThankYouVC") as? ThankYouVC else { return }
                vc.tplSchoolDetail = (self.city.text ?? nil, self.state.text ??  nil,self.txtZipCode.text ?? nil)
                vc.isFromMyAccount = true
                self.navigationController?.show(vc, sender: nil)
            }
            else
            {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThankYouVC") as? ThankYouVC else { return }
                vc.tplSchoolDetail = (self.city.text ?? nil, self.state.text ??  nil,self.txtZipCode.text ?? nil)
                self.navigationController?.show(vc, sender: nil)
            }
            
            }catch  {
                let error = error as? EncodingError
                print(error?.failureReason ?? "")
            
            }
        }
    }
}
