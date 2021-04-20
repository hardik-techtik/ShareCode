//
//  MessagesVC.swift
//  MySchollKinect
//
//  Created by Admin on 01/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import GrowingTextView
import SocketIO
import SDWebImage
import Photos
import AVFoundation
import NVActivityIndicatorView

struct Messagedata : SocketData {
    let senderID:Int
    let RecieverID:Int
    let message:String
    
    func socketRepresentation() -> SocketData {
        return ["sender_id": senderID, "receiver_id": RecieverID,"message":message]
    }
}

struct DeleteMessagedata : SocketData {
    let senderID:Int
    let RecieverID:Int
    let MessageID:Int
    
    func socketRepresentation() -> SocketData {
        return ["sender_id": senderID, "receiver_id": RecieverID,"message_id":MessageID]
    }
}
struct DeleteUserConversationdata : SocketData {
    let deleted_by:Int
    let deleted_to:[Int]
    
    
    func socketRepresentation() -> SocketData {
        return ["deleted_by": deleted_by, "deleted_to": deleted_to]
    }
}
struct BlockUserData : SocketData {
    let from_user_id:Int
    let to_user_id:[Int]
    
    
    func socketRepresentation() -> SocketData {
        return ["from_user_id": from_user_id, "to_user_id": to_user_id]
    }
}
struct AllUnreadMessageData : SocketData {
    let sender_id:Int
    func socketRepresentation() -> SocketData {
        return ["receiver_id": sender_id]
    }
}
struct SendMediaWithSocketData : SocketData {
    let sender_id:Int
    let receiver_id:Int
    let mediaIsSelect: Bool
    let bufferData: Data
    func socketRepresentation() -> SocketData {
        return ["sender_id": sender_id, "receiver_id": receiver_id, "media": mediaIsSelect, "buffer": bufferData]
    }
}
struct UserTypingData : SocketData {
    let sender_id:Int
    let receiver_id:Int
    let typingStatus : Bool
    
    func socketRepresentation() -> SocketData {
        return ["sender_id": sender_id, "receiver_id": receiver_id, "typingStatus":typingStatus]
    }
}
class MessagesVC: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var tblView: reloadTable!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btncamera: UIButton!
    @IBOutlet weak var txtMessage: GrowingTextView!
    
    @IBOutlet weak var vwImgPreview: UIView!
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    
    
    
    @IBOutlet weak var bttnSend: UIButton!
    var RecieverID = 0
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var messageID = 0
    
    var last_date:String = ""
    
    var SelectedPhotos:[UIImage] = []
    var selectedVIdeos:[URL] = []
    weak var Delegate:PostDelegate?
    var selecteAssets:[UIImage] = []
    var arrAllMessage = [ChatMessage]()
    
    var strUserName = ""
    var strUserProfile = ""
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var objUserProfileImage: UIImageView!
    
    var vSpinner : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.RefresgDelegete = self
        
        self.imgPreview.accessibilityHint = ""
        
        /*let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.actionVwPreview(_:)))
        tapGesture.numberOfTouchesRequired = 1
        self.imgPreview.isUserInteractionEnabled = true
        self.imgPreview.addGestureRecognizer(tapGesture)*/
        
        lblUserName.text = strUserName
        objUserProfileImage.sd_setImage(with: URL.init(string: strUserProfile), placeholderImage: #imageLiteral(resourceName: "Morephotos"), options: SDWebImageOptions.continueInBackground)
        objUserProfileImage.layer.cornerRadius = objUserProfileImage.bounds.height / 2
        
        let rightMessageNib = UINib.init(nibName: "RightMessageCell", bundle: Bundle.main)
        tblView.register(rightMessageNib, forCellReuseIdentifier: "RightMessageCell")
        
        let rightImageNib = UINib.init(nibName: "RightImageCell", bundle: Bundle.main)
        tblView.register(rightImageNib, forCellReuseIdentifier: "RightImageCell")
        
        let leftMessageNib = UINib.init(nibName: "LeftMessageCell", bundle: Bundle.main)
        tblView.register(leftMessageNib, forCellReuseIdentifier: "LeftMessageCell")
        
        let leftImageNib = UINib.init(nibName: "LeftImageCell", bundle: Bundle.main)
        tblView.register(leftImageNib, forCellReuseIdentifier: "LeftImageCell")
        
        self.tblView.setEmptyMessage1111("No message found")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.arrAllMessage.removeAll()
            SocketHelper.shared.sendReadAll(sender_id: RecieverID, receiver_id:  User.shared.id ?? 0)
            getAllMessages()
            SocketHelper.shared.receiveTypingEvent { (dict) in
                print("user e typing karvanu start karyu message screen ma")
            }
            SocketHelper.shared.onMessage() { (dict) in
                print("dicttttttt - on message")
                self.getAllMessages()
            }
            
            if self.arrAllMessage.count == 0 {
                self.tblView.setEmptyMessage1111("No message found")
            } else {
                self.tblView.setEmptyMessage1111("")
            }
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        //spinnerView.backgroundColor = UIColor.red
        
        let activityIndicatorView = NVActivityIndicatorView(frame: spinnerView.frame, type: NVActivityIndicatorType.lineScale)
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType.ballScaleMultiple, fadeInAnimation: nil)
        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicatorView)
            onView.addSubview(spinnerView)
        }
        
        self.vSpinner = spinnerView
    }
    
    func removeSpinner() {
        //DispatchQueue.main.async {
            //            onView.removeFromSuperview()
            self.stopAnimating(nil)
            //            self.vSpinner?.superview!.removeFromSuperview()
            self.vSpinner?.removeFromSuperview()
            
            self.vSpinner = nil
        //}
    }
    
    @IBAction func actionOpenProfile(_ sender: UIButton) {
        print("--- Receiver id :- \(RecieverID)")
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else { return }
        vc.postID = self.RecieverID
        self.navigationController?.show(vc, sender: nil)
    }
    
    
    func getAllMessages()  {
        
        self.showSpinner(onView: self.view)
        self.arrAllMessage.removeAll()
        SocketHelper.shared.getAllMessages(sender_id: (User.shared.id ?? 0), receiver_id: (RecieverID)) { (dict) in
           self.removeSpinner()
            
            print("Count == \(dict.allKeys.count)")
            if dict.allKeys.count > 0 {
                print("Has values")
                
                if (dict.value(forKey: "id") as! Int  == -1){
                    print("NO MESSAGES")
                    return
                }
                
                let msg = ChatMessage(dict: dict)
                //            SocketHelper.shared.sendDelivery(sender_id: User.shared.id ?? 0, receiver_id: self.RecieverID, message_id: msg.id)
                //            SocketHelper.shared.sendReadAll(sender_id: self.user_id, receiver_id: LocalUD.getUserId())
                
                self.arrAllMessage.append(msg)
                //            self.arrAllMessage.reverse()
                if self.arrAllMessage.count == 0 {
                    self.tblView.setEmptyMessage1111("No message found")
                } else {
                    self.tblView.setEmptyMessage1111("")
                }
                
                self.tblView.refresh.endRefreshing()
                
                DispatchQueue.main.async {
                    
                    self.tblView.reloadData()
                    self.tblView.scrollToBottom()
                }
            } else {
                print("No values")
            }
        }
    }
    @IBAction func didTapOnAttachImage(_ sender: UIButton) {
//        let Picker = GMImagePickerController.init()
//        Picker.delegate = self
//        Picker.showCameraButton = true
//        self.present(Picker, animated: true, completion: nil)
        
//        let data1 = #imageLiteral(resourceName: "Avatar").jpegData(compressionQuality: 0.7)
//        SocketHelper.shared.SendMediaWithChat(sender_id: User.shared.id ?? 0, receiver_id: RecieverID, bufferData: data1!) { (dict) in
//            print("-----\(dict)")
//            print("-------")
//
//        }
        self.requestCameraInSixthView()
        if Utility.shared.isCameraAllowed {
            Utility.pickImageFromCameraAndGallery(VC: self, objViewController: self, editProfile: "AddImageVideo")
        }
        
    }
    
    @IBAction func actionClosePreview(_ sender: UIButton) {
        
        self.vwImgPreview.isHidden = true
        self.txtMessage.isHidden = false
        self.imgPreview.accessibilityHint = ""
        
    }
    
    @IBAction func actionVwPreview(_ sender: UIControl) {
        
        let browser = IDMPhotoBrowser.init(photos: [self.imgPreview?.image])!
        browser.displayArrowButton = true
        browser.displayCounterLabel = true
        browser.useWhiteBackgroundColor = false
        browser.forceHideStatusBar = true
        
        self.present(browser, animated: true) {
            
        }
    }
    
    @IBAction func didTapOnSendMessage(_ sender: UIButton) {
        print("----sender id ------\(User.shared.id ?? 0)")
        print("----receiver id ------\(RecieverID)")
        sender.isEnabled = false
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
            sender.isEnabled = true
        })
        
        self.txtMessage.resignFirstResponder()
        
        if self.imgPreview.accessibilityHint == "CustomImage" {
            let data1 = self.imgPreview.image?.jpegData(compressionQuality: 0.3)
            self.showSpinner(onView: self.view)
            self.view.isUserInteractionEnabled = false
            SocketHelper.shared.SendMediaWithChat(sender_id: User.shared.id ?? 0, receiver_id: RecieverID, bufferData: data1!) { (dict) in
                
                self.last_date = ""
                
                self.view.isUserInteractionEnabled = true
                
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    self.removeSpinner()
//                }
                
                if self.arrAllMessage.count > 0 {
                    self.arrAllMessage.removeAll()
                }
                
                self.vwImgPreview.isHidden = true
                self.txtMessage.isHidden = false
                
                self.imgPreview.accessibilityHint = ""
                
                //self.getAllMessages()
                self.viewWillAppear(true)
            }
        }else {
            if self.txtMessage.text.trim().count == 0 {
                RDalertcontoller().presentAlertWithMessage(Message:"Please enter message.",onVc:self)
            }else {
                
                SocketHelper.shared.sendMessage(sender_id: User.shared.id ?? 0, receiver_id: RecieverID, strMessage: self.txtMessage.text.trim().encodeUrl()) { (res) in
                    
                    self.last_date = ""
                    print(res)
                    self.txtMessage.text = ""
                    self.arrAllMessage.removeAll()
                    self.getAllMessages()
                }
            }
        }
        
        
    }
    // MARK:  Camera permission check 
        func requestCameraInSixthView() {
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                Utility.shared.isCameraAllowed = true
            } else {
                if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            Utility.shared.isCameraAllowed = true
    //                        DispatchQueue.main.async {
    //                            if Utility.shared.buttonClickClosureInGlobal != nil {
    //                                Utility.shared.buttonClickClosureInGlobal!("sixthGallery", 5)
    //                            }
    //                        }
                            Utility.shared.isCameraAllowed = false
                        }
                    }
                } else {
                    self.showAlert(msg: "School Kinect Would like to access your Camera", okBtnTitle: "Okay", cancelBtnTitle: "Cancel", okBtnCompletion: {
                        
                    }) {
                        //Do your stuff-
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            })
                        }
                    }
                }
            }
        }
    @IBAction func buttonClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension MessagesVC:refreshProtocol {

    func didRefresh(tableView: UITableView) {
        
        if self.arrAllMessage.count > 0 {
            self.arrAllMessage.removeAll()
        }
        
        self.tblView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           self.getAllMessages()
        }
    }
}


//MARK:-textViewDelegate
extension MessagesVC:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.arrAllMessage.count > 0 {
            self.tblView.scrollToBottom()
        }
        SocketHelper.shared.UserTyping(sender_id: User.shared.id ?? 0, receiver_id:  self.RecieverID, typingStatus: true) { (strStatus) in
            print("textViewDidBeginEditing....strStatus......\(strStatus)")
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        SocketHelper.shared.UserTyping(sender_id: User.shared.id ?? 0, receiver_id:  self.RecieverID, typingStatus: false) { (strStatus) in
            print("textViewDidEndEditing.....strStatus......\(strStatus)")
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let Text = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if Text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0 {
            self.bttnSend.isEnabled = true
        } else {
            self.bttnSend.isEnabled = false
        }
        return true
    }
}

extension MessagesVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAllMessage.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = self.arrAllMessage[indexPath.row]
        
        if User.shared.id == dict.sender_id {
            
            if dict.mediaPath == "" {
                let cellText = tableView.dequeueReusableCell(withIdentifier: "RightMessageCell") as! RightMessageCell
                cellText.selectionStyle = .none
                
                if indexPath.row > 0 {
                    cellText.setPrevMsg(dict: self.arrAllMessage[indexPath.row - 1])
                }else {
                    cellText.setPrevMsg(dict: nil)
                }
                cellText.mdlChatMsg = dict
                
                return cellText
            } else {
                let rightCell = tableView.dequeueReusableCell(withIdentifier: "RightImageCell") as! RightImageCell
                
                rightCell.layer.masksToBounds = true
                
                if indexPath.row > 0 {
                    rightCell.setPrevMsg(dict: self.arrAllMessage[indexPath.row - 1])
                }else {
                    rightCell.setPrevMsg(dict: nil)
                }
                rightCell.mdlChatMsg = dict
                
                rightCell.btnPhoto.tag = indexPath.row
                rightCell.btnPhoto.accessibilityIdentifier = dict.mediaPath
                rightCell.btnPhoto.addTarget(self, action: #selector(self.previewPhoto(btnPhoto:)), for: UIControl.Event.touchUpInside)
                
                return rightCell
            }
            
            
        }else {
            if dict.mediaPath == "" {
                           
                           let cellText = tableView.dequeueReusableCell(withIdentifier: "LeftMessageCell") as! LeftMessageCell
                           cellText.selectionStyle = .none
                
                           if indexPath.row > 0 {
                               cellText.setPrevMsg(dict: self.arrAllMessage[indexPath.row - 1])
                           }else {
                               cellText.setPrevMsg(dict: nil)
                           }
                           cellText.mdlChatMsg = dict
                           
                           cellText.layoutIfNeeded()
                           
                           return cellText
                           
                       } else {
                           
                           let leftCell = tableView.dequeueReusableCell(withIdentifier: "LeftImageCell") as! LeftImageCell
                
                            if indexPath.row > 0 {
                                leftCell.setPrevMsg(dict: self.arrAllMessage[indexPath.row - 1])
                            }else {
                                leftCell.setPrevMsg(dict: nil)
                            }
                            leftCell.mdlChatMsg = dict
                           
                           leftCell.btnImage.tag = indexPath.row
                           leftCell.btnImage.accessibilityIdentifier = dict.mediaPath
                           leftCell.btnImage.addTarget(self, action: #selector(self.previewPhoto(btnPhoto:)), for: UIControl.Event.touchUpInside)
                           
                           leftCell.layoutIfNeeded()
                           
                           return leftCell
                       }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.arrAllMessage[indexPath.row]
        if dict.mediaPath != "" {
            Utility.shared.presentSKPhotoBrowser(imgUrls: [dict.mediaPath], index: indexPath.row, viewCotroller: self)
        }
        /*if User.shared.id == dict.sender_id {
            let cell = tableView.cellForRow(at: indexPath) as! RightMessageCell
            let GestureRecogniser = UILongPressGestureRecognizer.init(target: self, action: #selector(didLongPress(_:)))
            GestureRecogniser.minimumPressDuration = 1
            cell.addGestureRecognizer(GestureRecogniser)
            messageID = dict.id
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! LeftMessageCell
            let GestureRecogniser = UILongPressGestureRecognizer.init(target: self, action: #selector(didLongPress(_:)))
            GestureRecogniser.minimumPressDuration = 1
            cell.addGestureRecognizer(GestureRecogniser)
            messageID = dict.id
        }*/
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    @objc func previewPhoto(btnPhoto:UIButton) {
        Utility.shared.presentSKPhotoBrowser(imgUrls: [btnPhoto.accessibilityIdentifier ?? ""], index: btnPhoto.tag, viewCotroller: self)
    }
    
    @objc func didLongPress(_ tap:UILongPressGestureRecognizer) {
        if tap.state == .recognized {
            let alert = UIAlertController(title: title, message: "Are you sure you want to delete this message?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                print("Okay")
                SocketHelper.shared.DeletePerticularMessage(sender_id: User.shared.id ?? 0, receiver_id: self.RecieverID, message_id: self.messageID) { (res) in
                    print("--------------------------\(res)")
                    self.arrAllMessage.removeAll()
                    SocketHelper.shared.getAllMessages(sender_id: (User.shared.id ?? 0), receiver_id: (self.RecieverID)) { (dict) in
                        let msg = ChatMessage(dict: dict)
                        self.arrAllMessage.append(msg)
                        self.tblView.reloadData()
                        self.tblView.scrollToBottom()
                        self.view.endEditing(true)
                    }
                }
            })
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
                print("cancel")
            })
            alert.addAction(ok)
            alert.addAction(cancel)
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
        }
    }
}
class ChatMessage : NSObject{
    var id:Int = 0
    var sender_id:Int = 0
    var contact_id:Int = 0
    var msgbody:String = "" //actual message body
    var unread_count:String = "" //number of unreads
    var sent_datetime:String = "" //time of sent
    var mediaPath: String = ""
    var isDeliverd:Bool = false
    var isReaded:Bool = false
    var dateCreated : Date = Date()

    
    var strCreatedDate : String = ""
    var strConvertedDate : String = ""
    
    init(dict:NSDictionary) {
        self.id = dict.value(forKey: "id") as! Int
        self.sender_id = dict.value(forKey: "user_id") as! Int
        self.contact_id = dict.value(forKey: "contact_id") as! Int
        self.msgbody = dict.value(forKey: "body") as! String
        self.msgbody = self.msgbody.decodeUrl()
        self.mediaPath = (dict.value(forKey: "media_path") as? String)!
        self.strCreatedDate = dict.value(forKey: "created_at") as? String ?? ""
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "en_US_POSIX")
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let createDate = dateformatter.date(from: dict.value(forKey: "created_at") as? String  ?? "")
        self.dateCreated = createDate ?? Date()
        
        self.strCreatedDate = createDate?.relativePast(isChat: true) as! String
        
        let readDate = dateformatter.date(from: dict.value(forKey: "read_at") as? String ?? "")
        dateformatter.dateFormat = "hh:mm a"
        self.sent_datetime = dateformatter.string(from: createDate!)
        
        dateformatter.dateFormat = "dd MMM YYYY"
        self.strConvertedDate = dateformatter.string(from: createDate!)
        
        if readDate != nil {
            self.isReaded = true
            self.isDeliverd = true
        }else {
            self.isReaded = false
            self.isDeliverd = false
        }
    }
}
// MARK:  ImagePicker Delegate 
extension MessagesVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func base64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    }
    func imageToBase64(_ image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("image: ", image)
//            tempImage = info[.editedImage] as! UIImage
            
            self.txtMessage.isHidden = true
            
            self.imgPreview.image = image
            self.imgPreview.accessibilityHint = "CustomImage"
            self.vwImgPreview.isHidden = false
            
            /*let data1 = image.jpegData(compressionQuality: 0.7)
            SocketHelper.shared.SendMediaWithChat(sender_id: User.shared.id ?? 0, receiver_id: RecieverID, bufferData: data1!) { (dict) in
                print("-----\(dict)")
                print("-------")
                if self.arrAllMessage.count > 0 {
                    self.arrAllMessage.removeAll()
                }
                self.getAllMessages()
            }*/
        }
//        print("Utility.shared.intImageCount in FifthVC vc----------------\(Utility.shared.intImageCount)")
        self.dismiss(animated: true, completion: nil)
    }
}
extension UIViewController {
    func showAlert(msg: String,okBtnTitle:String,cancelBtnTitle:String? = nil,okBtnCompletion: @escaping () -> Void, cancelbtnCompletion : @escaping () -> Void) {
        
        let alert = UIAlertController(title: "My School Kinect", message: msg, preferredStyle:.alert)
        
        alert.addAction(UIAlertAction(title: okBtnTitle, style: .default, handler: { _ in
            okBtnCompletion()
        }))
        
        if cancelBtnTitle != nil {
            alert.addAction(UIAlertAction(title: cancelBtnTitle, style: UIAlertAction.Style.default, handler: { (action) in
                cancelbtnCompletion()
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}
