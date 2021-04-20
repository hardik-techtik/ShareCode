//
//  AddShareVideoVC.swift
//  MySchollKinect
//
//  Created by Shreyansh on 27/06/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import AVKit

class AddShareVideoVC: BaseVC {
    
    //MARK:- Variable and IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVideoThumbmail: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var tvDescription: RDTextView!
    @IBOutlet weak var lblCharacterCount: UILabel!
    @IBOutlet weak var conImgVideoHeight: NSLayoutConstraint!
    
    fileprivate var videoURL : URL?
    
    
    //MARK:- Overriden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.setupData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

//MARK:- Custom methods
extension AddShareVideoVC {
    
    func setUpUI() {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        
        var schoolName = ""
        if let strSchoolName : String = UserDefaults.standard.value(forKey: "SchoolName") as? String {
            schoolName = strSchoolName
        }else {
            schoolName = "\(User.shared.schoolusers?.last?.school?.theNameOfYourSchool ?? "")"
        }
        
        guard let strSchool = ("Posting to the \(schoolName) Share Videos." as NSString?)?.range(of:"\(User.shared.schoolusers?.last?.school?.theNameOfYourSchool ?? "")") else {return}
        
        let FullRange = ("Posting to the \(schoolName) Share Videos." as NSString).range(of: "Posting to the \(User.shared.schoolusers?.last?.school?.theNameOfYourSchool ?? "") Share Videos.")
        
        let AttriButtedString = NSMutableAttributedString.init(string: "Posting to the \(schoolName) Share Videos.")
        
        AttriButtedString.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: FullRange)
        AttriButtedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Medium", size: 16)!], range: strSchool)
        
        self.lblTitle.attributedText = AttriButtedString
        
        self.conImgVideoHeight.constant = 0
    }
    
    func setupData() {
        self.imgVideoThumbmail.accessibilityHint = "Placeholder"
    }
    
    func displayVideoOption(urlOfVideo: URL) {
        let player = AVPlayer(url: urlOfVideo)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    func callAPItoAddVideo() {
        //RDalertcontoller().presentAlertWithMessage(Message:"nice",onVc:self)
        
        let serviceManager = ServiceManager<ResponseModelSuccess>.init()
        serviceManager.ShowLoader = true
        serviceManager.Parameters = ["description":self.tvDescription.text ?? ""]
        serviceManager.ServiceName = "share-video"
        serviceManager.VideoAttachmentParameter = "video"
        serviceManager.VideoAttachments = [(videoURL!)]
        
        if let image = Utility.shared.createVideoThumbnail(url: videoURL!, imageView: self.imgVideoThumbmail) {
            serviceManager.VideoThumbnail = image
            serviceManager.VideoThumbnailParameter = "thumbnail_image"
            
            serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
                _ = Response as? ResponseModelDic<ResponseModelSuccess>
                //let response = Response as? ResponseModelSuccess
                serviceManager.VideoAttachments = nil
                serviceManager.VideoThumbnail = nil
                serviceManager.Attachments = nil
                serviceManager.Parameters = nil
                serviceManager.AttachmentParameter = nil
                self.navigationController?.popViewController(animated: true)
                RDalertcontoller().presentAlertWithMessage(Message:"Share Video has been added successfully.",onVc:self)
            }
        }
    }
}

//MARK:- UItextview deletegate
extension AddShareVideoVC : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        self.lblCharacterCount.text = "\(numberOfChars)/\(Utility.shared.characterLimit)"
        return numberOfChars < Utility.shared.characterLimit
    }
}

//MARK:- Button action
extension AddShareVideoVC {
    @IBAction func actionAddVideo(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let alert = UIAlertController.init(title: "Choose From", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let Camera = UIAlertAction.init(title: "Camera", style: .default) { (Action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                let picker = UIImagePickerController.init()
                picker.sourceType = .camera
                picker.mediaTypes = ["public.movie"]
                //picker.mediaTypes = ["public.image"]
                picker.allowsEditing = true
                picker.accessibilityHint = "AditionalPhoto"
                picker.delegate = self
                picker.showsCameraControls = true
                self.present(picker, animated: true, completion: nil)
            }
        }
        let Gallery = UIAlertAction.init(title: "Gallery", style: .default) {[unowned self] (Action) in
            
            let picker = UIImagePickerController.init()
            picker.sourceType = .photoLibrary
            picker.accessibilityHint = "AditionalPhoto"
            picker.mediaTypes = ["public.movie"]
            //picker.mediaTypes = ["public.image"]
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
        let Cancel = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(Camera)
        alert.addAction(Gallery)
        alert.addAction(Cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func actionPlay(_ sender: UIButton) {
        if let url = URL(string: self.imgVideoThumbmail.accessibilityHint ?? "") {
            self.displayVideoOption(urlOfVideo: url)
        }else {
            RDalertcontoller().presentAlertWithMessage(Message:"Something went wrong",onVc:self)
        }
         
    }
    
    @IBAction func actionPostVideo(_ sender: Any) {
        guard let _ = self.tvDescription.text else {
            RDalertcontoller().presentAlertWithMessage(Message:"Please add description",onVc:self)
            return
        }
        if self.imgVideoThumbmail.accessibilityHint == "Placeholder" {
            RDalertcontoller().presentAlertWithMessage(Message:"Plese add video",onVc:self)
        }else {
            self.callAPItoAddVideo()
        }
    }
}
//MARK:- Image picker delegate
extension AddShareVideoVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imgVideoThumbmail.accessibilityHint = "Placeholder"
        self.imgVideoThumbmail.image = nil
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let url = info[.mediaURL] as? URL {
            if getVideoTimeDuration(url: url) > 35 {
                RDalertcontoller().presentAlertWithMessage(Message:"Video should be less than or equal to 35 seconds.",onVc:self)
            }else {
                getThumbnailImageFromVideoUrl(url: url) { (Image) in
                    self.imgVideoThumbmail.image = Image
                    self.btnPlay.isHidden = false
                    self.imgVideoThumbmail.accessibilityHint = url.absoluteString
                    self.videoURL = url
                    self.conImgVideoHeight.constant = 150
                }
            }
        }
    }
}
