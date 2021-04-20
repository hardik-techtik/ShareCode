//
//  SchoolSearchVC.swift
//  MySchollKinect
//
//  Created by Admin on 23/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SchoolSearchVC: BaseVC {

    @IBOutlet weak var txtCity: RDTextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var txtState: RDTextField!
    @IBOutlet weak var textZipCode: RDTextField!
    @IBOutlet weak var txtNameOfSchool: RDTextField!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtSchoolType: RDTextFieldDropDown!

    var schools:[Schools] = []
    var selectedschool:Schools?
    
    var UnhideBackbutton = false
    var from = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnSearch.layer.cornerRadius = self.btnSearch.frame.height/2
        self.btnSearch.layer.masksToBounds = true
        self.btnSearch.addTarget(self, action: #selector(SearchSchool(_:)), for: .touchUpInside)
        
        if UnhideBackbutton
        {
            self.btnBack.isHidden = false
        }
        else
        {
            self.btnBack.isHidden = true
        }
        
        self.txtSchoolType.dropDownMode = .textPicker
        self.txtSchoolType.itemList = Utility.shared.schoolType
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backView.AddDefaultShadow()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    @IBAction func gotoaddschool(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateSchoolRequestVC") as? CreateSchoolRequestVC else { return }
        vc.from = self.from
        self.navigationController?.show(vc, sender: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @IBAction func addschool(_ sender: Any) {
        
    }
    @objc func SearchSchool(_ button:UIButton) {
        if !(self.txtNameOfSchool.text?.isEmpty ?? false) || !(self.txtCity.text?.isEmpty ?? false) || !(self.txtState.text?.isEmpty ?? false) || !(self.textZipCode.text?.isEmpty ?? false) || ((self.txtSchoolType?.selectedItem) != nil) {

             self.getGetSearchsSchool()

        } else {
             RDalertcontoller().presentAlertWithMessage(Message:"Please enter any of the fields to search school",onVc:self)
        }
        //self.getGetSearchsSchool()
    }
}
extension SchoolSearchVC:UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
//MARK:SchoolDelegate
extension SchoolSearchVC:schoolDelegate {
    func didSelectSchool(school: Schools) {
        
    }
}
//MARK:- webservice
extension SchoolSearchVC {
    func getGetSearchsSchool() {
        let serviceManager = ServiceManager<schools>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "nearby"
        var params = [String:Any]()
        if !(txtCity.text?.isEmpty ?? false)
        {
            params["city"] = self.txtCity.text ?? ""
        }
        
        if !(txtState.text?.isEmpty ?? false)
        {
            params["state"] = self.txtState.text ?? ""
        }
        if !(textZipCode.text?.isEmpty ?? false)
        {
            params["zip_code"] = self.textZipCode.text ?? ""
        }
        if !(txtNameOfSchool.text?.isEmpty ?? false)
        {
            params["the_name_of_your_school"] = self.txtNameOfSchool.text ?? ""
        }
        
        if let schoolType = self.txtSchoolType.selectedItem {
            params["school_type"] = schoolType
        }
        
       serviceManager.Parameters = params
        
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let school = Response as? ResponseModelDic<schools>
            self.schools = school?.Data?.users ?? []
            print("------ \(school?.Data?.users ?? [])")
            if (school?.Data?.nearbySchools ?? 0) > 0 {
                /*let vc = searchSchoolvc.init()
                vc.School = self.schools
                vc.Delegate = self
                self.present(vc, animated: true, completion: nil)*/
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultsVC") as? SearchResultsVC else { return }
                //vc.selectedschool = school
                vc.schools = self.schools
                vc.from = self.from
                vc.UnhideBackbutton = self.UnhideBackbutton
                self.navigationController?.show(vc, sender: nil)
                
            } else {
                RDalertcontoller().presentAlertWithMessage(Message:"No schools found",onVc:self)
            }
        }
    }
}
