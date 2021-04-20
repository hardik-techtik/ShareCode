        //
    //  MyProfileVC.swift
    //  MySchollKinect
    //
    //  Created by Admin on 30/03/20.
    //  Copyright © 2020 Admin. All rights reserved.
    //

    import UIKit
    import SDWebImage
    import IQKeyboardManagerSwift
    import NetworkExtension
    
    
    

    class MyProfileVC: BaseVC {

        @IBOutlet weak var collectionView: UICollectionView!
       
        @IBOutlet weak var btnEdit: CornerButton!
       
        @IBOutlet weak var profileIMg: UIImageView!
        @IBOutlet weak var lblName: UILabel!
        @IBOutlet weak var txtAge: UITextField!
        @IBOutlet weak var txtRelationStatus: UITextField!
        @IBOutlet weak var expectedgraduationDate: UITextField!
        @IBOutlet weak var schoolMajor: UITextField!
        @IBOutlet weak var txtSchoolMinor: UITextField!
//        @IBOutlet weak var imgedit: UIImageView!
        @IBOutlet weak var txtSchoolClassification: UITextField!
        //@IBOutlet weak var txtIntertest: IQTextView!
        //@IBOutlet weak var txtAboutMe: IQTextView!
        @IBOutlet weak var lblUnreadCount: UILabel!
        @IBOutlet weak var blpostCount: UILabel!
        @IBOutlet weak var lvlMyeventsCunt: UILabel!
         //@IBOutlet weak var lblNOAdditionalDataFound: UILabel!
        @IBOutlet weak var lblInterest: UILabel!
        @IBOutlet weak var lblAboutME: UILabel!
        @IBOutlet weak var conCollectionViewHeight: NSLayoutConstraint!
        @IBOutlet weak var lblPollsCount: UILabel!
        
        
        var MyProfile:UserProfile?
        let ExpectedGraduationDate = Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?.last as? CustomPicker
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.btnEdit.addTarget(self, action: #selector(EditProfile(_:)), for: .touchUpInside)
            profileIMg.layer.cornerRadius = self.profileIMg.frame.height/2
            profileIMg.layer.masksToBounds = true
            profileIMg.clipsToBounds = true
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            //lblNOAdditionalDataFound.isHidden = false
            
            GetProfile()
//            self.BackView2.AddDefaultShadow()
//            self.backView.AddDefaultShadow()
//            self.profileIMg.addShadowToImage()
        }
        
        @objc func showPhotoBrowser(btn:UIButton) {
            Utility.shared.presentSKPhotoBrowser(imgUrls: self.MyProfile?.photos?.compactMap({$0.uploadImagePath ?? ""}) ?? [], index: btn.tag - 200, viewCotroller: self)
        }
        
        @IBAction func openMyPosts(_ sender: Any) {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchoolPostVC") as? SchoolPostVC  else {return}
            vc.from = "SchoolPostVC"
            self.navigationController?.show(vc, sender: nil)
        }
        
        @IBAction func MyEvents(_ sender: Any) {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsVC") as? EventsVC  else {return}
            vc.fromvc = true
            self.navigationController?.show(vc, sender: nil)
        }
        
        @objc func EditProfile(_ button:UIButton) {
            guard let Vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC else {return}
            Vc.user = self.MyProfile
            Vc.delegate = self
            self.navigationController?.show(Vc, sender:nil)
        }
        @IBAction func UnreadMessageCountClick(_ sender: Any) {
           guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyMessagesVC") as? MyMessagesVC else { return }
            self.navigationController?.show(vc, sender: nil)
        }
        @IBAction func SchoolPollsCountClick(_ sender: Any) {
           guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchoolPollsVC") as? SchoolPollsVC else { return }
            vc.FromVC = true
           self.navigationController?.show(vc, sender: nil)
        }
    }
    extension MyProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.MyProfile?.photos?.count ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdditionalPhotos", for: indexPath) as? AdditionalPhotos
            cell?.photo.layer.cornerRadius = 8
            cell?.photo.layer.masksToBounds = true
            
            cell?.photo.sd_setImage(with: URL.init(string: self.MyProfile?.photos?[indexPath.item].uploadImagePath ?? ""), placeholderImage: UIImage.placeholder2, options: SDWebImageOptions.continueInBackground)
            
            cell?.btnPhoto.tag = indexPath.row + 200
            cell?.btnPhoto.addTarget(self, action:#selector(self.showPhotoBrowser(btn:)), for: UIControl.Event.touchUpInside)
            
            return cell ?? UICollectionViewCell()
        }
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize.init(width: (collectionView.bounds.width/3 - 6), height: (self.collectionView.bounds.height/2 - 10))
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 6
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 6
        }
    }
    //MARK:- profiledeleget
    extension MyProfileVC:profieDelegate {
        func profileDidEdit() {
            GetProfile()
        }
    }
        
    //MARK:- webservices
        extension MyProfileVC {
            
            func getUnreadCount() {
                SocketHelper.shared.socket.emitWithAck("request_unread_count", AllUnreadMessageData.init(sender_id: User.shared.id ?? 0)).timingOut(after: 1) { data in
                    
                    let arr = data.first as? [[String: Any]]
                    let dict = arr?.first?["unread_count"] as? Int
                    
                    self.lblUnreadCount.text = "(\(dict ?? 0))"
                    
                }
                
                SocketHelper.shared.buttonClickClosureInGlobal = { (intIndex: Int) in
                    print("intIndex------\(intIndex)")
                    
                    self.lblUnreadCount.text = "(\(intIndex))"
                    
                }
            }
            
            
            func GetProfile() {
                SDWebImageDownloader.shared().downloadTimeout = 300                
                let serviceManager = ServiceManager<UserProfile>.init()
                serviceManager.ShowLoader = true
                serviceManager.ServiceName = "users"
                serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
                    let user = Response as? ResponseModelDic<UserProfile>
                    self.MyProfile = user?.Data
                    //Print(object: self.MyProfile)
                    
                    self.lblName.text = self.MyProfile?.name ?? "-"
                    self.txtAge.text = "\(self.MyProfile?.age ?? "")" + " Years"
                    self.txtRelationStatus.text = self.MyProfile?.relationshipStatus ?? "-"
                    self.schoolMajor.text = self.MyProfile?.schoolMajor ?? "-"
                    self.txtSchoolMinor.text = self.MyProfile?.schoolMinor ?? "-"
                    self.txtSchoolClassification.text = self.MyProfile?.schoolClassigication ?? "-"
                     
                    if let interest = self.MyProfile?.interest {
                        self.lblInterest.text = interest
                    }else {
                        self.lblInterest.text = "-"
                    }
                    
                    if let aboutMe = self.MyProfile?.aboutYourself {
                        self.lblAboutME.text = aboutMe
                    }else {
                        self.lblAboutME.text = "-"
                    }
                    
                    //self.lblInterest.text = self.MyProfile!.interest ?? "-"
                    //self.lblAboutME.text = self.MyProfile!.aboutYourself ?? "-"
                    
                    self.profileIMg.sd_setImage(with: URL.init(string: self.MyProfile?.profilePic ?? ""), placeholderImage: UIImage.placeholder, options: .continueInBackground)
                    
                    self.blpostCount.text = "(\(self.MyProfile?.schoolpostCount ?? 0))"
                    self.lblPollsCount.text = "(\(self.MyProfile?.school_poll_count ?? 0))"
                    
                    self.lvlMyeventsCunt.text = "(\(self.MyProfile?.schooleventCount ?? 0))"
                    self.expectedgraduationDate.text = "\(String().ConvertToDate(stringDate: self.MyProfile?.expectedGradutionDate ?? "") ?? "")"
                    if self.MyProfile?.photos?.count ?? 0 > 0 {
                        //self.lblNOAdditionalDataFound.isHidden = true
                        self.conCollectionViewHeight.constant = 140
                    } else {
                        self.conCollectionViewHeight.constant = 0   
                        
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.getUnreadCount()
                    }
                }
            }
        }
