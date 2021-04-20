//
//  ProfileVC.swift
//  MySchollKinect
//
//  Created by Admin on 27/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SDWebImage
//import SKPhotoBrowser


class AdditionalPhotos:UICollectionViewCell
{
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class ProfileVC: BaseVC {

    @IBOutlet weak var btnAddContacts: CornerButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var BackView: UIView!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var btnSendPrivateMessage: CornerButton!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtRelationshipStatus: UITextField!
    @IBOutlet weak var txtSchoolMajor: UITextField!
    @IBOutlet weak var txtschoolminor: UITextField!
    @IBOutlet weak var txtSchooClassification: UITextField!
    @IBOutlet weak var txtInterest: UITextView!
    @IBOutlet weak var lblInterests: UILabel!
    @IBOutlet weak var lblGraduateDate: UITextField!
    @IBOutlet weak var lblAboutMe: UILabel!
    @IBOutlet weak var btnBlock: UIButton!
    
    var postID = 0
    var userProfile:UserProfile?
    @IBOutlet weak var conCollectionViewHeight: NSLayoutConstraint!
    let Picker = Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?.last as? CustomPicker
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        //btnSendPrivateMessage.addTarget(self, action: #selector(SendPrivateMessage(_:)), for: .touchUpInside)
        self.ProfileImage.layer.cornerRadius = self.ProfileImage.frame.height/2
        
        
        if postID == User.shared.id {
            self.btnBlock.isHidden = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetProfile()
//        self.BackView.AddDefaultShadow()
    }
    
    /*@objc func SendPrivateMessage(_ Button:UIButton) {
        /*guard let Vc = storyboard?.instantiateViewController(withIdentifier: "PrivateMessageVC") as? PrivateMessageVC else {return}
        vc.strUserProfile = self.Posts[Button.tag].user?.profilePic ?? ""
        self.navigationController?.show(Vc, sender:nil)*/
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: “MessagesVC”) as? MessagesVC else { return }
        vc.RecieverID = self.Posts[button.tag].userID ?? 0
        vc.strUserName = “\(self.Posts[button.tag].user?.firstName ?? “”) \(self.Posts[button.tag].user?.lastName ?? “”)”
        vc.strUserProfile = self.Posts[button.tag].user?.profilePic ?? “”
        //    vc.strUserProfile = “\(self.Posts[button.tag].)”
        self.navigationController?.show(vc, sender: nil)
    }*/
    
    @objc func showPhotoBrowser(btn:UIButton) {
        Utility.shared.presentSKPhotoBrowser(imgUrls: self.userProfile?.photos?.compactMap({$0.uploadImagePath ?? ""}) ?? [], index: btn.tag - 200, viewCotroller: self)
    }
    @IBAction func btnBlockUserClick(_ sender: Any) {
        self.blockUser()
    }
    
}

extension ProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userProfile?.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdditionalPhotos", for: indexPath) as? AdditionalPhotos
        cell?.photo.layer.cornerRadius = 8
        cell?.photo.layer.masksToBounds = true
        
        cell?.photo.sd_setImage(with: URL.init(string: self.userProfile?.photos?[indexPath.item].uploadImagePath ?? ""), placeholderImage: nil, options: SDWebImageOptions.continueInBackground)
        
        cell?.btnPhoto.tag = indexPath.row + 200
        cell?.btnPhoto.addTarget(self, action:#selector(self.showPhotoBrowser(btn:)), for: UIControl.Event.touchUpInside)
        
        return cell ?? UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Utility.shared.presentSKPhotoBrowser(imgUrls: self.userProfile?.photos?.compactMap({$0.uploadImagePath ?? ""}) ?? [], index: indexPath.row, viewCotroller: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (collectionView.bounds.width/3 - 10), height: (self.collectionView.bounds.height/2 - 10))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension ProfileVC {
    func GetProfile() {
           let serviceManager = ServiceManager<UserProfile>.init()
           serviceManager.ShowLoader = true
           serviceManager.ServiceName = "users-detail/\(postID)"
           
           serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
               let user = Response as? ResponseModelDic<UserProfile>
               self.userProfile = user?.Data
                //self.lblname.text = self.userProfile?.firstName ?? "" + " " + (self.userProfile?.lastName ?? "")
                self.lblname.text = self.userProfile?.name
                self.txtAge.text = "\(self.userProfile?.age ?? "")" + " Years"
                self.txtRelationshipStatus.text = self.userProfile?.relationshipStatus
                self.txtSchoolMajor.text = self.userProfile?.schoolMajor ?? "-"
                self.txtschoolminor.text = self.userProfile?.schoolMinor ?? "-"
                self.txtSchooClassification.text = self.userProfile?.schoolClassigication
                //self.txtInterest.text = self.userProfile?.interest ?? "-"
                self.lblInterests.text = self.userProfile?.interest ?? "-"
                self.ProfileImage.sd_setImage(with: URL.init(string: self.userProfile?.profilePic ?? ""), placeholderImage: UIImage.placeholder, options: .continueInBackground)
               
               if self.userProfile?.photos?.count ?? 0 > 0 {
                   self.conCollectionViewHeight.constant = 140
               }else {
                   self.conCollectionViewHeight.constant = 0
               }
            
                if let aboutMe = self.userProfile?.aboutYourself {
                    self.lblAboutMe.text = aboutMe
                }else {
                    self.lblAboutMe.text = "-"
                }
            
                self.lblGraduateDate.text = "\(String().ConvertToDate(stringDate: self.userProfile?.expectedGradutionDate ?? "") ?? "")"
               
               DispatchQueue.main.async {
                   self.collectionView.reloadData()
               }
            
                if User.shared.id ?? 0 == self.postID {
                    self.btnSendPrivateMessage.isHidden = true
                }else {
                    self.btnSendPrivateMessage.isHidden = false
                }
                //
               
               self.getLoggedInUserProfile()
           }
       }
       
    func getLoggedInUserProfile() {
        let serviceManager = ServiceManager<UserProfile>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "users-detail/\(User.shared.id ?? 0)"
        
        serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
            let user = Response as? ResponseModelDic<UserProfile>
            
            let loggedInUserProfile = user?.Data
            
            if loggedInUserProfile?.is_active == 1 {
                self.btnBlock.setTitle("Blocked", for: UIControl.State.normal)
                self.btnBlock.isUserInteractionEnabled = false
                self.btnBlock.alpha = 1.0
            }else{
                self.btnBlock.isUserInteractionEnabled = true
                self.btnBlock.setTitle("Block", for: UIControl.State.normal)
                self.btnBlock.alpha = 0.5
            }
            print(loggedInUserProfile?.firstName ?? "")
            print(loggedInUserProfile?.user_contact?.count ?? 0)
            
            let contactUserIds = loggedInUserProfile?.user_contact?.map({$0.to_user_id})
            
            if contactUserIds?.contains(self.postID) ?? false || User.shared.id == self.postID {
                self.btnAddContacts.isHidden = true
            }else {
                self.btnAddContacts.isHidden = false
            }
        }
    }
    
    @IBAction func tapOnPrivateMessageButtonClick(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MessagesVC") as? MessagesVC else { return }
        vc.RecieverID = postID//self.Posts[button.tag].userID ?? 0
        vc.strUserName = self.lblname.text ?? "" //"\(self.Posts[button.tag].name ?? "")"
        
        vc.strUserProfile = self.userProfile?.profilePic ?? ""
        self.navigationController?.pushViewController(vc, animated: true)//show(vc, sender: nil)
    }
    
    @IBAction func tapOnAddToContactButtonClick(_ sender: UIButton) {
    
        let serviceManager = ServiceManager<UserProfile>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "contact-member"
        serviceManager.Parameters = [
            "name":self.lblname.text ?? "",//"\(self.userProfile?.firstName ?? "") \(self.userProfile?.lastName ?? "")",
            "to_user_id":postID,
            "user_id":"\(User.shared.id ?? 0)",
            "number":""
        ]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            //let user = Response as? ResponseModelDic<UserProfile>
            RDalertcontoller().presentAlertWithMessage(Message:"Contact added successfully.",onVc:self)
            self.btnAddContacts.isHidden = true
            
            /*self.userProfile = user?.Data
            self.lblname.text = self.userProfile?.name
            self.txtAge.text = "\(self.userProfile?.age ?? "")" + " Years"
            self.txtRelationshipStatus.text = self.userProfile?.relationshipStatus
            self.txtSchoolMajor.text = self.userProfile?.schoolMajor
            self.txtschoolminor.text = self.userProfile?.schoolMinor
            self.txtSchooClassification.text = self.userProfile?.schoolClassigication
            self.txtInterest.text = self.userProfile?.interest
            self.ProfileImage.sd_setImage(with: URL.init(string: self.userProfile?.profilePic ?? ""), placeholderImage: UIImage.placeholder, options: .continueInBackground, context: nil)
            self.collectionView.reloadData()*/
            
        }
    }
}
extension ProfileVC {
    
    func blockUser(){
        let serviceManager = ServiceManager<ResponseModelSuccess>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "user-block"
        serviceManager.Parameters = [
            "is_active": 0, // 1:-unblock, 0:- block
            "to_user_id":postID
        ]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let user = Response as? ResponseModelDic<ResponseModelSuccessStatus>
            self.navigationController?.popViewController(animated: true)
            RDalertcontoller().presentAlertWithMessage(Message:"User block successfully.",onVc:self)
        }
    }
}
