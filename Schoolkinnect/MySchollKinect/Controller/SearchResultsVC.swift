//
//  SearchResultsVC.swift
//  MySchollKinect
//
//  Created by Admin on 23/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import IQDropDownTextField


class SearchResultsVC: BaseVC {
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtScholl: RDTextFieldDropDown!
    @IBOutlet weak var backTOSearch: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var BackView: UIView!
    
    var schools:[Schools] = []
    var selectedschool:Schools?
    var UnhideBackbutton = false
    var from : String = ""
    
    @IBOutlet weak var sendRequest: CornerButton!
    let Picker = Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?.last as? CustomPicker
    
    let PickerData = ["test","test","test","test","test","test","test","test","test"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNext.addTarget(self, action: #selector(Next(_:)), for: .touchUpInside)
        
        Picker?.btnCancel.addTarget(self, action: #selector(CancelPicker(_:)), for: .touchUpInside)
        Picker?.btnOk.addTarget(self, action: #selector(DoneSelection(_:)), for: .touchUpInside)
        Picker?.DatePickerView.isHidden = true
        //self.backButton.addTarget(self, action: #selector(backButton(_:)), for: .touchUpInside)
        //        self.txtScholl.inputView = Picker
        //self.txtScholl.delegate = self
        //self.backButton.addTarget(self, action: #selector(backButton(_:)), for: .touchUpInside)
        //txtScholl.delegate = self
        backTOSearch.addTarget(self, action: #selector(backButton(_:)), for: .touchUpInside)
        //self.txtScholl.text = self.selectedschool?.theNameOfYourSchool
        
        self.txtScholl.itemList = self.schools.compactMap({$0.theNameOfYourSchool})
        self.txtScholl.selectedItem = self.selectedschool?.theNameOfYourSchool ?? ""
        self.txtScholl.delegate = self
        
        self.sendRequest.addTarget(self, action: #selector(sendRequest(_:)), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BackView.AddDefaultShadow()
        //IQKeyboardManager.shared.enable = false
        //IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //IQKeyboardManager.shared.enable = true
        //IQKeyboardManager.shared.enableAutoToolbar = true
    }
    @objc func Next(_ button:UIButton) {
        if self.UnhideBackbutton
        {
            /*for vc in self.navigationController?.viewControllers ?? []
            {
                if vc is AccountsVC
                {
                    let tpl : (Int,String) = (self.selectedschool?.id ?? 0, self.selectedschool?.theNameOfYourSchool ?? "")
                    
                    Utility.shared.accountSchoolInfo = tpl
                        
                    self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }*/
            let tpl : (Int,String) = (self.selectedschool?.id ?? 0, self.selectedschool?.theNameOfYourSchool ?? "")
            
            Utility.shared.accountSchoolInfo = tpl
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeCollegeVC") as? WelcomeCollegeVC else { return }
            vc.selectedschool = self.selectedschool
            vc.tplSchoolDetail = (self.selectedschool?.city ?? nil, self.selectedschool?.state ??  nil,self.selectedschool?.zipCode ?? nil)
            vc.isFromMyAccount = true
            self.navigationController?.show(vc, sender: nil)
            
            /*guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThankYouVC") as? ThankYouVC else { return }
            vc.selectedschool = self.selectedschool
            vc.tplSchoolDetail = (self.selectedschool?.city ?? nil, self.selectedschool?.state ??  nil,self.selectedschool?.zipCode ?? nil)
            vc.isFromMyAccount = true
            self.navigationController?.show(vc, sender: nil)*/
            
        }else {
            self.createSchoolForUser(SchoolID: self.selectedschool?.id ?? 0)
        }
        
    }
    @objc func backButton(_ button:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func CancelPicker(_ button:UIButton) {
        self.view.endEditing(true)
    }
    
    @objc func DoneSelection(_ button:UIButton) {
        let index = self.Picker?.Picker.selectedRow(inComponent: 0) ?? 0
        let SelectedValue = PickerData[index]
        print(SelectedValue)
        print(index)
    }
    @objc func sendRequest(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateSchoolRequestVC") as? CreateSchoolRequestVC else { return }
        vc.from = self.from
        self.navigationController?.show(vc, sender: nil)
    }
}

extension SearchResultsVC : IQDropDownTextFieldDelegate {
    
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        if let item = item {
            self.selectedschool = self.schools[self.txtScholl.selectedRow]
            self.txtScholl.selectedItem = self.selectedschool?.theNameOfYourSchool ?? ""
        }
    }
}

//MARK: school Delegate
extension SearchResultsVC:schoolDelegate {
    
    func didSelectSchool(school: Schools) {
        //self.selectedschool = school
        //self.txtScholl.selectedItem = self.selectedschool?.theNameOfYourSchool
    }
}

/*//MARK: textfieldDelegate
extension SearchResultsVC:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField)
        let vc = searchSchoolvc.init()
        vc.School = self.schools
        vc.Delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}*/
//MARK: webservices
extension SearchResultsVC {
    func createSchoolForUser(SchoolID:Int) {
        let serviceManager = ServiceManager<School>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "school-user"
        serviceManager.Parameters = [
            "school_id":self.selectedschool?.id ?? ""
        ]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            do {
                
                let school = Response as? ResponseModelDic<School>
                
                //Print(object: school)
                //User.shared.schoolID = school?.Data?.first?.id ?? 0
                User.shared.schoolID = school?.Data?.id ?? 0
                User.shared.schoolName = self.txtScholl.selectedItem
                
                //User.shared.schoolusers?[0].school?.theNameOfYourSchool = self.txtScholl.selectedItem ?? ""
                
                UserDefaults.standard.set(self.txtScholl.selectedItem, forKey: "SchoolName")
                
                let data = try JSONEncoder().encode(User.shared)
                UserDefaults.standard.set(data, forKey: "User")
                
                if self.UnhideBackbutton
                {
                    /*for vc in self.navigationController?.viewControllers ?? []
                    {
                        if vc is AccountsVC
                        {
                            self.navigationController?.popToViewController(vc, animated: true)
                            break
                        }
                    }*/
                    
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThankYouVC") as? ThankYouVC else { return }
                    vc.selectedschool = self.selectedschool
                    vc.tplSchoolDetail = (self.selectedschool?.city ?? nil, self.selectedschool?.state ??  nil,self.selectedschool?.zipCode ?? nil)
                    vc.isFromMyAccount = true
                    self.navigationController?.show(vc, sender: nil)
                }
                else
                {
                    /*guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThankYouVC") as? ThankYouVC else { return }
                    vc.selectedschool = self.selectedschool
                    self.navigationController?.show(vc, sender: nil)*/
                    
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeCollegeVC") as? WelcomeCollegeVC else { return }
                    vc.selectedschool = self.selectedschool
                    vc.tplSchoolDetail = (self.selectedschool?.city ?? nil, self.selectedschool?.state ??  nil,self.selectedschool?.zipCode ?? nil)
                    self.navigationController?.show(vc, sender: nil)
                    
                }
                
            }catch  {
                let error = error as? EncodingError
                print(error?.failureReason ?? "")
            
            }
            
            }
            
    }
}
