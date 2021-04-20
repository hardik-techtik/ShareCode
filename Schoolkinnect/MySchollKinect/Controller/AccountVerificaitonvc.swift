//
//  AccountVerificaitonvc.swift
//  MySchollKinect
//
//  Created by Admin on 25/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit


class AccountVerificaitonvc: UIViewController {

    @IBOutlet weak var backvierw: UIView!
    @IBOutlet weak var btnSignin: CornerButton!
    @IBOutlet weak var btnVerification: CornerButton!
    @IBOutlet weak var btnSendSignin: CornerButton!
    @IBOutlet weak var btnReSend: CornerButton!
    
    @IBOutlet weak var txtfld1: UITextField!
    @IBOutlet weak var txtfld2: UITextField!
    @IBOutlet weak var txtfld3: UITextField!
    @IBOutlet weak var txtfld4: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignin.addTarget(self, action: #selector(verifyOTP(_:)), for: .touchUpInside)
        self.btnReSend.addTarget(self, action: #selector(ResendOTP), for: .touchUpInside)
    }
    
    
    @objc func SignIN(_ button:UIButton)
    {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as? HomeScreenVC else { return }
        self.navigationController?.show(vc, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtfld1.delegate = self
        txtfld2.delegate = self
        txtfld3.delegate = self
        txtfld4.delegate = self
        
        txtfld1.layer.cornerRadius = txtfld1.bounds.height / 2
        txtfld1.layer.borderWidth = 1
        txtfld1.layer.borderColor = UIColor(hexFromString: "EFEDF7").cgColor
        
        txtfld2.layer.cornerRadius = txtfld2.bounds.height / 2
        txtfld2.layer.borderWidth = 1
        txtfld2.layer.borderColor = UIColor(hexFromString: "EFEDF7").cgColor
        
        txtfld3.layer.cornerRadius = txtfld3.bounds.height / 2
        txtfld3.layer.borderWidth = 1
        txtfld3.layer.borderColor = UIColor(hexFromString: "EFEDF7").cgColor
        
        txtfld4.layer.cornerRadius = txtfld4.bounds.height / 2
        txtfld4.layer.borderWidth = 1
        txtfld4.layer.borderColor = UIColor(hexFromString: "EFEDF7").cgColor
    }
    
    func getEnteredPin()-> String?
    {
        let digit1 = self.txtfld1.text ?? ""
        let digit2 = self.txtfld2.text ?? ""
        let digit3 = self.txtfld3.text ?? ""
        let digit4 = self.txtfld4.text ?? ""
        
        if !(digit1.isEmpty ?? false) && !(digit1.isEmpty ?? false) && !(digit1.isEmpty ?? false) && !(digit4.isEmpty ?? false)
        {
            return digit1 + digit2 + digit3 + digit4
        }
        return nil
    }
    
    @objc func verifyOTP(_ button:UIButton) {
        if (txtfld1.text?.isEmpty)! || (txtfld2.text?.isEmpty)! || (txtfld3.text?.isEmpty)! || (txtfld4.text?.isEmpty)! {
            RDalertcontoller().presentAlertWithMessage(Message:"Enter Valid OTP",onVc:self)
        } else {
            let serviceManager = ServiceManager<ResponseModelSuccess>.init()
            serviceManager.ShowLoader = true
            serviceManager.ServiceName = "otp-user"
            serviceManager.HandleResponse = false
            serviceManager.Parameters = [
                "otp":getEnteredPin() ?? "",
            ]
            serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchoolSearchVC") as? SchoolSearchVC else {return}
                self.navigationController?.setViewControllers([vc], animated: true)
            }
        }
    }
}

//MARK: WebService
extension AccountVerificaitonvc {
    @objc func ResendOTP() {
        let serviceManager = ServiceManager<ResponseModelSuccessStatus>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "resend-otp"
        
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let Respose = Response as? ResponseModelSuccessStatus
            Print(object: Respose)
            RDalertcontoller().presentAlertWithMessage(Message:Respose?.Data ?? "",onVc:self)
        }
    }
}
// MARK:  - UITextFieldDelegate - 
extension AccountVerificaitonvc : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = ""
        
        if textField.text == "" {
            debugPrint("Backspace has been pressed")
        }
        if textField.text == " " && string.length() == 0 {
            debugPrint("Backspace has been pressed")
            switch textField {
            case txtfld2:
                txtfld1.isSecureTextEntry = false
                txtfld1.becomeFirstResponder()
            case txtfld3:
                txtfld2.isSecureTextEntry = false
                txtfld2.becomeFirstResponder()
            case txtfld4:
                txtfld3.isSecureTextEntry = false
                txtfld3.becomeFirstResponder()
            
            default:
                debugPrint("default")
            }
            textField.text = " "
            return false
        } else if string == "" {
            debugPrint("Backspace was pressed")
            switch textField {
            case txtfld2:
                txtfld1.isSecureTextEntry = false
                txtfld1.becomeFirstResponder()
            case txtfld3:
                txtfld2.isSecureTextEntry = false
                txtfld2.becomeFirstResponder()
            case txtfld4:
                txtfld3.isSecureTextEntry = false
                txtfld3.becomeFirstResponder()
            
            default:
                debugPrint("default")
            }
            textField.text = ""
            return false
        } else {
            
            textField.text = string
            switch textField {
            case txtfld1:
                txtfld1.isSecureTextEntry = true
                txtfld2.becomeFirstResponder()
            case txtfld2:
                txtfld2.isSecureTextEntry = true
                txtfld3.becomeFirstResponder()
            case txtfld3:
                txtfld3.isSecureTextEntry = true
                txtfld4.becomeFirstResponder()
            case txtfld4:
                txtfld3.isSecureTextEntry = true
                self.view.endEditing(true)
                break
            default:
                debugPrint("default")
            }
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
