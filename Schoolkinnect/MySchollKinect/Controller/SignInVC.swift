//
//  SignInVC.swift
//  MySchollKinect
//
//  Created by Admin on 24/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import AuthenticationServices

class SignInVC: UIViewController {
    
    @IBOutlet weak var txtUserName: RDTextField!
    @IBOutlet weak var txtPassword: RDTextField!
    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnsignIn: CornerButton!
    @IBOutlet weak var signinWithFacebook: CornerButton!
    @IBOutlet weak var SigninWithapple: CornerButton!
    @IBOutlet weak var createNewAccount: CornerButton!
    @IBOutlet weak var LoginwithPasscode: CornerButton!
    
    @IBOutlet weak var btnCreateCoount: CornerButton!
    @IBOutlet weak var btnForgotPassword: CornerButton!
    @IBOutlet weak var btnTermsOfuse: UIButton!
    @IBOutlet weak var btnPrivacypolicy: UIButton!
    @IBOutlet weak var btnPasswordShowHidse: UIButton!
    
    let forGroundColor = UIColor.init(red: 182/255, green: 103/255, blue: 52/255, alpha: 1)
    let app = UIApplication.shared.delegate as! AppDelegate
    
    let Manager = LoginManager.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if User.shared.useFourDigitPin == nil {
        //            self.LoginwithPasscode.isHidden = true
        //        } else {
        //            self.LoginwithPasscode.isHidden = false
        //        }
        self.LoginwithPasscode.addTarget(self, action: #selector(loginWithPasscode(_:)), for: .touchUpInside)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        
        guard let Termsrange = ("By proceeding you also agree to the Terms of Use and Privacy Policy" as NSString?)?.range(of:"Terms of Use") else {return}
        
        guard let PrivacyRange = ("By proceeding you also agree to the Terms of Use and Privacy Policy" as NSString?)?.range(of:"Privacy Policy") else {return}
        
        let FullRange = ("By proceeding you also agree to the Terms of Use and Privacy Policy" as NSString).range(of: "By proceeding you also agree to theTerms of Use and Privacy Policy")
        
        let AttriButtedString = NSMutableAttributedString.init(string: "By proceeding you also agree to the Terms of Use and Privacy Policy")
        
        AttriButtedString.addAttributes([NSAttributedString.Key.foregroundColor : forGroundColor], range: Termsrange)
        AttriButtedString.addAttributes([NSAttributedString.Key.foregroundColor : forGroundColor], range: PrivacyRange)
        AttriButtedString.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: FullRange)
        
        //self.lblPrivacyPolicy.attributedText = AttriButtedString
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(didTapLabel(_:)))
        self.lblPrivacyPolicy.addGestureRecognizer(tap)
        
        lblPrivacyPolicy.isUserInteractionEnabled = true
        
        self.btnsignIn.addTarget(self, action: #selector(signIN(_:)), for: .touchUpInside)
        
        self.signinWithFacebook.addTarget(self, action: #selector(LoginWithFacebook(_:)), for: .touchUpInside)
        if #available(iOS 13.0, *) {
            self.SigninWithapple.addTarget(self, action: #selector(performExistingAccountSetupFlows(_:)), for: .touchUpInside)
        }
        self.createNewAccount.addTarget(self, action: #selector(CreateAccount(_:)), for: .touchUpInside)
        self.btnForgotPassword.addTarget(self, action: #selector(ForgotPassword(_:)), for: .touchUpInside)
        self.btnPrivacypolicy.addTarget(self, action: #selector(PrivacyPolicy(_:)), for: .touchUpInside)
        self.btnTermsOfuse.addTarget(self, action: #selector(TermsofUse(_:)), for: .touchUpInside)
        
        btnPasswordShowHidse.addTarget(self, action: #selector(passwordShowHide(_:)), for: .touchUpInside)
        
        
        
    }
    @IBAction func btnHelpClick(_ sender: Any) {
        let StoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = StoryBoard.instantiateViewController(withIdentifier: "HelpCenterVC") as? HelpCenterVC else {return}
        vc.isFromBlock = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func passwordShowHide(_ button:UIButton) {
        self.txtPassword.isSecureTextEntry = !self.txtPassword.isSecureTextEntry
        if self.txtPassword.isSecureTextEntry {
            self.btnPasswordShowHidse.setBackgroundImage(UIImage.init(named: "passwordHide"), for: .normal)
        } else {
            self.btnPasswordShowHidse.setBackgroundImage(UIImage.init(named: "passwordShow"), for: .normal)
        }
    }
    
    @objc func PrivacyPolicy(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVc") as? PrivacyPolicyVc else {return}
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func TermsofUse(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsOfUseVC") as? TermsOfUseVC else {return}
        self.navigationController?.show(vc, sender: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.backView.AddDefaultShadow()
        
        UserDefaults.standard.removeObject(forKey: "User")
        UserDefaults.standard.removeObject(forKey: "SchoolName")
    }
    
    @objc func loginWithPasscode(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterPasscodeVC") as? EnterPasscodeVC else {return}
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func ForgotPassword(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotasswordVC") as? ForgotasswordVC else {return}
        self.navigationController?.show(vc, sender: nil)
    }
    @objc func CreateAccount(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as? CreateProfileVC else {return}
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func LoginWithFacebook(_ button:UIButton) {
        
        self.Manager.logOut()
        
        Manager.logIn(permissions: ["public_profile","email"], from: self) { (Result, Error) in
            if Error == nil {
                if Result?.isCancelled ?? false {
                    print("Cancel")
                } else {
                    let app = UIApplication.shared.delegate as! AppDelegate
                    app.LoggedinWith = .Facebook
                    self.LoginWithFacebook()
                }
            } else  {
                RDalertcontoller().presentAlertWithMessage(Message:Error?.localizedDescription ?? "",onVc:self)
            }
        }
    }
    
    
    
    @available(iOS 13.0, *)
    @objc func performExistingAccountSetupFlows(_ button:UIButton)  {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    @available(iOS 13.0, *)
    @objc func LoginWithapple(_ button:UIButton) {
        let Provider = ASAuthorizationAppleIDProvider.init()
        let Request = Provider.createRequest()
//        let Request = [ASAuthorizationAppleIDProvider().createRequest(),
//         ASAuthorizationPasswordProvider().createRequest()]
        Request.requestedScopes = [.email,.fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [Request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "TTS.MySchollKinect", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    @objc func Back() {
        //self.navigationController?.popViewController(animated: true)
    }
    
    @objc func signIN(_ button:UIButton) {
        if (self.txtUserName.text?.count ?? 0) > 0  {
            if (self.txtPassword.text?.count ?? 0) > 0 {
                self.Login()
            } else  {
                RDalertcontoller().presentAlertWithMessage(Message:"Please enter password",onVc:self)
            }
        }  else {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter username",onVc:self)
        }
    }
    
    @objc func didTapLabel(_ tap:UITapGestureRecognizer) {
        guard let Termsrange = ("By proceeding you also agree to the Terms of Use and Privacy Policy" as NSString?)?.range(of:"Terms of Use") else {return}
        guard let PrivacyRange = ("By proceeding you also agree to the Terms of Use and Privacy Policy" as NSString?)?.range(of:"Privacy Policy") else {return}
        if tap.didTapAttributedTextInLabel(label: self.lblPrivacyPolicy, inRange: Termsrange) {
            print("terms")
        } else if tap.didTapAttributedTextInLabel(label: self.lblPrivacyPolicy, inRange: PrivacyRange) {
            print("rnge")
        }
    }
}
@available(iOS 13.0, *)
extension SignInVC:ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
                // Create an account in your system.
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                self.saveUserInKeychain(userIdentifier)
                if UserDefaults.standard.value(forKey: "AppleUser") == nil {
                    do {
                        AppleUser.shared.userIdentifier = userIdentifier
                        AppleUser.shared.fullName = "\(String(describing: fullName?.givenName ?? "")) \(String(describing: fullName?.familyName ?? ""))"
                        AppleUser.shared.email = email
                        let data = try JSONEncoder.init().encode(AppleUser.shared)
                        UserDefaults.standard.set(data, forKey: "AppleUser")
                    } catch  {
                        Print(object: error)
                    }
                } else {
                    guard let data = UserDefaults.standard.data(forKey: "AppleUser") else {return}
                    do {
                        let User = try JSONDecoder.init().decode(AppleUser.self, from: data)
                        AppleUser.shared = User
                    } catch  {
                        print(error)
                    }
                }
                
                self.LoginWithApple()
                
            case let passwordCredential as ASPasswordCredential:
                
                let username = passwordCredential.user
                let password = passwordCredential.password
                
                // For the purpose of this demo app, show the password credential as an alert.
                DispatchQueue.main.async {
                    
                }
                
            default:
                break
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //        RDalertcontoller().presentAlertWithMessage(Message:error.localizedDescription,onVc:self)
        if !(error.localizedDescription.contains("1001")){
            
            self.LoginWithapple(self.SigninWithapple)
        }
      
       
    }
    
}
extension SignInVC {
    func Login() {
        let serviceManager = ServiceManager<User>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "login"
        
        serviceManager.Parameters = [
            "email":self.txtUserName.text ?? "",
            "password":self.txtPassword.text ?? "",
            "device_token": UserDefaults.standard.object(forKey: "fcmToken") as? String ?? ""
        ]
        
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let user = Response as? ResponseModelDic<User>
            User.Token = user?.token ?? ""
            User.shared = user?.Data ?? User.shared
            UserDefaults.standard.set(user?.token, forKey: "logintoken")
            UserDefaults.standard.set(user?.Data?.id ?? 0, forKey: "loginUserID")
            UserDefaults.standard.synchronize()
            do{
                let data = try JSONEncoder().encode(User.shared)
                UserDefaults.standard.set(data, forKey: "User")
                //                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchoolSearchVC") as? SchoolSearchVC else {return}
                //                self.navigationController?.setViewControllers([vc], animated: true)
                //if (User.shared.isVerifiedOtp != nil) {
                if User.shared.schoolID != nil {
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as? HomeScreenVC else {return}
                    self.navigationController?.setViewControllers([vc], animated: true)
                    //                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountVerificaitonvc") as? AccountVerificaitonvc else {return}
                    //                        self.navigationController?.setViewControllers([vc], animated: true)
                    
                    SocketHelper.shared.connect()
                    
                    SocketHelper.shared.socket.emitWithAck("login", with: [User.shared.id ?? 0]).timingOut(after: 2.0) { (res) in
                        Print(object: res)
                    }
                    
                } else {
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchoolSearchVC") as? SchoolSearchVC else {return}
                    self.navigationController?.setViewControllers([vc], animated: true)
                }
                //}
                /*else {
                 guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountVerificaitonvc") as? AccountVerificaitonvc else {return}
                 self.navigationController?.setViewControllers([vc], animated: true)
                 }*/
            } catch {
                let error = error as? EncodingError
                print(error?.failureReason ?? "")
            }
            print(User.shared)
        }
    }
    
    func LoginWithFacebook() {
        let serviceManager = ServiceManager<User>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "social-media-register"
        
        serviceManager.Parameters = [
            "provider":"facebook",
            "social_token":AccessToken.current?.tokenString ?? "",
            "device_token": UserDefaults.standard.object(forKey: "fcmToken") as? String ?? ""
        ]
        
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            
            let user = Response as? ResponseModelDic<User>
            User.Token = user?.token ?? ""
            User.shared = user?.Data ?? User.shared
            
            UserDefaults.standard.set(user?.token, forKey: "logintoken")
            UserDefaults.standard.set(true, forKey: "isSocialLogin")
            
            do {
                let data = try JSONEncoder().encode(User.shared)
                UserDefaults.standard.set(data, forKey: "User")
                
                print("------ data is --- \(data)")
                
                if User.shared.schoolID != nil {
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as? HomeScreenVC else {return}
                    self.navigationController?.setViewControllers([vc], animated: true)
                    self.Manager.logOut()
                    /*SocketHelper.shared.socket.emitWithAck("login", with: [User.shared.id ?? 0]).timingOut(after: 2.0) { (res) in
                     print(res)
                     }*/
                }else {
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as? CreateProfileVC else {return}
                    vc.isSocialMedia = true
                    //self.navigationController?.setViewControllers([vc], animated: true)
                    self.navigationController?.show(vc, sender: nil)
                }
                
                /*if User.shared.schoolID != nil  {
                 guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as? HomeScreenVC else {return}
                 self.navigationController?.setViewControllers([vc], animated: true)
                 self.Manager.logOut()
                 SocketHelper.shared.socket.emitWithAck("login", with: [User.shared.id ?? 0]).timingOut(after: 2.0) { (res) in
                 print(res)
                 }
                 } else {
                 guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchoolSearchVC") as? SchoolSearchVC else {return}
                 self.navigationController?.setViewControllers([vc], animated: true)
                 }*/
            } catch {
                let error = error as? EncodingError
                print(error?.failureReason ?? "")
            }
            print(User.shared)
        }
    }
    
    func LoginWithApple() {
        let serviceManager = ServiceManager<User>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "signup-apple"
        serviceManager.Parameters = [
            "apple_id":AppleUser.shared.userIdentifier ?? "",
            "email":AppleUser.shared.email ?? "",
            "first_name":AppleUser.shared.fullName ?? "",
            "device_token": UserDefaults.standard.object(forKey: "fcmToken") as? String ?? ""
        ]
        
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let user = Response as? ResponseModelDic<User>
            User.shared = user?.Data ?? User.shared
            User.Token = user?.token ?? ""
            UserDefaults.standard.set(user?.token, forKey: "logintoken")
            UserDefaults.standard.set(true, forKey: "isSocialLogin")
            do {
                let data = try JSONEncoder().encode(User.shared)
                UserDefaults.standard.set(data, forKey: "User")
                
                if User.shared.schoolID != nil {
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as? HomeScreenVC else {return}
                    self.navigationController?.setViewControllers([vc], animated: true)
                    self.Manager.logOut()
                    /*SocketHelper.shared.socket.emitWithAck("login", with: [User.shared.id ?? 0]).timingOut(after: 2.0) { (res) in
                     print(res)
                     }*/
                }else {
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as? CreateProfileVC else {return}
                    vc.isSocialMedia = true
                    self.navigationController?.show(vc, sender: nil)
                }
                
                /*if User.shared.schoolID != nil {
                 guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as? HomeScreenVC else {return}
                 self.navigationController?.setViewControllers([vc], animated: true)
                 }  else {
                 guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchoolSearchVC") as? SchoolSearchVC else {return}
                 self.navigationController?.setViewControllers([vc], animated: true)
                 }*/
            } catch {
                let error = error as? EncodingError
                print(error?.failureReason ?? "")
            }
            print(User.shared)
        }
    }   
}
