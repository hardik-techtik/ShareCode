//
//  SchoolPollsReplyVC.swift
//  MySchollKinect
//
//  Created by Admin on 26/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import GrowingTextView
import IQKeyboardManagerSwift
import SDWebImage

class SchoolPollsReplyVC: BaseVC {
    
    @IBOutlet weak var tblView: UITableView!
    
    var Poll:Schoolpolls?
    
    var PollComments:[PollsComment] = []
    
    var FromVC = false
    
    @IBOutlet weak var txtMessage: GrowingTextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var vwAddComment: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    var isediting = false
    var editingID = 0
    let refesh = UIRefreshControl.init(frame: .init(x: 0, y: 0, width: 50, height: 50))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.tableFooterView = UIView()
        
        tblView.layoutSubviews()
        tblView.layer.cornerRadius = 15.0
        tblView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        
        self.vwAddComment.layer.cornerRadius = 15.0
        self.vwAddComment.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]//[.bottomLeft, .bottomRight]
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboarddidshow(_:)), name: UIApplication.keyboardDidShowNotification, object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboarddidHide(_:)), name: UIApplication.keyboardDidHideNotification, object: nil)
        
        self.btnSend.addTarget(self, action: #selector(Send(_:)), for: .touchUpInside)
        
        self.txtMessage.delegate = self
        
        txtMessage.placeholderColor = UIColor(white: 0.8, alpha: 1.0)
        txtMessage.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        txtMessage.layer.borderWidth = 1
        txtMessage.backgroundColor = UIColor.white
        txtMessage.layer.cornerRadius = txtMessage.frame.height/2
        
        txtMessage.delegate = self
        refesh.addTarget(self, action: #selector(self.getComments), for: .valueChanged)
        self.tblView.refreshControl = refesh
        
        if self.FromVC
        {
            self.lblTitle.text = "My Poll"
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tblView.setEmptyMessage1111("No comment found")
        
        self.getComments()
        
        //IQKeyboardManager.shared.enable = false
        //IQKeyboardManager.shared.enableAutoToolbar = false
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    @objc func Send(_ button:UIButton) {
        if self.isediting {
            self.UpdatePollsComments(ID: self.editingID)
        } else {
            self.AddPollsComments()
        }
    }
    @objc func keyboarddidshow(_ noti:Notification) {
        let rect = noti.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect
        self.bottomConstraint.constant = rect?.height ?? 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboarddidHide(_ noti:Notification) {
        self.bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func openProfile(_ sender:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else { return }
        vc.postID = self.PollComments[sender.tag].fromUserID ?? 0
        self.navigationController?.show(vc, sender: nil)
    }
    
}
extension SchoolPollsReplyVC:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let Text = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if Text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0 {
            self.btnSend.isEnabled = true
        } else {
            self.btnSend.isEnabled = false
        }
        return true
    }
}
extension SchoolPollsReplyVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.PollComments.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let poll = self.Poll
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PollsCell") as? PollsCell
            
            cell?.btnLike.addTarget(self, action: #selector(Like(_:)), for: .touchUpInside)
            cell?.btnDislike.addTarget(self, action: #selector(disLike(_:)), for: .touchUpInside)
            
            //cell?.btnReply.tag = indexPath.row
            
            cell?.btnLike.tag = indexPath.row
            cell?.btnDislike.tag = indexPath.row
            
            cell?.lblPollDescription.text = poll?.datumDescription
            
            cell?.btnDislike.setTitle(" \(poll?.dislikesCount ?? 0)", for: .normal)
            cell?.btnLike.setTitle(" \(poll?.likesCount ?? 0)", for: .normal)
            
            let liked = self.Poll?.UserLike ?? false
            
            if liked
            {
                cell?.btnLike.setImage(UIImage.init(named: "like-sel"), for: .normal)
                cell?.btnLike.tintColor = nil
            }
            else
            {
                cell?.btnLike.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysTemplate), for: .normal)
                cell?.btnLike.tintColor = UIColor(hexFromString: "666666")
            }
            
            let Disliked = self.Poll?.UserDisLike ?? false
            
            if Disliked
            {
                cell?.btnDislike.setImage(UIImage.init(named: "dislike-sel"), for: .normal)
            }
            else
            {
                cell?.btnDislike.setImage(UIImage.init(named: "dislike"), for: .normal)
            }
            
            cell?.btnDislike.setTitle(" \(formatNumber(self.Poll?.dislikesCount ?? 0))", for: .normal)
            
            cell?.selectionStyle = .none
            
            cell?.btnOptions.addTarget(self, action: #selector(options(_:)), for: .touchUpInside)
            
            return cell ?? UITableViewCell()
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PollsReplyCells") as? ReplyCells
            cell?.imgProfile?.sd_setImage(with: URL.init(string: self.PollComments[indexPath.row - 1].fromuser?[0].profilePic ?? ""), placeholderImage: UIImage.placeholder2, options: SDWebImageOptions.continueInBackground)
            cell?.imgProfile.layer.cornerRadius = (cell?.imgProfile.frame.height ?? 0)/2
            cell?.imgProfile.layer.masksToBounds = true
            cell?.lblName.text = (self.PollComments[indexPath.row - 1].fromuser?[0].firstName ?? "") + " " + (self.PollComments[indexPath.row - 1].fromuser?[0].lastName ?? "")
            cell?.lblpollscommentdescriptio.text = self.PollComments[indexPath.row - 1].comment
            cell?.selectionStyle = .none
            cell?.optionsButton.tag = indexPath.row
            
            if (self.PollComments[indexPath.row - 1].fromuser?.first?.id ?? 0) == (User.shared.id ?? 0) {
                cell?.optionsButton.addTarget(self, action: #selector(self.options(_:)), for: .touchUpInside)
            } else {
                 cell?.optionsButton.addTarget(self, action: #selector(self.otheroptions(_:)), for: .touchUpInside)
            }
            
            cell?.btnProfile.tag = indexPath.row - 1
            cell?.btnProfile.addTarget(self, action: #selector(self.openProfile(_:)), for: .touchUpInside)
            
            //cell?.lblDayAgo.setTitle("", for: .normal)
            //let date = self.PollComments[indexPath.row - 1].createdAt ?? ""
            //let FormattedDate = Date().ConvertToDate(date: date) ?? Date()
            //cell?.lblDayAgo.setTitle(FormattedDate.timeAgoSinceDate() ?? "" , for: .normal)
            
            
            let commentedDate = Date().ConvertToDateInnServerTime(date: self.PollComments[indexPath.row - 1].createdAt ?? "")
            
            cell?.lblDayAgo.setTitle(commentedDate?.timeAgoSince(), for: .normal)
            
            //cell?.optionsButton.tag = indexPath.row - 1
            return cell ?? UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func Like(_ button:UIButton) {
    }
    
    @objc func disLike(_ button:UIButton) {
    }
    @objc func otheroptions(_ button:UIButton) {
        let Alert = UIAlertController.init(title: "Please select action", message: nil, preferredStyle: .actionSheet)
                   
                   let DeleteAction = UIAlertAction.init(title: "Its inappropriate", style: .default) { (Action) in
                   }
                   let UpdateAAction = UIAlertAction.init(title: "Report", style: .default) { (Action) in
                       let Tag = button.tag
                       guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportVC") as? ReportVC else { return }
                    vc.ReportID =  self.PollComments[Tag - 1].id!//self.events[Tag].id ?? 0
                       vc.For = "poll"
                       self.navigationController?.show(vc, sender: nil)
                   }
                   
                   let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in
                   }
                   //Alert.addAction(DeleteAction)
                   Alert.addAction(UpdateAAction)
                   Alert.addAction(CancelAction)
                   self.present(Alert, animated: true, completion: nil)
    }
    @objc func options(_ button:UIButton) {
        let Alert = UIAlertController.init(title: "Please select action", message: nil, preferredStyle: .actionSheet)
        let DeleteAction = UIAlertAction.init(title: "Delete", style: .default) { (Action) in
            
            let alert = UIAlertController.init(title: "My School Kinect", message: "Are you sure you want to delete?", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "Yes", style: .default) { (action) in
                let id = self.PollComments[button.tag - 1].id ?? 0
                self.DeletePollsComments(ID: id)
            }
            
            let no = UIAlertAction.init(title: "No", style: .default) { (action) in
                
            }
            
            alert.addAction(ok)
            alert.addAction(no)
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        let UpdateAAction = UIAlertAction.init(title: "Edit", style: .default) { (Action) in
            let id = self.PollComments[button.tag].id ?? 0
            self.txtMessage.text = self.PollComments[button.tag].comment
            self.editingID = id
            self.isediting = true
        }
        let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in
            
        }
        Alert.addAction(UpdateAAction)
        Alert.addAction(DeleteAction)
        Alert.addAction(CancelAction)
        self.present(Alert, animated: true, completion: nil)
    }
}
extension SchoolPollsReplyVC {
    @objc func getComments() {
        let serviceManager = ServiceManager<PollsComment>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "pollcomments/\(self.Poll?.id ?? 0)"
        serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
            let PollsComment = Response as? ResponseModel<PollsComment>
            self.PollComments = PollsComment?.Data ?? []
            self.tblView.reloadData()
            self.refesh.endRefreshing()
            if self.PollComments.count == 0 {
                self.tblView.setEmptyMessage1111("No comment found")
            } else {
                self.tblView.setEmptyMessage1111("")
            }
            self.tblView.reloadData()
        }
    }
    func AddPollsComments() {
        let serviceManager = ServiceManager<PollsComment>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "poll-comments"
        
        serviceManager.Parameters = [
            "poll_id": self.Poll?.id ?? 0,
            "comment" : self.txtMessage.text ?? ""
        ]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let _ = Response as? ResponseModel<PollsComment>
            self.txtMessage.text = nil
            RDalertcontoller().presentAlertWithMessage(Message:"Your reply has been added successfully.",onVc:self)
            
            self.getComments()  
        }
    }
    func UpdatePollsComments(ID:Int) {
        let serviceManager = ServiceManager<PollsComment>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "poll-comments/\(ID)"
        serviceManager.Parameters = ["comment":self.txtMessage.text ?? ""]
        serviceManager.MakeServiceCall(httpMethod: .put) { (Response) in
            let _ = Response as? ResponseModel<PollsComment>
            self.txtMessage.text = nil
            self.isediting = false
            RDalertcontoller().presentAlertWithMessage(Message:"Your reply has been updated successfully.",onVc:self)
            self.getComments()
        }
    }
    func DeletePollsComments(ID:Int) {
        let serviceManager = ServiceManager<PostCommnets>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "poll-comments/\(ID)"
        serviceManager.MakeServiceCall(httpMethod: .delete) { (Response) in
            let _ = Response as? ResponseModel<PostCommnets>
            RDalertcontoller().presentAlertWithMessage(Message:"Your reply has been deleted successfully.",onVc:self)
            self.getComments()
        }
    }
}
