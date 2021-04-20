//
//  CreateProfileVC.swift
//  MySchollKinect
//
//  Created by Admin on 25/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import IQKeyboardManagerSwift
import IQDropDownTextField
import CoreLocation
import Contacts
import AddressBook
import UserNotifications

extension String {
    func isValidEmail() -> Bool {
        
        let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

class CreateProfileVC: BaseVC, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var BackView: UIView!
    @IBOutlet weak var btnnext: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnFinished: CornerButton!
    
    @IBOutlet weak var txtFirstname: RDTextField!
    @IBOutlet weak var txtLastName: RDTextField!
    @IBOutlet weak var txtDob: RDTextFieldDropDown!
    @IBOutlet weak var txtGender: RDTextFieldDropDown!
    @IBOutlet weak var relationShipStatus: RDTextFieldDropDown!
    
    @IBOutlet weak var txtSchoolMajor: RDTextField!
    @IBOutlet weak var txtSchoolMinor: RDTextField!
    @IBOutlet weak var txtExpectedGraduationDate: RDTextFieldDropDown!
    @IBOutlet weak var txtSchoolClasification: RDTextFieldDropDown!
    @IBOutlet weak var txtConfirmPassword: RDTextField!
    @IBOutlet weak var imgVwAdditional: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtInterests: RDTextView!
    @IBOutlet weak var txtAboutMe: RDTextView!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnContactList: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var txtPassword: RDTextField!
    @IBOutlet weak var txtEmail: RDTextField!
    @IBOutlet weak var btn4Pin: UIButton!
    @IBOutlet weak var PinView: UIView!
    @IBOutlet weak var pinbottom: NSLayoutConstraint!
    @IBOutlet weak var PinViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topView: NSLayoutConstraint!
    //@IBOutlet weak var collectioView: UICollectionView!
    @IBOutlet weak var btnAdditionalPhotos: UIButton!
    @IBOutlet weak var btnPasswordShowHidse: UIButton!
    
    //let Gender = ["Male","Female"]
    //let RelationShip = ["Single","In Relationship"]
    //let schoolClassification = ["Freshman","Sophomore","Juniour","Seniour"]
    
    @IBOutlet weak var txtenterPin1: UITextField!
    @IBOutlet weak var txtenterPin3: UITextField!
    @IBOutlet weak var txtenterPin2: UITextField!
    @IBOutlet weak var txtenterPin4: UITextField!
    
    
    @IBOutlet weak var txtreEnterPin1: UITextField!
    @IBOutlet weak var txtreEnterPin2: UITextField!
    @IBOutlet weak var txtreEnterPin3: UITextField!
    @IBOutlet weak var txtreEnterPin4: UITextField!
    @IBOutlet weak var btnPrivacypolicy: UIButton!
    @IBOutlet weak var btnTermsOfuse: UIButton!
    
    var AddtoMorePhotos = false
    
    var use4Pin = false
    var UseNotification = false
    var UseLocation = false
    var UseContacts = false
    var selectedDate = Date()
    
    var isSocialMedia = false
    
    let Group = DispatchGroup.init()
    let locationMgr = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtPassword.isSecureTextEntry = true
        
        self.btnPrivacypolicy.addTarget(self, action: #selector(PrivacyPolicy(_:)), for: .touchUpInside)
        self.btnTermsOfuse.addTarget(self, action: #selector(TermsofUse(_:)), for: .touchUpInside)
        
        btnFinished.addTarget(self, action: #selector(finish(_:)), for: .touchUpInside)
        //        btnNotification.addTarget(self, action: #selector(Notification(_:)), for: .touchUpInside)
        //        btnLocation.addTarget(self, action: #selector(getLocation(_:)), for: .touchUpInside)
        //        btnContactList.addTarget(self, action: #selector(getcontact(_:)), for: .touchUpInside)
        btn4Pin.addTarget(self, action: #selector(User4Pin(_:)), for: .touchUpInside)
        
        self.PinView.isHidden = true
        
        self.btn4Pin.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
//        self.btnNotification.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
//        self.btnLocation.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
//        self.btnContactList.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
        
        self.imgVwAdditional.layer.cornerRadius = 25
        self.imgVwAdditional.masksToBounds = true
        self.imgVwAdditional.clipsToBounds = true
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.width / 2
        self.imgProfile.masksToBounds = true
        self.imgProfile.clipsToBounds = true
        self.imgProfile.accessibilityHint = "PlaceHolder"
        
        //self.btnProfile.accessibilityHint = "PlaceHolder"
        self.btnProfile.addTarget(self, action: #selector(ChoosePhotoForProfile(_:)), for: .touchUpInside)
        //self.collectioView.delegate = self
        //self.collectioView.dataSource = self
        
        self.btnAdditionalPhotos.addTarget(self, action: #selector(SelectSddionalPhotos(_:)), for: .touchUpInside)
        self.PinViewHeight.constant = 0
        self.topView.constant = 0
        //self.txtPin.style = .none
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        self.txtDob.dropDownMode = .datePicker
        self.txtDob.delegate = self
        self.txtDob.showDismissToolbar = true
        self.txtDob.dateFormatter = dateFormatter
        
        self.txtExpectedGraduationDate.dropDownMode = .datePicker
        self.txtExpectedGraduationDate.delegate = self
        self.txtExpectedGraduationDate.showDismissToolbar = true
        self.txtExpectedGraduationDate.dateFormatter = dateFormatter
        
        //self.txtDob?.datePicker.minimumDate = minimumDate
        self.txtDob?.datePicker.maximumDate = Calendar.current.date(byAdding: Calendar.Component.year, value: -4, to: Date())
        self.txtExpectedGraduationDate?.datePicker.minimumDate = Date()
        
        self.txtGender.itemList = Utility.shared.Gender
        self.relationShipStatus.itemList = Utility.shared.RelationShip
        self.txtSchoolClasification.itemList = Utility.shared.schoolClassification
        
        self.btnProfile.addTarget(self, action: #selector(Signin(_:)), for: .touchUpInside)
        
        btnPasswordShowHidse.addTarget(self, action: #selector(passwordShowHide(_:)), for: .touchUpInside)
        
        self.setUpData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        locationEnable
        //        contactEnable
        //        notificationEnable
        BackView.AddDefaultShadow()
        self.btnProfile.layer.cornerRadius = self.btnProfile.frame.height/2
        self.btnProfile.layer.masksToBounds = true
        //self.btnProfile.imageView?.contentMode = .scaleAspectFit
        self.btnAdditionalPhotos.layer.cornerRadius = 25
        self.btnAdditionalPhotos.layer.masksToBounds = true
        self.btnAdditionalPhotos.imageView?.contentMode = .scaleAspectFit
        
        txtenterPin1.delegate = self
        txtenterPin2.delegate = self
        txtenterPin3.delegate = self
        txtenterPin4.delegate = self
        
        txtenterPin1.layer.cornerRadius = txtenterPin1.bounds.height / 2
        txtenterPin1.layer.borderWidth = 1
        txtenterPin1.layer.borderColor = UIColor(hexFromString: "EFEDF7").cgColor
        
        txtenterPin2.layer.cornerRadius = txtenterPin2.bounds.height / 2
        txtenterPin2.layer.borderWidth = 1
        txtenterPin2.layer.borderColor = UIColor(hexFromString: "EFEDF7").cgColor
        
        txtenterPin3.layer.cornerRadius = txtenterPin3.bounds.height / 2
        txtenterPin3.layer.borderWidth = 1
        txtenterPin3.layer.borderColor = UIColor(hexFromString: "EFEDF7").cgColor
        
        txtenterPin4.layer.cornerRadius = txtenterPin4.bounds.height / 2
        txtenterPin4.layer.borderWidth = 1
        txtenterPin4.layer.borderColor = UIColor(hexFromString: "EFEDF7").cgColor
        
        txtreEnterPin1.delegate = self
        txtreEnterPin2.delegate = self
        txtreEnterPin3.delegate = self
        txtreEnterPin4.delegate = self
        
        txtreEnterPin1.layer.cornerRadius = txtreEnterPin1.bounds.height / 2
        txtreEnterPin1.layer.borderWidth = 1
        txtreEnterPin1.layer.borderColor = UIColor(hexFromString: "EFEDF7").cgColor
        
        txtreEnterPin2.layer.cornerRadius = txtreEnterPin2.bounds.height / 2
        txtreEnterPin2.layer.borderWidth = 1
        txtreEnterPin2.layer.borderColor = UIColor(hexFromString: "EFEDF7").cgColor
        
        txtreEnterPin3.layer.cornerRadius = txtreEnterPin3.bounds.height / 2
        txtreEnterPin3.layer.borderWidth = 1
        txtreEnterPin3.layer.borderColor = UIColor(hexFromString: "EFEDF7").cgColor
        
        txtreEnterPin4.layer.cornerRadius = txtreEnterPin4.bounds.height / 2
        txtreEnterPin4.layer.borderWidth = 1
        txtreEnterPin4.layer.borderColor = UIColor(hexFromString: "EFEDF7").cgColor
        
        let contactEnable = UserDefaults.standard.object(forKey: "contactEnable") as? Bool
        let locationEnable = UserDefaults.standard.object(forKey: "locationEnable") as? Bool
        let notificationEnable = UserDefaults.standard.object(forKey: "notificationEnable") as? Bool
        
        if contactEnable == true {
            self.btnContactList.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
        } else {
            self.btnContactList.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
        }
        if locationEnable == true {
            self.btnLocation.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
            
        } else {
            self.btnLocation.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
        }
        if notificationEnable == true {
                   self.btnNotification.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
                   
               } else {
                   self.btnNotification.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
               }
//        locationEnable == true ? self.btnLocation.setBackgroundImage(UIImage.init(named: "Check"), for: .normal) : self.btnLocation.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
//
//        notificationEnable == true ? self.btnNotification.setBackgroundImage(UIImage.init(named: "Check"), for: .normal) : self.btnNotification.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
        
    }
    
    func setUpData() {
        
        let notificationEnable = UserDefaults.standard.object(forKey: "notificationEnable") as? Bool
        if notificationEnable == true {
            self.btnNotification.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
            self.btnNotification.isSelected = true
        } else {
            self.btnNotification.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
            self.btnNotification.isSelected = false
        }
        
        if CLLocationManager.locationServicesEnabled() {
             switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    UserDefaults.standard.set(false, forKey: "locationEnable")
                self.btnLocation.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
                    self.btnLocation.isSelected = false
                case .authorizedAlways, .authorizedWhenInUse:
                    UserDefaults.standard.set(true, forKey: "locationEnable")
                self.btnLocation.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
                self.btnLocation.isSelected = true
             @unknown default:
                UserDefaults.standard.set(false, forKey: "locationEnable")
                self.btnLocation.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
                self.btnLocation.isSelected = false
            }
            } else {
                UserDefaults.standard.set(false, forKey: "locationEnable")
                self.btnLocation.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
            self.btnLocation.isSelected = false
        }
        
        /*let locationEnable = UserDefaults.standard.object(forKey: "locationEnable") as? Bool
        if locationEnable == true {
            self.btnLocation.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
        } else {
            self.btnLocation.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
        }*/
        
        let contactEnable = UserDefaults.standard.object(forKey: "contactEnable") as? Bool
        if contactEnable == true {
            self.btnContactList.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
            self.btnContactList.isSelected = true
        } else {
            self.btnLocation.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
            self.btnContactList.isSelected = false
        }
    
        if self.isSocialMedia {
            self.txtPassword.isHidden = true
            self.txtConfirmPassword.isHidden = true
            self.btnPasswordShowHidse.isHidden = true
            
            self.txtFirstname.text = User.shared.firstName
            self.txtLastName.text = User.shared.lastName
            
            self.txtDob.selectedItem = "\(String().ConvertToDate1(stringDate: User.shared.dateOfBirth ?? "") ?? "")"
            self.txtEmail.text = User.shared.email
            do {
                let user:AppleUser = try JSONDecoder.init().decode(AppleUser.self, from: UserDefaults.standard.object(forKey: "AppleUser") as! Data)
                if(user.fullName != nil && user.email != nil && user.fullName != " "){
                    let names = user.fullName?.split(separator: " ")
                    self.txtFirstname.text =  String(names?[0] ?? "")
                    self.txtLastName.text = String(names?[1] ?? "")
                    self.txtEmail.text = user.email
                }
            } catch  {
                Print(object: error)
            }
        }
    }
    
    
    @IBAction func buttonActionOfNotification(sender: UIButton)
    {
        let notificationEnable = UserDefaults.standard.object(forKey: "notificationEnable") as? Bool ?? false
        /*if notificationEnable == true {
            self.btnNotification.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
        } else {
            self.btnNotification.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
        }*/
        if !notificationEnable {
            self.showAlert(msg: "Please enable notification permission from settings", okBtnTitle: "Settings", cancelBtnTitle: "Cancel", okBtnCompletion: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }) {
                
            }
        }else {
            self.btnNotification.isSelected = !self.btnNotification.isSelected
            
            if self.btnNotification.isSelected {
                self.btnNotification.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
                
                
                
            }else {
                let alert = UIAlertController.init(title: "Are you sure you want to disable notification services", message: nil, preferredStyle: .alert)
                let yesaction = UIAlertAction.init(title: "yes", style: .default) { (action) in
                    UIApplication.shared.unregisterForRemoteNotifications()
                    UserDefaults.standard.set(false, forKey: "notificationEnable")
                    self.btnNotification.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
                }
                
                let noAction = UIAlertAction.init(title: "No", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                    self.btnNotification.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
                }
                
                alert.addAction(yesaction)
                alert.addAction(noAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        print("Button Action From Storyboard")
    }
    @IBAction func buttonActionOfLocation(sender: UIButton)
    {
        let locationEnable = UserDefaults.standard.object(forKey: "locationEnable") as? Bool ?? false
        if !locationEnable  {
            self.showAlert(msg: "Please enable location permission from settings", okBtnTitle: "Settings", cancelBtnTitle: "Cancel", okBtnCompletion: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }) {
                
            }
        }else {
            
            self.btnLocation.isSelected = !self.btnLocation.isSelected
            
            if self.btnLocation.isSelected {
                self.btnLocation.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
            }else {
                self.btnLocation.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
                let alert = UIAlertController.init(title: "Are you sure you want to disable location services", message: nil, preferredStyle: .alert)
                let yesaction = UIAlertAction.init(title: "yes", style: .default) { (action) in
                    
                    UserDefaults.standard.set(false, forKey: "locationEnable")
                    self.btnLocation.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
                }
                
                let noAction = UIAlertAction.init(title: "No", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                    UserDefaults.standard.set(true, forKey: "locationEnable")
                    self.btnLocation.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
                }
                
                alert.addAction(yesaction)
                alert.addAction(noAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            //self.btnLocation.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
        }
        
    }
    //contactEnable
    //locationEnable
    
    @IBAction func buttonActionOfContact(sender: UIButton)
    {
        
        let contactEnable = UserDefaults.standard.object(forKey: "contactEnable") as? Bool
        if contactEnable == true {
            
            self.btnContactList.isSelected = !self.btnContactList.isSelected
            
            if self.btnContactList.isSelected {
                self.btnContactList.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
            }else {
                self.btnContactList.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
                let alert = UIAlertController.init(title: "Are you sure you want to disable contact services", message: nil, preferredStyle: .alert)
                let yesaction = UIAlertAction.init(title: "yes", style: .default) { (action) in
                    UIApplication.shared.unregisterForRemoteNotifications()
                    UserDefaults.standard.set(false, forKey: "contactEnable")
                    self.btnContactList.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
                }
                
                let noAction = UIAlertAction.init(title: "No", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                    UserDefaults.standard.set(true, forKey: "contactEnable")
                    self.btnContactList.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
                }
                
                alert.addAction(yesaction)
                alert.addAction(noAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            //self.btnContactList.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
        } else {
            
            self.showAlert(msg: "Please enable contact permission from settings", okBtnTitle: "Settings", cancelBtnTitle: "Cancel", okBtnCompletion: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }) {
                
            }
            
            /*CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
                if (granted){
                    //
                    self.btnContactList.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
                    print("granted  in contact")
                    UserDefaults.standard.set(true, forKey: "contactEnable")
                } else {
                    self.btnContactList.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
                    UserDefaults.standard.set(false, forKey: "contactEnable")
                    print("errorrrrrr in contact")
                }
            })*/
        }
        print("Button Action From Storyboard")
    }
//    func locationManagerPermission() {
//        let status = CLLocationManager.authorizationStatus()
//
//        switch status {
//        // 1
//        case .notDetermined:
//            locationMgr.requestWhenInUseAuthorization()
//            UserDefaults.standard.set(false, forKey: "locationEnable")
//            self.btnLocation.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
//            return
//
//        // 2
//        case .denied, .restricted:
//                        let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                        alert.addAction(okAction)
//
//            self.present(alert, animated: true, completion: nil)
//            UserDefaults.standard.set(false, forKey: "locationEnable")
//            self.btnLocation.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
//            return
//        case .authorizedAlways, .authorizedWhenInUse:
//            UserDefaults.standard.set(true, forKey: "locationEnable")
//            self.btnLocation.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
//            break
//
//        }
//        UserDefaults.standard.synchronize()
//        // 4
//        locationMgr.delegate = self
//        locationMgr.startUpdatingLocation()
//    }
        @objc func Notification(_ button:UIButton) {
            self.UseNotification = !self.UseNotification
            if UseNotification {
                self.btnNotification.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
            } else {
                self.btnNotification.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
            }
        }
        @objc func getLocation(_ button:UIButton) {
            self.UseLocation = !self.UseLocation
            if self.UseLocation {
                self.btnLocation.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
            } else {
                self.btnLocation.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
            }
        }
        @objc func getcontact(_ button:UIButton) {
            self.UseContacts = !self.UseContacts
            if self.UseContacts {
                self.btnContactList.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
            } else {
                self.btnContactList.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
            }
        }
    func getEnteredPin()-> String?
    {
        let digit1 = self.txtenterPin1.text ?? ""
        let digit2 = self.txtenterPin2.text ?? ""
        let digit3 = self.txtenterPin3.text ?? ""
        let digit4 = self.txtenterPin4.text ?? ""
        
        if !(digit1.isEmpty ?? false) && !(digit1.isEmpty ?? false) && !(digit1.isEmpty ?? false) && !(digit4.isEmpty ?? false)
        {
            return digit1 + digit2 + digit3 + digit4
        }
        return nil
    }
    
    func getReEnteredPin()-> String?
    {
        let digit1 = self.txtreEnterPin1.text ?? ""
        let digit2 = self.txtreEnterPin2.text ?? ""
        let digit3 = self.txtreEnterPin3.text ?? ""
        let digit4 = self.txtreEnterPin4.text ?? ""
        
        if !(digit1.isEmpty ?? false) && !(digit1.isEmpty ?? false) && !(digit1.isEmpty ?? false) && !(digit4.isEmpty ?? false)
        {
            return digit1 + digit2 + digit3 + digit4
        }
        return nil
    }
    
    
    @objc func passwordShowHide(_ button:UIButton)
    {
        self.txtPassword.isSecureTextEntry = !self.txtPassword.isSecureTextEntry
        self.txtConfirmPassword.isSecureTextEntry = !self.txtConfirmPassword.isSecureTextEntry
        if self.txtPassword.isSecureTextEntry {
            self.btnPasswordShowHidse.setBackgroundImage(UIImage.init(named: "passwordHide"), for: .normal)
        } else {
            self.btnPasswordShowHidse.setBackgroundImage(UIImage.init(named: "passwordShow"), for: .normal)
        }
    }
    
    @objc func GenderCancelPicker(_ button:UIButton)
    {
        self.view.endEditing(true)
    }
    
    @objc func Signin(_ button:UIButton)
    {
        
    }
    @objc func RelationCancelPicker(_ button:UIButton)
    {
        self.view.endEditing(true)
    }
    
    @objc func DOBCancelPicker(_ button:UIButton)
    {
        self.view.endEditing(true)
    }
    
    
    @objc func GraduationCancelPicker(_ button:UIButton)
    {
        self.view.endEditing(true)
    }
    
    @objc func PrivacyPolicy(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVc") as? PrivacyPolicyVc else {return}
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func TermsofUse(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsOfUseVC") as? TermsOfUseVC else {return}
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func SelectSddionalPhotos(_ button:UIButton)
    {
        let alert = UIAlertController.init(title: "Choose From", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let Camera = UIAlertAction.init(title: "Camera", style: .default) { (Action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
            {
                self.AddtoMorePhotos = true
                let picker = UIImagePickerController.init()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                picker.accessibilityHint = "AdditionalPhotos"
                picker.showsCameraControls = true
                self.present(picker, animated: true, completion: nil)
            }
            
        }
        
        let Gallery = UIAlertAction.init(title: "Gallery", style: .default) {[unowned self] (Action) in
            self.AddtoMorePhotos = false
            let picker = UIImagePickerController.init()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            picker.accessibilityHint = "AdditionalPhotos"
            self.present(picker, animated: true, completion: nil)
            
        }
        
        let Cancel = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(Camera)
        alert.addAction(Gallery)
        alert.addAction(Cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func ChoosePhotoForProfile(_ button:UIButton)
    {
        let alert = UIAlertController.init(title: "Choose From", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let Camera = UIAlertAction.init(title: "Camera", style: .default) { (Action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
            {
                self.AddtoMorePhotos = false
                let picker = UIImagePickerController.init()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                picker.accessibilityHint = "Profile"
                picker.showsCameraControls = true
                self.present(picker, animated: true, completion: nil)
            }
        }
        
        let Gallery = UIAlertAction.init(title: "Gallery", style: .default) {[unowned self] (Action) in
            
            let picker = UIImagePickerController.init()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            picker.accessibilityHint = "Profile"
            
            self.present(picker, animated: true, completion: nil)
        }
        
        let Cancel = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(Camera)
        alert.addAction(Gallery)
        alert.addAction(Cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    func validateData() -> Bool {
        if self.txtFirstname.text?.trim().count ?? 0 == 0 {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter first name",onVc:self)
            return false
        }
        if self.txtLastName.text?.trim().count ?? 0 == 0 {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter last name",onVc:self)
            return false
        }
//        guard let _ = self.txtDob.date else {
//            RDalertcontoller().presentAlertWithMessage(Message:"Please select date of birth",onVc:self)
//            return false
//        }
//        guard let _ = self.txtExpectedGraduationDate.date else {
//            RDalertcontoller().presentAlertWithMessage(Message:"Please select expected graduation date",onVc:self)
//            return false
//        }
//        if self.imgProfile.accessibilityHint == "PlaceHolder" {
//            RDalertcontoller().presentAlertWithMessage(Message:"Please select profile picture",onVc:self)
//            return false
//        }
        if self.txtEmail.text?.trim().count ?? 0 == 0 {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter email address",onVc:self)
            return false
        }
        guard self.txtEmail.text!.isValidEmail() else {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter valid email address",onVc:self)
            return false
        }
        /*if (self.txtEmail.text?.isValidEmail() ?? false) {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter valid email address",onVc:self)
            return false
        }*/
        
        if !self.isSocialMedia {
            if self.txtPassword.text?.trim().count ?? 0 == 0 {
                RDalertcontoller().presentAlertWithMessage(Message:"Please enter password",onVc:self)
                return false
            }
            if self.txtPassword.text?.trim().count ?? 0 < 8 {
                RDalertcontoller().presentAlertWithMessage(Message:"Password must be 8 characters long",onVc:self)
                return false
            }
            
            if self.txtPassword.text != self.txtConfirmPassword.text {
                RDalertcontoller().presentAlertWithMessage(Message:"Password and confirm password should be same",onVc:self)
                return false
            }
        }
        
        return true
    }
    
    @objc func finish(_ button:UIButton) {
        if self.validateData() {
            if self.isSocialMedia {
                self.updateProfile()
            }else{
                self.RegisterUser()
            }
            
        }
    }
    
    func updateProfile() {
        let serviceManager = ServiceManager<UpdateUserProfile>.init()
            serviceManager.ShowLoader = true
            serviceManager.ServiceName = "update-profile"
        
            if let image = self.imgProfile.image {
                serviceManager.Attachments = [image]
                serviceManager.AttachmentParameter = "profile_pic"
            }
            
        let dateComponent = DateComponentsFormatter.init()
        
            serviceManager.Parameters = [
                "date_of_birth":self.txtDob.date?.convertDate() ?? "",
                "relationship_status":self.relationShipStatus.selectedItem ?? "",
                "school_major":self.txtSchoolMajor.text ?? "",
                "school_minor":self.txtSchoolMinor.text ?? "",
                "expected_gradution_date":self.txtExpectedGraduationDate.date?.convertDate() ?? "",
                "school_university":User.shared.schoolUniversity ?? "",
                "school_classigication":self.txtSchoolClasification.selectedItem ?? "",
                "interest":self.txtInterests.text ?? "",
                "age":(dateComponent.difference(from: self.selectedDate, to: Date()) ?? "").components(separatedBy: " ").first ?? "",
                "gender": User.shared.gender ?? "",
                "first_name": self.txtFirstname.text ?? "",
                "last_name": self.txtLastName.text ?? "",
                "about_yourself": self.txtAboutMe.text ?? "",
                "device_token": UserDefaults.standard.object(forKey: "fcmToken") as? String ?? ""
            ]
                serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
                    
                    let userProfile = Response as? ResponseModel<UpdateUserProfile>
                    
                   if self.btnAdditionalPhotos.accessibilityHint == "Additional" {
                        self.UploadAdditionalPhotos()
                    }else {
                        //guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountVerificaitonvc") as? AccountVerificaitonvc else {return}
                        //self.navigationController?.setViewControllers([vc], animated: true)
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchoolSearchVC") as? SchoolSearchVC else {return}
                        self.navigationController?.setViewControllers([vc], animated: true)
                    }
            }
    }
    
    @objc func User4Pin(_ button:UIButton) {
        self.use4Pin = !use4Pin
        if use4Pin {
            self.PinViewHeight.constant = 179
            self.topView.constant = 34
            self.PinView.isHidden = false
            self.btn4Pin.setBackgroundImage(UIImage.init(named: "Uncheck"), for: .normal)
            //self.txtPin.clearPin()
            //self.txtre_enterPin.clearPin()
        } else {
            self.PinViewHeight.constant = 0
            self.topView.constant = 0
            self.PinView.isHidden = true
            self.btn4Pin.setBackgroundImage(UIImage.init(named: "Check"), for: .normal)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            print("location: \(currentLocation)")
        }
    }
    
    // 2
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @IBAction func actionCloseAditionalPhotos(_ sender: UIButton) {
        self.imgVwAdditional.image = UIImage(named: "Morephotos")
        self.btnClose.isHidden = true
        self.btnAdditionalPhotos.accessibilityHint = ""
    }
}
extension CreateProfileVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if picker.accessibilityHint ==  "AdditionalPhotos" {
            self.btnAdditionalPhotos.accessibilityHint = "Additional"
            self.imgVwAdditional.image = image
            self.btnClose.isHidden = false
        }else {
            //self.btnProfile.accessibilityHint = "ProfilePic"
            //self.btnProfile.setImage(image, for: .normal)
            self.imgProfile.image = image
            self.imgProfile.accessibilityHint = "ProfilePic"
        }
    }
    
    
}

/*extension CreateProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 return self.SelectedPhotos.count
 }
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdditionalPhoto", for: indexPath) as? AdditionalPhotos
 cell?.photo.image = self.SelectedPhotos[indexPath.item]
 cell?.photo.layer.cornerRadius = 5
 cell?.photo.layer.masksToBounds = true
 let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.SelectSddionalPhotos(_:)))
 cell?.photo.addGestureRecognizer(tap)
 cell?.photo.isUserInteractionEnabled = true
 return cell ?? UICollectionViewCell()
 }
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 return CGSize.init(width: 91, height: 60)
 }
 }*/
extension CreateProfileVC:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = ""
        if textField.text == "" {
            debugPrint("Backspace has been pressed")
        }
        if textField.text == " " && string.length() == 0 {
            debugPrint("Backspace has been pressed")
            switch textField {
            case txtenterPin2:
                txtenterPin1.isSecureTextEntry = false
                txtenterPin1.becomeFirstResponder()
            case txtenterPin3:
                txtenterPin2.isSecureTextEntry = false
                txtenterPin2.becomeFirstResponder()
            case txtenterPin4:
                txtenterPin3.isSecureTextEntry = false
                txtenterPin3.becomeFirstResponder()
            case txtreEnterPin2:
                txtreEnterPin1.isSecureTextEntry = false
                txtreEnterPin1.becomeFirstResponder()
            case txtreEnterPin3:
                txtreEnterPin2.isSecureTextEntry = false
                txtreEnterPin2.becomeFirstResponder()
            case txtenterPin4:
                txtreEnterPin3.isSecureTextEntry = false
                txtreEnterPin3.becomeFirstResponder()
                
            default:
                debugPrint("default")
            }
            textField.text = " "
            return false
        } else if string == "" {
            debugPrint("Backspace was pressed")
            switch textField {
            case txtenterPin2:
                txtenterPin1.isSecureTextEntry = false
                txtenterPin2.becomeFirstResponder()
            case txtenterPin3:
                txtenterPin2.isSecureTextEntry = false
                txtenterPin2.becomeFirstResponder()
            case txtenterPin4:
                txtenterPin3.isSecureTextEntry = false
                txtenterPin3.becomeFirstResponder()
            case txtreEnterPin2:
                txtreEnterPin1.isSecureTextEntry = false
                txtreEnterPin1.becomeFirstResponder()
            case txtreEnterPin3:
                txtreEnterPin2.isSecureTextEntry = false
                txtreEnterPin2.becomeFirstResponder()
            case txtreEnterPin4:
                txtreEnterPin3.isSecureTextEntry = false
                txtreEnterPin3.becomeFirstResponder()
            default:
                debugPrint("default")
            }
            textField.text = ""
            return false
        } else {
            textField.text = string
            switch textField {
            case txtenterPin1:
                txtenterPin1.isSecureTextEntry = true
                txtenterPin2.becomeFirstResponder()
            case txtenterPin2:
                txtenterPin2.isSecureTextEntry = true
                txtenterPin3.becomeFirstResponder()
            case txtenterPin3:
                txtenterPin3.isSecureTextEntry = true
                txtenterPin4.becomeFirstResponder()
            case txtenterPin4:
                txtenterPin3.isSecureTextEntry = true
                self.view.endEditing(true)
                break
                
            case txtreEnterPin1:
                txtreEnterPin1.isSecureTextEntry = true
                txtreEnterPin2.becomeFirstResponder()
            case txtreEnterPin2:
                txtreEnterPin2.isSecureTextEntry = true
                txtreEnterPin3.becomeFirstResponder()
            case txtreEnterPin3:
                txtreEnterPin3.isSecureTextEntry = true
                txtreEnterPin4.becomeFirstResponder()
            case txtreEnterPin4:
                txtreEnterPin3.isSecureTextEntry = true
                self.view.endEditing(true)
                break
            default:
                debugPrint("default")
            }
            return true
        }
    }
}
//MARK:- webservice
extension CreateProfileVC {
    func RegisterUser() {
        let serviceManager = ServiceManager<User>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "signup"
        serviceManager.HandleResponse = true
        if let image = self.imgProfile.image {
            serviceManager.Attachments = [image]
            serviceManager.AttachmentParameter = "profile_pic"
        }
        let dateComponent = DateComponentsFormatter.init()
        var params:[String:Any] = [
            "first_name":self.txtFirstname.text ?? "",
            "last_name":self.txtLastName.text ?? "",
            "email":self.txtEmail.text ?? "",
            "password":self.txtPassword.text ?? "",
            "date_of_birth":self.txtDob.date?.convertDate() ?? "1991-11-09",
            "gender":self.txtGender.selectedItem ?? "",
            "relationship_status":self.relationShipStatus.selectedItem ?? "",
            "school_major":self.txtSchoolMajor.text ?? "",
            "school_minor":self.txtSchoolMinor.text ?? "",
            "expected_gradution_date":self.txtExpectedGraduationDate.date?.convertDate() ?? "2026-12-10",
            "school_classigication":self.txtSchoolClasification.selectedItem ?? "",
            "interest":self.txtInterests.text ?? "",
            "about_yourself":self.txtAboutMe.text ?? "",
            "school_university":self.txtSchoolClasification.selectedItem ?? "",
            "age":(dateComponent.difference(from: self.selectedDate, to: Date()) ?? "").components(separatedBy: " ").first ?? ""
        ]
        if self.use4Pin {
            params["use_four_digit_pin"] = 1
            params["four_digit_pin"] = self.getEnteredPin() ?? ""
        }
        print(params)
        
        serviceManager.Parameters = params
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let user = Response as? ResponseModelDic<User>
            User.Token = user?.token ?? ""
            User.shared = user?.Data ?? User.shared
            
            do {
                
                let data = try JSONEncoder().encode(User.shared)
                UserDefaults.standard.set(data, forKey: "User")
                UserDefaults.standard.set(user?.token, forKey: "logintoken")
                
                if self.btnAdditionalPhotos.accessibilityHint == "Additional" {
                    self.UploadAdditionalPhotos()
                }else {
                    //guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountVerificaitonvc") as? AccountVerificaitonvc else {return}
                    //self.navigationController?.setViewControllers([vc], animated: true)
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchoolSearchVC") as? SchoolSearchVC else {return}
                    self.navigationController?.setViewControllers([vc], animated: true)
                }
                
            } catch {
                let error = error as? EncodingError
                print(error?.failureReason ?? "")
            }
            print(User.shared)
        }
    }
    func UploadAdditionalPhotos() {
        let serviceManager = ServiceManager<uploads>.init()
        serviceManager.ServiceName = "img-upload"
        serviceManager.HandleResponse = true
        if let image = self.imgVwAdditional.image {
            serviceManager.Attachments = [image]
            serviceManager.AttachmentParameter = "path"
        }
        self.Group.enter()
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let Uploads = Response as? ResponseModelDic<uploads>
            print(Uploads)
            self.Group.leave()
        }
        self.Group.notify(queue: DispatchQueue.main) {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchoolSearchVC") as? SchoolSearchVC else {return}
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
}

extension CreateProfileVC : IQDropDownTextFieldDelegate {
    
    
    func textField(_ textField: IQDropDownTextField, didSelect date: Date?) {
        let dateFormattter = DateFormatter()
        dateFormattter.dateFormat = "yyyy-mm-dd"
        if textField == self.txtDob {
            self.selectedDate = date ?? Date()
        }
    }
}
