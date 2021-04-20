//
//  PostReplyVC.swift
//  MySchollKinect
//
//  Created by Admin on 26/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SDWebImage
import GrowingTextView
import IQKeyboardManagerSwift
import AVFoundation
import AVKit
import ExpandableLabel

class PostReplyVC: BaseVC {

    @IBOutlet weak var tbView: reloadTable!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var txtMessage: RDTextView!
    @IBOutlet weak var sendbutton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    var postID = 0
    var editingID = 0
    var isediting = false
    
    var from = ""
    
    var comments:[PostCommnets] = []
    
    var mdlPost : Posts!
    //var mdlPost:Posts!
    
    //var postComments =
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tbView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        //self.tbView.register(PostCellWithoutImage.self,forCellReuseIdentifier: "PostCellWithoutImage")
        
        self.tbView.delegate = self
        self.tbView.dataSource = self
        self.tbView.RefresgDelegete = self
        
        txtMessage.backgroundColor = UIColor.white
        txtMessage.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        txtMessage.layer.cornerRadius = txtMessage.frame.height/2
        txtMessage.delegate = self
        
        self.sendbutton.addTarget(self, action: #selector(Send(_:)), for: .touchUpInside)
        self.sendbutton.isEnabled = false
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboarddidshow(_:)), name: UIApplication.keyboardDidShowNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboarddidHide(_:)), name: UIApplication.keyboardDidHideNotification, object: nil)
        
        if from != ""
        {
            //self.btnAddPost.isHidden = true
            //self.toppostView.isHidden = true
            self.lblTitle.text = "My Post"
            
        }
       
    }
    @objc func Send(_ button:UIButton) {
        if isediting {
            self.UpdatePostComments(ID: self.editingID)
        } else {
            self.AddPostComments()
        }
    }
    
    func PostLike(ID:Int,Like:Int) {
        let serviceManager = ServiceManager<PostLike>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "post-like"
        serviceManager.Parameters =  ["post_id":ID, "like":Like]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            
            self.txtMessage.text = nil
            
            if Like == 1 {
                self.mdlPost.UserLiked = true
                
            }else {
                self.mdlPost.UserLiked = false
                
            }
            
            self.getPostComments()
        }
    }
    
    @objc func keyboarddidshow(_ noti:Notification) {
        let rect = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        self.bottomConstraint.constant = rect?.height ?? 0
        self.view.layoutIfNeeded()
    }
        
    @objc func keyboarddidHide(_ noti:Notification) {
        self.bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getPostComments()
        
        //IQKeyboardManager.shared.enable = false
        //IQKeyboardManager.shared.enableAutoToolbar = false
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        //IQKeyboardManager.shared.enable = true
        //IQKeyboardManager.shared.enableAutoToolbar = true
    }
}

extension PostReplyVC:refreshProtocol {
    func didRefresh(tableView: UITableView) {
        self.getPostComments()
    }
}

//MARK:-
extension PostReplyVC:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let Text = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if Text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0 {
            self.sendbutton.isEnabled = true
        } else {
            self.sendbutton.isEnabled = false
        }
        return true
    }
    
    @objc func actionMessage(btnMsg : UIButton) {
        
        let user = self.comments[btnMsg.tag].fromuser?[0]
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MessagesVC") as? MessagesVC else { return }
        vc.RecieverID = user?.id ?? 0//self.Posts[button.tag].userID ?? 0
        vc.strUserName = (user?.firstName ?? "") + " " + (user?.lastName ?? "") //"\(self.Posts[button.tag].name ?? "")"
        
        vc.strUserProfile = user?.profilePic ?? ""
        self.navigationController?.pushViewController(vc, animated: true)//show(vc, sender: nil)
    }
    
    @objc func openChat1(_ button:UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MessagesVC") as? MessagesVC else { return }
        vc.RecieverID = self.mdlPost.userID ?? 0
        vc.strUserName = "\(self.mdlPost.user?.firstName ?? "") \(self.mdlPost.user?.lastName ?? "")"
        
        vc.strUserProfile = self.mdlPost.user?.profilePic ?? ""
        
        //        vc.strUserProfile = "\(self.Posts[button.tag].)"
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func OpenProfile1(_ tap:UILongPressGestureRecognizer) {
        if tap.state == .recognized {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else { return }
            let view = tap.view
            vc.postID = self.mdlPost.userID ?? 0
            self.navigationController?.show(vc, sender: nil)
        }
    }
    
    @objc func openProfile(_ sender:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else { return }
        vc.postID = self.comments[sender.tag].fromUserID ?? 0
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func Like1(_ button:UIButton) {
        let index = button.tag
        let Id = self.mdlPost.id ?? 0
        if self.mdlPost.UserLiked ?? false
        {
            self.PostLike(ID: Id, Like: 0)
        }
        else
        {
            self.PostLike(ID: Id, Like: 1)
        }
        
    }
    
    @objc func Reply1(_ button:UIButton) {
        //TODO: - dfsadfa
        /*guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostReplyVC") as? PostReplyVC else { return }
        vc.postID = self.Posts[button.tag].id ?? 0
        vc.mdlpost = self.Posts[button.tag]
        self.navigationController?.show(vc, sender: nil)*/
        
        self.txtMessage.becomeFirstResponder()
    }
    
}

extension PostReplyVC:ExpandableLabelDelegate
{
    func willExpandLabel(_ label: ExpandableLabel) {
        self.tbView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        self.tbView.endUpdates()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        
    }
}

// MARK:  PostCellDelegate  
extension PostReplyVC: PostCellDelegate {
    func displayVideoOption(urlOfVideo: URL) {
        let player = AVPlayer(url: urlOfVideo)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
}

extension PostReplyVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            if !(mdlPost.userPostPhotos?.isEmpty ?? false) || !(mdlPost.userPostVideos?.isEmpty ?? false) {
                        
                        //let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell
                        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell
                        
                        cell?.viewController = self
                        
                        if User.shared.id == mdlPost.userID {
                            cell?.btnMessage.isHidden = true
                            
                        } else {
                            cell?.btnMessage.isHidden = false
                        }
                        
                        cell?.btnMessage.tag = indexPath.row
                        cell?.btnMessage.addTarget(self, action: #selector(openChat1(_:)), for: .touchUpInside)
                        
                        /*if indexPath.row == 0 {
                            cell?.objView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                        } else if indexPath.row == (self.mdlPost.count - 1) {
                            cell?.objView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            //                cell?.objView.roundCorners([.bottomLeft, .bottomRight], radius: 10)
                        }*/
            //            var photoVideo:[LightboxImage] = []
                        var arrEventPhoto = [[String: Any]]()
                        for image in mdlPost.userPostPhotos ?? [] {
                            if let url =     URL.init(string: image.path ?? "") {
            //                    photoVi   deo.append(LightboxImage.init(imageURL: url))
                                var dict = [String: Any]()
                                dict["path"] = url
                                dict["type"] = "image"
                                arrEventPhoto.append(dict)
                            }
                        }
                        for video in mdlPost.userPostVideos ?? [] {
                            if let url = URL.init(string: video.path ?? "") {
            //                    photoVideo.append(LightboxImage.init(imageURL: url))
                                var dict = [String: Any]()
                                dict["path"] = url
                                dict["type"] = "video"
                                arrEventPhoto.append(dict)
                            }
                        }

                        cell?.updateArrayList(array: arrEventPhoto)
                        cell?.objPostCellDelegate = self
                        cell?.controller?.view.isHidden = true
                
                        let tapOnProfile1 = UITapGestureRecognizer.init(target: self, action: #selector(OpenProfile1(_:)))
                        let tapOnProfile = UITapGestureRecognizer.init(target: self, action: #selector(OpenProfile1(_:)))
                
                        cell?.lblTItle.text = mdlPost.title
                        
                        cell?.ProfileIMage.tag = indexPath.row
                        cell?.ProfileIMage.layer.cornerRadius = (cell?.ProfileIMage.frame.height ?? 0.0)/2
                        cell?.ProfileIMage.layer.masksToBounds = true
                        cell?.ProfileIMage.isUserInteractionEnabled = true
                        
                        cell?.lblUserName.tag = indexPath.row
                        cell?.ProfileIMage.tag = indexPath.row
                        cell?.lblUserName.isUserInteractionEnabled = true
                        cell?.ProfileIMage.addGestureRecognizer(tapOnProfile1)
                        
                        cell?.lblUserName.addGestureRecognizer(tapOnProfile)
                        cell?.lblDescription.shouldExpand = true
                        cell?.lblDescription.isUserInteractionEnabled = true
                        cell?.btnLika.addTarget(self, action: #selector(Like1(_:)), for: .touchUpInside)
                        cell?.btnLika.tag = indexPath.row
                        cell?.selectionStyle = .none
                        cell?.lblDescription.numberOfLines = 3
                        cell?.lblDescription.text = mdlPost.descriptionOfPost
                        
                        //cell?.lblDescription.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."//Post.descriptionOfPost
                        //cell?.lblDescription.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(OpenCloseLabel(_:))))
                        
                        //cell?.lblUserName.text = Post.name
                        cell?.lblUserName.text = (mdlPost.user?.firstName ?? "") + " " + (mdlPost.user?.lastName ?? "")
                        print("----------------------\(cell?.lblUserName.text ?? "test")-----cell?.lblDescription.text-----\(cell?.lblDescription.text ?? "test")")
                        cell?.lblDescription.delegate = self
                        cell?.lblDescription.collapsed = true
                        //cell?.btnMessage.addTarget(self, action: #selector(openChat(_:)), for: .touchUpInside)
                        cell?.lblDescription.collapsedAttributedLink = NSAttributedString.init(attributedString: NSAttributedString.init(string: "See More", attributes: [NSAttributedString.Key.foregroundColor : UIColor.readMore]))
                        
                        cell?.btnReply.tag = indexPath.row
                        cell?.btnReply.addTarget(self, action: #selector(Reply1(_:)), for: .touchUpInside)
                        
                        cell?.ProfileIMage.sd_setImage(with: URL.init(string:  mdlPost.user?.profilePic ?? ""), placeholderImage: #imageLiteral(resourceName: "Profile"), options: SDWebImageOptions.continueInBackground, completed: nil)
                        
                        cell?.btnMore.addTarget(self, action: #selector(self.options1(_:)), for: .touchUpInside)
                        //cell?.btnMessage.tag = indexPath.row
                        cell?.btnMore.tag = indexPath.row
                        
                        let like = mdlPost.likesCount ?? 0
                        
                        if like > 0
                        {
                            cell?.btnLika.setTitle(" \(formatNumber(mdlPost.likesCount ?? 0))", for: .normal)
                        }
                        else
                        {
                             cell?.btnLika.setTitle(" Like", for: .normal)
                        }
                        //let liked = Post.UserLiked ?? false
                        
                        if mdlPost.UserLiked ?? false
                        {
                            cell?.btnLika.setImage(UIImage.init(named: "like-sel"), for: .normal)
                        }
                        else
                        {
                            cell?.btnLika.setImage(UIImage.init(named: "like"), for: .normal)
                        }
                        let comment = self.comments.count
                        
                        if comment > 0
                        {
                            let str = comment == 1 ? "Reply" : "Replies"
                            
                            cell?.btnReply.setTitle(" \(formatNumber(self.comments.count)) \(str)", for: .normal)
                        }
                        else
                        {
                             cell?.btnReply.setTitle(" Reply", for: .normal)
                        }
                
                cell?.btnMore.isHidden = true
                
                cell?.btnReply.isHidden = true
                
                cell?.btnLika.isHidden = true
                
                cell?.btnMessage.isHidden = true
                        
                        return cell ?? UITableViewCell()
                        
                    } else {
                        
                        //let cell = tableView.dequeueReusableCell(withIdentifier: "PostCellWithoutImage") as? PostCellWithoutImage
                        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCellWithoutImage", for: indexPath) as? PostCellWithoutImage
                        cell?.btnMore.tag = indexPath.row
                        cell?.btnMore.addTarget(self, action: #selector(self.options1(_:)), for: .touchUpInside)
                        if User.shared.id == mdlPost.userID {
                            cell?.btnMessage.isHidden = true
                            
                        } else {
                            cell?.btnMessage.isHidden = false
                            
                        }
                        cell?.btnMessage.tag = indexPath.row
                
                        /*cell?.btnMessage.addTarget(self, action: #selector(openChat1(_:)), for: .touchUpInside)
                        if indexPath.row == 0 {
                            cell?.objView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                        } else if indexPath.row == (self.mdlPost.count - 1) {
                            cell?.objView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                        }*/
                        /*if (self.Posts[indexPath.row].userID ?? 0) == (User.shared.id ?? 0) {
                            cell?.btnMessage.isHidden = true
                        } else {
                            cell?.btnMessage.isHidden = false
                        }*/
                        cell?.lblDescription.delegate = self
                        cell?.lblDescription.text = self.mdlPost .descriptionOfPost
                        cell?.lblDescription.isUserInteractionEnabled = true
                        cell?.lblDescription.tag = indexPath.row
                        //cell?.lblDescription.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(OpenCloseLabel(_:))))
                        cell?.lblDescription.numberOfLines = 5
                        
                        cell?.lblUserName.text = (mdlPost.user?.firstName ?? "") + " " + (mdlPost.user?.lastName ?? "")// Post.user?.firstName ?? " " + (Post.user?.lastName ?? "")
                        
                        print("else----------------------\(cell?.lblUserName.text ?? "test")-----cell?.lblDescription.text-----\(cell?.lblDescription.text ?? "test")")
                        cell?.lblTitle.text = mdlPost.title
                        //cell?.btnMessage.addTarget(self, action: #selector((openChat(_:))), for: .touchUpInside)
                        
                        cell?.btnlike.tag = indexPath.row
                        
                        cell?.btnreply.tag = indexPath.row
                        cell?.btnreply.addTarget(self, action: #selector(Reply1(_:)), for: .touchUpInside)
                        
                       // cell?.btnlike.setTitle(" \(formatNumber(1000000000))", for: .normal)
                        //cell?.btnreply.setTitle(" \(formatNumber(Post.postcommentCount ?? 0)) Replies", for: .normal)
                        //cell?.btnReplies.setTitle(" \(formatNumber(Post.postcommentCount ?? 0)) Replies", for: .normal)
                        
                        //cell?.lblDescription.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                        
                        let like = mdlPost.likesCount ?? 0
                        if like > 0
                        {
                            cell?.btnlike.setTitle(" \(formatNumber(mdlPost.likesCount ?? 0))", for: .normal)
                        }
                        else
                        {
                             cell?.btnlike.setTitle(" Like", for: .normal)
                        }
                        
                        
                        
                        if mdlPost.UserLiked ?? false
                        {
                            cell?.btnlike.setImage(UIImage.init(named: "like-sel"), for: .normal)
                        }
                        else
                        {
                            cell?.btnlike.setImage(UIImage.init(named: "like"), for: .normal)
                        }
                        
                        let comment = self.comments.count
                        
                        if comment > 0
                        {
                            let str = comment == 1 ? "Reply" : "Replies"
                            
                            cell?.btnreply.setTitle(" \(formatNumber(self.comments.count )) \(str)", for: .normal)
                        }
                        else
                        {
                             cell?.btnreply.setTitle(" Reply", for: .normal)
                        }
                        
                        cell?.lblDescription.collapsed = true
                        cell?.lblDescription.shouldExpand = true
                        cell?.lblDescription.collapsedAttributedLink = NSAttributedString.init(attributedString: NSAttributedString.init(string: "See More", attributes: [NSAttributedString.Key.foregroundColor : UIColor.readMore]))
                        cell?.selectionStyle = .none
                        cell?.btnlike.addTarget(self, action: #selector(Like1(_ :)), for: .touchUpInside)
                
                        let tapOnProfile = UITapGestureRecognizer.init(target: self, action: #selector(OpenProfile1(_:)))
                        let tapOnProfile1 = UITapGestureRecognizer.init(target: self, action: #selector(OpenProfile1(_:)))
                
                        cell?.ProfileIMage.tag = indexPath.row
                        cell?.ProfileIMage.isUserInteractionEnabled = true
                        cell?.ProfileIMage.sd_setImage(with: URL.init(string:  mdlPost.user?.profilePic ?? ""), placeholderImage: #imageLiteral(resourceName: "Profile"), options: SDWebImageOptions.continueInBackground, completed: nil)
                
                        cell?.ProfileIMage.layer.cornerRadius = (cell?.ProfileIMage.frame.height ?? 0.0)/2
                        cell?.ProfileIMage.layer.masksToBounds = true
                        cell?.lblUserName.tag = indexPath.row
                        cell?.lblUserName.isUserInteractionEnabled = true
                        cell?.ProfileIMage.addGestureRecognizer(tapOnProfile)
                        cell?.lblUserName.addGestureRecognizer(tapOnProfile1)
                        cell?.btnMore.addTarget(self, action: #selector(self.options(_:)), for: .touchUpInside)
                        //cell?.btnMessage.tag = indexPath.row
                
                cell?.btnMore.isHidden = true
                cell?.btnlike.isHidden = true
                cell?.btnreply.isHidden = true
                cell?.btnMessage.isHidden = true
                
                        return cell ?? UITableViewCell()
                    }
            
        }else {
            
            let user = self.comments[indexPath.row - 1].fromuser?[0]
                       let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCells") as? ReplyCells
                       cell?.selectionStyle = .none
                       //cell?.lblDescription.collapsed = true
                       //cell?.lblDescription.numberOfLines = 3
                       //cell?.lblDescription.collapsedAttributedLink = NSAttributedString.init(string: "See More", attributes: [NSAttributedString.Key.foregroundColor : UIColor.forGroundColor])
            
                       cell?.lblDescription.text = self.comments[indexPath.row - 1].comment
                       cell?.lblName.text = (user?.firstName ?? "") + " " + (user?.lastName ?? "")
                       cell?.imgProfile.sd_setImage(with: URL.init(string: user?.profilePic ?? ""), placeholderImage: UIImage.placeholder, options: SDWebImageOptions.continueInBackground)
                       cell?.optionsButton.addTarget(self, action: #selector(self.options(_:)), for: .touchUpInside)
                       cell?.optionsButton.tag = indexPath.row - 1
                       cell?.imgProfile.layer.cornerRadius = (cell?.imgProfile.frame.height ?? 0.0)/2
                       let commentedDate = Date().ConvertToDateInnServerTime(date: self.comments[indexPath.row - 1].updatedAt ?? "")
                       
                       cell?.lblDayAgo.setTitle(commentedDate?.timeAgoSince(), for: .normal)
            
            if user?.id ?? 0 == User.shared.id {
                cell?.btnMessage.isHidden = true
            }else {
                cell?.btnMessage.isHidden = false
            }
            
            cell?.btnProfile.tag = indexPath.row - 1
            cell?.btnProfile.addTarget(self, action: #selector(self.openProfile(_:)), for: .touchUpInside)
                       
            cell?.btnMessage.tag = indexPath.row - 1
            cell?.btnMessage.addTarget(self, action: #selector(self.actionMessage(btnMsg:)), for: .touchUpInside)
                       
            return cell ?? UITableViewCell()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func deletePost(ID:Int) {
            let serviceManager = ServiceManager<Posts>.init()
            serviceManager.ShowLoader = true
            serviceManager.ServiceName = "post/\(ID)"
    //        serviceManager.Parameters = ["search":self.txtSearchPost.text ?? ""]
            serviceManager.MakeServiceCall(httpMethod: .delete) { (Response) in
                let _ = Response as? ResponseModel<Posts>
                self.navigationController?.popViewController(animated: true)
            }
        }
    
    @objc func options1(_ button:UIButton) {
        if (self.mdlPost.userID ?? 0) == (User.shared.id ?? 0) {
            let Alert = UIAlertController.init(title: "Please select action", message: nil, preferredStyle: .actionSheet)
            let DeleteAction = UIAlertAction.init(title: "Delete", style: .default) { (Action) in
                
                //alert code change by pritesh // 13 june
                self.showAlert(msg: "Are you sure you want to delete this post?", okBtnTitle: "Yes", cancelBtnTitle: "No", okBtnCompletion: {
                    let _ = button.tag
                    let id = self.mdlPost.id ?? 0
                    self.deletePost(ID: id)
                }) {
                    print("No")
                }
            }
            
            let UpdateAAction = UIAlertAction.init(title: "Edit", style: .default) { (Action) in
                _ = button.tag
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditPostsvc") as? EditPostsvc else { return }
                vc.postToEdit = self.mdlPost
                self.navigationController?.show(vc, sender: nil)
            }
            let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in
            }
            
            Alert.addAction(UpdateAAction)
            Alert.addAction(DeleteAction)
            Alert.addAction(CancelAction)
            self.present(Alert, animated: true, completion: nil)
        } else {
            let Alert = UIAlertController.init(title: "Please select action", message: nil, preferredStyle: .actionSheet)
            let DeleteAction = UIAlertAction.init(title: "Its inappropriate", style: .default) { (Action) in
            }
            let UpdateAAction = UIAlertAction.init(title: "Report", style: .default) { (Action) in
                let Tag = button.tag
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportVC") as? ReportVC else { return }
                vc.ReportID = self.mdlPost.id ?? 0
                vc.userId = self.mdlPost.userID ?? 0
                vc.For = "post"
                self.navigationController?.show(vc, sender: nil)
            }
            
            let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in
            }
            
            Alert.addAction(UpdateAAction)
            //Alert.addAction(DeleteAction)
            Alert.addAction(CancelAction)
            self.present(Alert, animated: true, completion: nil)
        }
    }
    
    @objc func options(_ button:UIButton) {
        if (self.comments[button.tag].fromUserID ?? 0) == User.shared.id {
            let Alert = UIAlertController.init(title: "Please select action", message: nil, preferredStyle: .actionSheet)
            let DeleteAction = UIAlertAction.init(title: "Delete", style: .default) { (Action) in
                let Tag = button.tag
                let id = self.comments[Tag].id ?? 0
                self.DeletePostComments(ID: id)
            }
            let UpdateAAction = UIAlertAction.init(title: "Edit", style: .default) { (Action) in
                let Tag = button.tag
                self.txtMessage.text = self.comments[Tag].comment
                self.isediting = true
                self.editingID = self.comments[Tag].id ?? 0
                for vc in self.children where vc is CreatePollsVc
                {
                    (vc as? CreatePollsVc)?.lblTIile.text = "Create a new poll"
                }
            }
            let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in
            }
            
            Alert.addAction(UpdateAAction)
            Alert.addAction(DeleteAction)
            Alert.addAction(CancelAction)
            self.present(Alert, animated: true, completion: nil)
        }else {
            let Alert = UIAlertController.init(title: "Please select action", message: nil, preferredStyle: .actionSheet)
            let DeleteAction = UIAlertAction.init(title: "Report", style: .default) { (Action) in
                let Tag = button.tag
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportVC") as? ReportVC else { return }
                vc.ReportID = self.comments[button.tag].postID ?? 0
                vc.userId = User.shared.id ?? 0
                vc.For = "post"
                self.navigationController?.show(vc, sender: nil)
            }
            let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in
            }
            Alert.addAction(DeleteAction)
            Alert.addAction(CancelAction)
            self.present(Alert, animated: true, completion: nil)
        }
    }
}
extension PostReplyVC:UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
extension PostReplyVC {
    @objc func getPostComments() {
        let serviceManager = ServiceManager<PostCommnets>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "postcomments/\(postID)"
        serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
            let PollsComment = Response as? ResponseModel<PostCommnets>
            self.comments = PollsComment?.Data ?? []
            //self.tbView.reloadData()
            self.tbView.refreshControl?.endRefreshing()
            if self.comments.count == 0 {
                
                self.tbView.setEmptyMessage1111("No comment found")
            } else {
                self.tbView.setEmptyMessage1111("")
            }
            self.tbView.reloadData()
        }
    }
    func AddPostComments() {
        let serviceManager = ServiceManager<PostCommnets>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "post-comments"
        serviceManager.Parameters = [
            "post_id": self.postID,
            "comment" : self.txtMessage.text ?? ""
        ]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let PollsComment = Response as? ResponseModel<PostCommnets>
            self.comments = PollsComment?.Data ?? []
            self.txtMessage.text = nil
            self.getPostComments()
        }
    }
    func UpdatePostComments(ID:Int) {
        let serviceManager = ServiceManager<PostCommnets>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "post-comments/\(ID)"
        serviceManager.Parameters = [
            "comment" : self.txtMessage.text ?? ""
        ]
        serviceManager.MakeServiceCall(httpMethod: .put) { (Response) in
            let PollsComment = Response as? ResponseModel<PostCommnets>
            self.comments = PollsComment?.Data ?? []
            self.isediting = false
            self.txtMessage.text = nil
            self.getPostComments()
        }
    }
    func DeletePostComments(ID:Int) {
        let serviceManager = ServiceManager<PostCommnets>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "post-comments/\(ID)"
        serviceManager.MakeServiceCall(httpMethod: .delete) { (Response) in
            let PollsComment = Response as? ResponseModel<PostCommnets>
            self.comments = PollsComment?.Data ?? []
            self.getPostComments()
        }
    }
}
