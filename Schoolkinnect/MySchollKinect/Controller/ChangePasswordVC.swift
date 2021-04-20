//
//  ChangePasswordVC.swift
//  MySchollKinect
//
//  Created by Admin on 06/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseVC {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var txtCurrentPassword: RDTextField!
    @IBOutlet weak var ttxChangePassword: RDTextField!
    @IBOutlet weak var txtConfirmPassword: RDTextField!
    @IBOutlet weak var btnSubmit: CornerButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backView.AddDefaultShadow()
        self.btnSubmit.addTarget(self, action: #selector(Submit(_:)), for: .touchUpInside)
    }
    @objc func Submit(_ button:UIButton) {
        if (txtCurrentPassword.text?.count ?? 0) > 0 {
            if (ttxChangePassword.text?.count ?? 0) > 0 {
                if (txtConfirmPassword.text?.count ?? 0) > 0 {
                    if ttxChangePassword.text == txtConfirmPassword.text {
                        self.ChangePassword()
                    } else {
                        RDalertcontoller().presentAlertWithMessage(Message:"Please enter same password again",onVc:self)
                    }
                } else {
                    RDalertcontoller().presentAlertWithMessage(Message:"Please enter same password again",onVc:self)
                }
            } else {
                RDalertcontoller().presentAlertWithMessage(Message:"Please enter new password",onVc:self)
            }
        } else {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter current password",onVc:self)
        }
    }
    
    @IBAction func actionCurrentPwdShow(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.txtCurrentPassword.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func actionNewPasswordShow(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        ttxChangePassword.isSecureTextEntry = !sender.isSelected
        txtConfirmPassword.isSecureTextEntry = !sender.isSelected
    }
    
    
}



extension ChangePasswordVC {
    func ChangePassword() {
        let serviceManager = ServiceManager<ResponseModelSuccess>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "change-Password"
        serviceManager.Parameters = [
                                    "password":self.txtCurrentPassword.text ?? "",
                                     "new_password":self.ttxChangePassword.text ?? "",
                                     "confirm_password":self.ttxChangePassword.text ?? ""
                ]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let response = Response as? ResponseModelDic<ResponseModelSuccess>
            self.navigationController?.popViewController(animated: true)
            RDalertcontoller().presentAlertWithMessage(Message:response?.errorMsg ?? "Password changed successfully" , onVc: self)
        }
    }
}
