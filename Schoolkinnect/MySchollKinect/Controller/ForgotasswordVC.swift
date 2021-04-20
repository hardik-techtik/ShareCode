//
//  ForgotasswordVC.swift
//  MySchollKinect
//
//  Created by Admin on 06/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ForgotasswordVC: UIViewController {
    @IBOutlet weak var ttxEmail: RDTextField!
    @IBOutlet weak var btnSubmit: CornerButton!
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSubmit.addTarget(self, action: #selector(Changepassword(_:)), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backView.AddDefaultShadow()
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    @objc func Changepassword(_ button:UIButton) {
        if (ttxEmail.text?.count ?? 0) > 0 {
            if self.isValidEmail(ttxEmail.text ?? "") {
                self.ForgotPassword()
            } else {
                RDalertcontoller().presentAlertWithMessage(Message:"Pleaase enter proper email",onVc:self)
            }
        } else {
             RDalertcontoller().presentAlertWithMessage(Message:"Please enter email",onVc:self)
        }
    }
}
//MARK:- webServices
extension ForgotasswordVC {
    func ForgotPassword() {
        let serviceManager = ServiceManager<ResponseModelSuccess>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "forgot-password"
        serviceManager.HandleResponse = false
        serviceManager.Parameters = [
            "email":self.ttxEmail.text ?? ""
        ]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let Respose = Response as? ResponseModelSuccess
            if (Respose?.statusCode ?? 0) == 200 {
                self.navigationController?.popViewController(animated: true)
                RDalertcontoller().presentAlertWithMessage(Message:Respose?.errorMsg ?? "",onVc:self)
            }else {
                RDalertcontoller().presentAlertWithMessage(Message:Respose?.errorMsg ?? "Entered email address not found.",onVc:self)
            }
        }
    }
}
