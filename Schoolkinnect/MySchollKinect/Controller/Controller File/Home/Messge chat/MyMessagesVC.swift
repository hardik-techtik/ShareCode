//
//  MyMessagesVC.swift
//  MySchollKinect
//
//  Created by Admin on 31/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SDWebImage

class MyMessagesVC: BaseVC {
    
    @IBOutlet weak var tblView: reloadTable!
    @IBOutlet weak var BackView: UIView!
    @IBOutlet weak var btnPhonebook: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var OptionsHeight: NSLayoutConstraint!
    @IBOutlet weak var optionsView: UIView!
    var arrUserMessageList = [UserMessageList]()
    
    var arrSelectedRows:[Int] = []
    var selectionEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        BackView.AddDefaultShadow()
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.RefresgDelegete = self
        self.OptionsHeight.constant = 0
        self.btnCancel.addTarget(self, action: #selector(CloseOptions(_:)), for: .touchUpInside)
        self.btnPhonebook.accessibilityHint = "contacts - anticon"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.GetUserList()
        tblView.tableFooterView = UIView()
        //        BackView.AddDefaultShadow()
        //         optionsView.AddDefaultShadow()
        SocketHelper.shared.onMessage { (dict) in
            self.GetUserList()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    @IBAction func buttonClickBack(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
    }
    @IBAction func openMemberSearch(_ sender: Any) {
        
        if self.btnPhonebook.accessibilityHint == "contacts - anticon" {
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyContactsVC") as? MyContactsVC else {return}
            //        self.navigationController?.show(vc, sender: nil)
            self.navigationController?.show(vc, sender: nil)
            
        }else if self.btnPhonebook.accessibilityHint == "uncheck-circle" {
            
            self.selectionEnabled = true
            
            for i in 0..<arrUserMessageList.count {
                let dict = arrUserMessageList[i]
                self.arrSelectedRows.append(dict.id)
                self.tblView.reloadData()
            }
            
            self.btnPhonebook.accessibilityHint = "uncheck-circleAll"
            
        }else {
            if self.arrSelectedRows.count > 0 {
                self.arrSelectedRows.removeAll()
            }
            
            self.tblView.reloadData()
            
            self.btnPhonebook.setImage(UIImage.init(named: "contacts - anticon"), for: .normal)
            self.btnPhonebook.accessibilityHint = "contacts - anticon"
        }
        
        /*if self.btnPhonebook.currentImage == UIImage.init(named: "contacts - anticon") {
         guard let vc = storyboard?.instantiateViewController(withIdentifier: "MemberSearchVC") as? MemberSearchVC else {
         return
         }
         self.navigationController?.show(vc, sender: nil)
         //uncheck-circle
         }else if self.btnPhonebook.currentImage == UIImage.init(named: "uncheck-circle") {
         
         
         
         
         } else {
         
         }*/
    }
    
    func GetUserList() {
        arrUserMessageList.removeAll()
        SocketHelper.shared.receiveTypingEvent { (dict) in
            print("user e typing karvanu start karyu user list screen ma")
        }
        
        print("User.shared.id == \(User.shared.id)")
        
        SocketHelper.shared.getConversation(sender_id: User.shared.id ?? 0) { (dict) in
            print(dict)
            
            print("Count == \(dict?.allKeys.count)")
            if dict?.allKeys.count ?? 0 > 0 {
                let msg = UserMessageList(dict: dict ?? NSDictionary())
                self.arrUserMessageList.append(msg)
                print("ALL CHAT LIST")
                self.tblView.refreshControl?.endRefreshing()
                if self.arrUserMessageList.count == 0 {
                    self.tblView.setEmptyMessage1111("No messages found")
                } else {
                    self.tblView.setEmptyMessage1111("")
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.tblView.reloadData()
                })
            } else {
                self.tblView.setEmptyMessage1111("No messages found")
                self.tblView.refreshControl?.endRefreshing()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.tblView.reloadData()
                })
            }
            
            /*guard let msgDict = dict else {
                self.tblView.setEmptyMessage1111("No messages found")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.tblView.reloadData()
                })
                
                return
            }*/
        }
    }
    @objc func CloseOptions(_ button:UIButton) {
        
        self.OptionsHeight.constant = 0
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
        self.btnPhonebook.setImage(UIImage.init(named: "contacts - anticon"), for: .normal)
        self.btnPhonebook.accessibilityHint = "contacts - anticon"
        
        selectionEnabled = false
        arrSelectedRows.removeAll()
        self.tblView.reloadData()
    }
    
    @IBAction func tapOnMemberButtonClick(_ sender: UIButton) {
        if selectionEnabled == false {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyContactsVC") as? MyContactsVC else {return}
            //        self.navigationController?.show(vc, sender: nil)
            self.navigationController?.show(vc, sender: nil)
        } else {
            if arrUserMessageList.count == arrSelectedRows.count {
                arrSelectedRows.removeAll()
            } else {
                for each in arrUserMessageList {
                    if self.arrSelectedRows.contains(each.id) {
                        //                    self.arrSelectedRows.remove(at: self.arrSelectedRows.index(of: each.id)!)
                    }else{
                        self.arrSelectedRows.append(each.id)
                    }
                }
            }
            self.tblView.reloadData()
        }
    }
    
    @IBAction func tapOnUserChatClearButtonClick(_ sender: UIButton) {
        SocketHelper.shared.deleteConversationOrClearChat(deleted_by: User.shared.id ?? 0, deleted_to: arrSelectedRows) { (successMessage) in
            print("message deleted or clear chat done ----\(successMessage)")
            self.arrUserMessageList.removeAll()
            self.OptionsHeight.constant = 0
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            self.btnPhonebook.setImage(UIImage.init(named: "contacts - anticon"), for: .normal)
            self.btnPhonebook.accessibilityHint = "contacts - anticon"
            
            self.selectionEnabled = false
            self.arrSelectedRows.removeAll()
            
            SocketHelper.shared.getConversation(sender_id: User.shared.id ?? 0) { (dict) in
                print(dict)
                guard let msgDict = dict else {
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                    }
                    self.tblView.setEmptyMessage1111("No messages found")
                    return
                }
                let msg = UserMessageList(dict: msgDict)
                self.arrUserMessageList.append(msg)
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }
    
    @IBAction func tapOnUserBlockButtonClick(_ sender: UIButton) {
        SocketHelper.shared.BlockUserAndChat(from_user_id: User.shared.id ?? 0, to_user_id: arrSelectedRows) { (successMessage) in
            print("UserBlock successfully done done ----\(successMessage)")
            self.arrUserMessageList.removeAll()
            self.OptionsHeight.constant = 0
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            self.btnPhonebook.setImage(UIImage.init(named: "contacts - anticon"), for: .normal)
            self.btnPhonebook.accessibilityHint = "contacts - anticon"
            
            self.selectionEnabled = false
            self.arrSelectedRows.removeAll()
            
            SocketHelper.shared.getConversation(sender_id: User.shared.id ?? 0) { (dict) in
                print(dict)
                //                print("--------")
                
                guard let msgDict = dict else {
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                    }
                    return
                }
                
                let msg = UserMessageList(dict: msgDict)
                self.arrUserMessageList.append(msg)
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }
}

extension MyMessagesVC:refreshProtocol
{
    func didRefresh(tableView: UITableView) {
        self.GetUserList()
    }
}


extension MyMessagesVC:UITableViewDelegate,UITableViewDataSource {
    
    func dayDifference(from interval : TimeInterval) -> String
    {
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: interval)
        let startOfNow = calendar.startOfDay(for: Date())
        let startOfTimeStamp = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
        let day = components.day!
        if abs(day) < 2 {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            return formatter.string(from: date)
        } else if day > 1 {
            return "In \(day) days"
        } else {
            return "\(-day) days ago"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserMessageList.count == 0 ? 0 : arrUserMessageList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? MessageCell
        if(arrUserMessageList.count > 0)
        {
            
       
        let dict = arrUserMessageList[indexPath.row]
        
        print("data is ----- \(dict)")
        
        cell?.ProfileImg.layer.cornerRadius = (cell?.ProfileImg.frame.height ?? 0.0)/2
        cell?.ProfileImg.layer.masksToBounds = true
        cell?.lblCount.layer.cornerRadius = (cell?.lblCount.frame.height ?? 0.0)/2
        cell?.lblCount.layer.masksToBounds = true
        cell?.btnCheck.isHidden = true
        cell?.tag = indexPath.row
        cell?.lblUserName.text = "\(dict.first_name) \(dict.last_name)"
        
        if (dict.last_message.count != 0) {
            var lastMsg = "Image"
            if ((dict.last_message["body"] as? String == nil) || (dict.last_message["body"] as? String == "")) {
                lastMsg = "Image"
            }else {
                lastMsg = dict.last_message["body"] as? String ?? ""
                lastMsg = lastMsg.decodeUrl()
            }
            cell?.lblUserLastMessage.text = lastMsg
        } else {
            cell?.lblUserLastMessage.text = ""
        }
        
        cell?.lblCount.text = "\(dict.unread_count)"
        
        cell?.lblCount.isHidden = dict.unread_count == 0 ? true : false
        
        cell?.ProfileImg.sd_setImage(with: URL.init(string: "\(dict.profile_pic)"), placeholderImage: #imageLiteral(resourceName: "Profile"), options: SDWebImageOptions.continueInBackground)
        if arrSelectedRows.contains(dict.id){
            cell?.btnCheck.isHidden = false
            cell?.lblMsgDate.isHidden = true
            
        }else{
            cell?.btnCheck.isHidden = true
            cell?.lblMsgDate.isHidden = false
            
        }
        
        cell?.lblMsgDate.text = dict.createDate
        
        //print(dict.createDate)
        
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "YYYY-MM-ddTHH:mm:ssZZZZ"
        //let timeStamp = dateFormatter.date(from: )
        
        //self.dayDifference(from: dict.last_message["created_at"])
        
        let GestureRecogniser = UILongPressGestureRecognizer.init(target: self, action: #selector(didLongPress(_:)))
        GestureRecogniser.minimumPressDuration = 1
        cell?.addGestureRecognizer(GestureRecogniser)
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
        }else{
            return  UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectionEnabled == true {
            let dict = arrUserMessageList[indexPath.row]
            if self.arrSelectedRows.contains(dict.id) {
                self.arrSelectedRows.remove(at: self.arrSelectedRows.index(of: dict.id)!)
            }else{
                self.arrSelectedRows.append(dict.id)
            }
            if self.arrSelectedRows.count == 0 {
                self.btnPhonebook.setImage(UIImage.init(named: "contacts - anticon"), for: .normal)
                self.btnPhonebook.accessibilityHint = "contacts - anticon"
                selectionEnabled = false
                self.OptionsHeight.constant = 0
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
            self.tblView.reloadData()
        } else {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "MessagesVC") as? MessagesVC else { return }
            vc.RecieverID = arrUserMessageList[indexPath.row].id
            vc.strUserName = "\(arrUserMessageList[indexPath.row].first_name) \(arrUserMessageList[indexPath.row].last_name)"
            vc.strUserProfile = "\(arrUserMessageList[indexPath.row].profile_pic)"
            self.navigationController?.show(vc, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func didLongPress(_ tap:UILongPressGestureRecognizer) {
        if tap.state == .recognized {
            selectionEnabled = true
            let view = tap.view as? MessageCell
            let indexPath = view?.tag ?? 0
            print(indexPath)
            self.OptionsHeight.constant = 115
            let dict = arrUserMessageList[indexPath]
            if self.arrSelectedRows.contains(dict.id) {
                //self.arrSelectedRows.remove(at: self.arrSelectedRows.index(of: dict.id)!)
            }else{
                
                self.btnPhonebook.setImage(UIImage.init(named: "uncheck-circle"), for: .normal)
                self.btnPhonebook.accessibilityHint = "uncheck-circle"
                
                self.arrSelectedRows.append(dict.id)
            }
            self.tblView.reloadData()
        }
    }
}
class UserMessageList : NSObject{
    var id:Int = 0
    var age:Int = 0
    var email = ""
    var createDate:String = "" //time of sent
    var dateOfBirth: String = ""
    var gender: String = ""
    var first_name:String = "" //actual message body
    var last_name: String = ""
    var profile_pic: String = ""
    //number of unreads
    
    var school_classigication:String = "" //actual message body
    var school_major: String = ""
    var school_minor: String = ""
    var school_university:String = ""
    var unread_count:Int = 0
    var status = ""
    
    var isDeliverd:Bool = false
    var isReaded:Bool = false
    var last_message = [String: Any]()
    init(dict:NSDictionary) {
        self.id = dict.value(forKey: "id") as! Int
        self.age = dict.value(forKey: "age") as? Int ?? 0
        self.email = dict.value(forKey: "email") as? String  ?? ""
        self.first_name = dict.value(forKey: "first_name") as? String ?? ""
        self.last_name = dict.value(forKey: "last_name") as? String ?? ""
        self.profile_pic  = dict.value(forKey: "profile_pic") as? String ?? ""
        self.gender  = dict.value(forKey: "gender") as? String ?? ""
        
        self.school_classigication = dict.value(forKey: "school_classigication") as? String ?? ""
        self.school_major = dict.value(forKey: "school_major") as? String ?? ""
        self.school_minor  = dict.value(forKey: "school_minor") as? String ?? ""
        self.school_university  = dict.value(forKey: "school_university") as? String ?? ""
        self.unread_count = dict.value(forKey: "unread_count") as? Int ?? 0
        self.status = dict.value(forKey: "status") as? String  ?? ""
        self.last_message = (dict.value(forKey: "last_message") as? [String: Any])!
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "en_US_POSIX")
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let createDate = dateformatter.date(from: self.last_message["created_at"] as? String  ?? "")
        
        self.createDate = createDate!.relativePast()
        
        let readDate = dateformatter.date(from: dict.value(forKey: "read_at") as? String ?? "")
        dateformatter.dateFormat = "hh:mm a"
        //self.createDate = dateformatter.string(from: createDate!)
        
        let dateformatter1 = DateFormatter()
        dateformatter1.locale = Locale(identifier: "en_US_POSIX")
        dateformatter1.dateFormat = "yyyy-MM-dd'T'00:00:00.000Z"
        let dateOfBirth = dateformatter1.date(from: dict.value(forKey: "date_of_birth") as? String  ?? "")
        
        dateformatter1.dateFormat = "yyyy-MM-dd"
        self.dateOfBirth = dateformatter1.string(from: dateOfBirth ?? Date())
        if readDate != nil {
            self.isReaded = true
            self.isDeliverd = true
        } else {
            self.isReaded = false
            self.isDeliverd = false
        }
    }
    
    //    messageDictionary.setValue(aDictMessage.value(forKey:"age"), forKey:"age")
    //    messageDictionary.setValue(aDictMessage.value(forKey:"apple_id"), forKey:"apple_id")
    //    messageDictionary.setValue(aDictMessage.value(forKey:"latitude"), forKey:"latitude")
    //    messageDictionary.setValue(aDictMessage.value(forKey:"longitude"), forKey:"longitude")
    
}
extension Date {
    func relativePast(isChat:Bool = false) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        let units = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .weekOfYear])
        let components = Calendar.current.dateComponents(units, from: self, to: Date())
        
        if components.year! > 0 {
            //dateFormatter.dateFormat = "MM-dd-YYYY"
            dateFormatter.dateFormat = isChat ? "dd MMM yyyy" : "dd MMM yy"
            return dateFormatter.string(from: self)
            //return "\(components.year!) " + (components.year! > 1 ? "years ago" : "year ago")
            
        } else if components.month! > 0 {
            dateFormatter.dateFormat = isChat ? "dd MMM yyyy" : "dd MMM yy"
            return dateFormatter.string(from: self)
            //return "\(components.month!) " + (components.month! > 1 ? "months ago" : "month ago")
            
        } else if components.weekOfYear! > 0 {
            dateFormatter.dateFormat = isChat ? "dd MMM yyyy" : "dd MMM yy"
            return dateFormatter.string(from: self)
            //return "\(components.weekOfYear!) " + (components.weekOfYear! > 1 ? "weeks ago" : "week ago")
            
        } else if (components.day! > 0) {
            dateFormatter.dateFormat = isChat ? "dd MMM yyyy" : "dd MMM yy"
            return (components.day! > 1 ? "\(dateFormatter.string(from: self))" : "Yesterday")
            
        } else if components.hour! > 0 {
            //return "\(components.hour!) " + (components.hour! > 1 ? "hours ago" : "hour ago")
            return isChat ? "Today \(dateFormatter.string(from: self))" : dateFormatter.string(from: self)
            
        } else if components.minute! > 0 {
            return isChat ? "Today \(dateFormatter.string(from: self))" : dateFormatter.string(from: self)
            
        } else {
            return isChat ? "Today \(dateFormatter.string(from: self))" : dateFormatter.string(from: self)
        }
    }
    
    func timeAgoSince() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        let units = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .weekOfYear])
        let components = Calendar.current.dateComponents(units, from: self, to: Date())
        
        if components.year! > 0 {
            //dateFormatter.dateFormat = "MM-dd-YYYY"
            //dateFormatter.dateFormat =  "dd MMM yy"
            //return dateFormatter.string(from: self)
            return "\(components.year!) " + (components.year! > 1 ? "years ago" : "year ago")
            
        } else if components.month! > 0 {
            //dateFormatter.dateFormat = "dd MMM yy"
            //return dateFormatter.string(from: self)
            return "\(components.month!) " + (components.month! > 1 ? "months ago" : "month ago")
            
        } else if components.weekOfYear! > 0 {
            //dateFormatter.dateFormat = "dd MMM yy"
            //return dateFormatter.string(from: self)
            return "\(components.weekOfYear!) " + (components.weekOfYear! > 1 ? "weeks ago" : "week ago")
            
        } else if (components.day! > 0) {
            //dateFormatter.dateFormat = "dd MMM yy"
            return (components.day! > 1 ? "\(components.day!) days ago": "Yesterday")
            
        } else if components.hour! > 0 {
            return "\(components.hour!) " + (components.hour! > 1 ? "hours ago" : "hour ago")
            //return dateFormatter.string(from: self)
            
        } else if components.minute! > 0 {
            return (components.minute! > 1 ? "\(components.minute!) minutes ago" : "a minute ago")
            //return  dateFormatter.string(from: self)
            
        } else {
            return "Just now"
            //return dateFormatter.string(from: self)
        }
    }
    
}
