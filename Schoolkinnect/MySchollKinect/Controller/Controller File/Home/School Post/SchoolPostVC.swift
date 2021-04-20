//
//  SchoolPostVC.swift
//  MySchollKinect
//
//  Created by Admin on 25/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import IQKeyboardManagerSwift
import AVKit
import ExpandableLabel


class SchoolPostVC: BaseVC,UIGestureRecognizerDelegate {

    @IBOutlet weak var PlusButton: UIButton!
    
//    @IBOutlet weak var postMediaVie: UIView!
    @IBOutlet weak var toppostView: UIView!
    @IBOutlet weak var txtSearchPost: RDSearchTextField!
    @IBOutlet weak var lblPost: UILabel!
    //    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var topPost: UIButton!
    @IBOutlet weak var btnAddPost: UIButton!
    @IBOutlet weak var tblView: reloadTable!
    @IBOutlet weak var lblTitle: UILabel!
    
    var Posts:[Posts] = []
    var PostsMain:[Posts] = []
    var from = ""
    var issearching = false
    let refesh = UIRefreshControl.init(frame: .init(x: 0, y: 0, width: 50, height: 50))
    @IBOutlet weak var searcgFiled: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showSpinner(onView: self.view)
        self.getPosts()
        
        if from != ""
        {
            self.btnAddPost.isHidden = true
            self.toppostView.isHidden = true
            self.lblTitle.text = "My Posts"
            
        }
    }
    
    @objc func navigatedFromFilter(notification: NSNotification) {
        print("=== Notification called ===")
        
        let dictFilter = notification.object as! [String: Any]
        
        let serviceManager = ServiceManager<TrendingPost>.init()
        serviceManager.ShowLoader = false
        serviceManager.ServiceName = "trending-post"

        serviceManager.Parameters = [
            "school_id": "\(dictFilter["school_id"] ?? "")",
            "post_id" : "\(dictFilter["post_id"] ?? "")"
        ]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let Posts = Response as? ResponseModel<TrendingPost>
            print(Posts as Any)
        }
    }
    
    func setUpUI() {
        
        PlusButton.imageView?.contentMode = .scaleAspectFit
        
//        backview.layer.cornerRadius = 15.0
//        backview.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        
//        self.tblView.delegate = self
//        self.tblView.dataSource = self
        self.tblView.separatorStyle = .none
        
        self.tblView.RefresgDelegete = self
        
        btnAddPost.addTarget(self, action: #selector(Addpost(_:)), for: .touchUpInside)
        
        self.txtSearchPost.Delegate = self
        
        self.tblView.setEmptyMessage1111("No post found")
        
//        self.backview.AddDefaultShadow()
        
    }
    @objc func Addpost(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddpostVC") as? AddpostVC else { return }
        vc.Delegate = self
        self.navigationController?.show(vc, sender: nil)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    @IBAction func BtntopPost(_ sender: UIButton) {
        
        let Alert = UIAlertController.init(title: "Please select action", message: nil,preferredStyle: .actionSheet)
        let DeleteAction = UIAlertAction.init(title: "Top Post", style: .default) { (Action) in
            self.topPost.setTitle("Top Post", for: UIControl.State.normal)
            self.GETTtopPost()
        }
        let UpdateAAction = UIAlertAction.init(title: "Most Recent", style: .default) { (Action) in
            self.topPost.setTitle("Most Recent", for: UIControl.State.normal)
            self.GETTMostRecent()
        }
        let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in
        }
        Alert.addAction(DeleteAction)
        Alert.addAction(UpdateAAction)
        Alert.addAction(CancelAction)
        self.present(Alert, animated: true, completion: nil)
        
    }
    
}

extension SchoolPostVC:refreshProtocol {
    func didRefresh(tableView: UITableView) {
        self.getPosts()
    }
}


extension SchoolPostVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var Post = self.Posts[indexPath.row]
        print("--------\(Post)")
        Post.intPostID = self.Posts[indexPath.row].schoolID
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Call API"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(navigatedFromFilter), name: NSNotification.Name(rawValue: "Call API"), object: nil)

        if !(Post.userPostPhotos?.isEmpty ?? false) || !(Post.userPostVideos?.isEmpty ?? false) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell
            
            cell?.viewController = self
            
            if User.shared.id == Post.userID {
                cell?.btnMessage.isHidden = true
                
            } else {
                cell?.btnMessage.isHidden = false
            }
            
            cell?.btnMessage.tag = indexPath.row
            cell?.btnMessage.addTarget(self, action: #selector(openChat(_:)), for: .touchUpInside)
            
            if indexPath.row == 0 {
                cell?.objView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            } else if indexPath.row == (self.Posts.count - 1) {
                cell?.objView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//                cell?.objView.roundCorners([.bottomLeft, .bottomRight], radius: 10)
            }
//            var photoVideo:[LightboxImage] = []
            var arrEventPhoto = [[String: Any]]()
            
         //   print(Post.userPostPhotos,Post.userPostVideos)
            if Post.userPostPhotos?.count != 0{
                for image in Post.userPostPhotos ?? [] {
                    print(image.thumbnail_image)
                    if let url =     URL.init(string: image.path ?? "") {
    //                    photoVi   deo.append(LightboxImage.init(imageURL: url))
                        var dict = [String: Any]()
                        dict["path"] = url
                        dict["type"] = "image"
                        dict["post_id"] = image.postID
                        dict["school_id"] = image.schoolID
                        arrEventPhoto.append(dict)
                    }
                }
            }
            
            if Post.userPostVideos?.count != 0{
                
                for video in Post.userPostVideos ?? [] {
                    print(video.thumbnail_image)

                    if let url = URL.init(string: video.path ?? "") {
    //                    photoVideo.append(LightboxImage.init(imageURL: url))
                        var dict = [String: Any]()
                        dict["path"] = url
                        dict["type"] = "video"
                        dict["post_id"] = video.postID
                        dict["school_id"] = video.schoolID
                        dict["thumbnail"] = video.thumbnail_image
                        arrEventPhoto.append(dict)
                    }
                }
            }
            cell?.objPostCellDelegate = self
            cell?.controller?.view.isHidden = true
            
            
            cell?.updateArrayList(array: arrEventPhoto)
           
            
            let tapOnProfile = UITapGestureRecognizer.init(target: self, action: #selector(OpenProfile(_:)))
            let tapOnProfile1 = UITapGestureRecognizer.init(target: self, action: #selector(OpenProfile(_:)))
            
            cell?.lblTItle.text = Post.title
            
            cell?.ProfileIMage.tag = indexPath.row
            cell?.ProfileIMage.layer.cornerRadius = (cell?.ProfileIMage.frame.height ?? 0.0)/2
            cell?.ProfileIMage.layer.masksToBounds = true
            cell?.ProfileIMage.isUserInteractionEnabled = true
            
            cell?.lblUserName.tag = indexPath.row
            cell?.ProfileIMage.tag = indexPath.row
            
            cell?.lblUserName.isUserInteractionEnabled = true
            cell?.ProfileIMage.isUserInteractionEnabled = true
            
            cell?.ProfileIMage.addGestureRecognizer(tapOnProfile1)
            
            cell?.lblUserName.addGestureRecognizer(tapOnProfile)
            cell?.lblDescription.shouldExpand = true
            cell?.lblDescription.isUserInteractionEnabled = true
            cell?.btnLika.addTarget(self, action: #selector(Like(_:)), for: .touchUpInside)
            cell?.btnLika.tag = indexPath.row
            cell?.selectionStyle = .none
            cell?.lblDescription.numberOfLines = 3
            cell?.lblDescription.text = Post.descriptionOfPost
            
            //cell?.lblDescription.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."//Post.descriptionOfPost
            //cell?.lblDescription.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(OpenCloseLabel(_:))))
            
            //cell?.lblUserName.text = Post.name
            cell?.lblUserName.text = (Post.user?.firstName ?? "") + " " + (Post.user?.lastName ?? "")
            print("----------------------\(cell?.lblUserName.text ?? "test")-----cell?.lblDescription.text-----\(cell?.lblDescription.text ?? "test")")
            cell?.lblDescription.delegate = self
            cell?.lblDescription.collapsed = true
            //cell?.btnMessage.addTarget(self, action: #selector(openChat(_:)), for: .touchUpInside)
            cell?.lblDescription.collapsedAttributedLink = NSAttributedString.init(attributedString: NSAttributedString.init(string: "See More", attributes: [NSAttributedString.Key.foregroundColor : UIColor.readMore]))
            
            cell?.btnReply.tag = indexPath.row
            cell?.btnReply.addTarget(self, action: #selector(Reply(_:)), for: .touchUpInside)
            
            cell?.ProfileIMage.sd_setImage(with: URL.init(string:  Post.user?.profilePic ?? ""), placeholderImage: #imageLiteral(resourceName: "Profile"), options: SDWebImageOptions.continueInBackground, completed: nil)
            
            cell?.btnMore.addTarget(self, action: #selector(self.options(_:)), for: .touchUpInside)
            //cell?.btnMessage.tag = indexPath.row
            cell?.btnMore.tag = indexPath.row
            
            let like = Post.likesCount ?? 0
            
            if like > 0
            {
                cell?.btnLika.setTitle(" \(formatNumber(Post.likesCount ?? 0))", for: .normal)
            }
            else
            {
                 cell?.btnLika.setTitle(" Like", for: .normal)
//                cell?.btnLika.isSelected = false
            }
            //let liked = Post.UserLiked ?? false
            
            if Post.UserLiked ?? false
            {
                cell?.btnLika.setImage(UIImage.init(named: "like-sel"), for: .normal)
//                cell?.btnLika.isSelected = true
            }
            else
            {
                cell?.btnLika.setImage(UIImage.init(named: "like"), for: .normal)
//                cell?.btnLika.isSelected = false
            }
            let comment = Post.postcommentCount ?? 0
            
            if comment > 0
            {
                let str = comment == 1 ? "Reply" : "Replies"
                
                cell?.btnReply.setTitle(" \(formatNumber(Post.postcommentCount ?? 0)) \(str)", for: .normal)
            }
            else
            {
                 cell?.btnReply.setTitle(" Reply", for: .normal)
            }
            
            return cell ?? UITableViewCell()
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCellWithoutImage") as? PostCellWithoutImage
            cell?.btnMore.tag = indexPath.row
            cell?.btnMore.addTarget(self, action: #selector(self.options(_:)), for: .touchUpInside)
            if User.shared.id == Post.userID {
                cell?.btnMessage.isHidden = true
                
            } else {
                cell?.btnMessage.isHidden = false
                
            }
            cell?.btnMessage.tag = indexPath.row
            cell?.btnMessage.addTarget(self, action: #selector(openChat(_:)), for: .touchUpInside)
            if indexPath.row == 0 {
                cell?.objView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            } else if indexPath.row == (self.Posts.count - 1) {
                cell?.objView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
            /*if (self.Posts[indexPath.row].userID ?? 0) == (User.shared.id ?? 0) {
                cell?.btnMessage.isHidden = true
            } else {
                cell?.btnMessage.isHidden = false
            }*/
            cell?.lblDescription.delegate = self
            cell?.lblDescription.text = Post.descriptionOfPost
            cell?.lblDescription.isUserInteractionEnabled = true
            cell?.lblDescription.tag = indexPath.row
            //cell?.lblDescription.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(OpenCloseLabel(_:))))
            cell?.lblDescription.numberOfLines = 5
            
            cell?.lblUserName.text = (Post.user?.firstName ?? "") + " " + (Post.user?.lastName ?? "")// Post.user?.firstName ?? " " + (Post.user?.lastName ?? "")
            
            print("else----------------------\(cell?.lblUserName.text ?? "test")-----cell?.lblDescription.text-----\(cell?.lblDescription.text ?? "test")")
            cell?.lblTitle.text = Post.title
            //cell?.btnMessage.addTarget(self, action: #selector((openChat(_:))), for: .touchUpInside)
            
            cell?.btnlike.tag = indexPath.row
            
            cell?.btnreply.tag = indexPath.row
            cell?.btnreply.addTarget(self, action: #selector(Reply(_:)), for: .touchUpInside)
            
           // cell?.btnlike.setTitle(" \(formatNumber(1000000000))", for: .normal)
            //cell?.btnreply.setTitle(" \(formatNumber(Post.postcommentCount ?? 0)) Replies", for: .normal)
            //cell?.btnReplies.setTitle(" \(formatNumber(Post.postcommentCount ?? 0)) Replies", for: .normal)
            
            //cell?.lblDescription.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            
            let like = Post.likesCount ?? 0
            if like > 0
            {
                cell?.btnlike.setTitle(" \(formatNumber(Post.likesCount ?? 0))", for: .normal)
            }
            else
            {
                 cell?.btnlike.setTitle(" Like", for: .normal)
            }
            
            
            
            if Post.UserLiked ?? false
            {
                cell?.btnlike.setImage(UIImage.init(named: "like-sel"), for: .normal)
            }
            else
            {
                cell?.btnlike.setImage(UIImage.init(named: "like"), for: .normal)
            }
            
            let comment = Post.postcommentCount ?? 0
            
            if comment > 0
            {
                let str = comment == 1 ? "Reply" : "Replies"
                
                cell?.btnreply.setTitle(" \(formatNumber(Post.postcommentCount ?? 0)) \(str)", for: .normal)
            }
            else
            {
                 cell?.btnreply.setTitle(" Reply", for: .normal)
            }
            
            cell?.lblDescription.collapsed = true
            cell?.lblDescription.shouldExpand = true
            cell?.lblDescription.collapsedAttributedLink = NSAttributedString.init(attributedString: NSAttributedString.init(string: "See More", attributes: [NSAttributedString.Key.foregroundColor : UIColor.readMore]))
            cell?.selectionStyle = .none
            cell?.btnlike.addTarget(self, action: #selector(Like(_ :)), for: .touchUpInside)
            
            let tapOnProfile = UITapGestureRecognizer.init(target: self, action: #selector(OpenProfile(_:)))
            let tapOnProfile1 = UITapGestureRecognizer.init(target: self, action: #selector(OpenProfile(_:)))
            cell?.ProfileIMage.tag = indexPath.row
            cell?.ProfileIMage.isUserInteractionEnabled = true
            cell?.ProfileIMage.sd_setImage(with: URL.init(string:  Post.user?.profilePic ?? ""), placeholderImage: #imageLiteral(resourceName: "Profile"), options: SDWebImageOptions.continueInBackground, completed: nil)
            cell?.ProfileIMage.layer.cornerRadius = (cell?.ProfileIMage.frame.height ?? 0.0)/2
            cell?.ProfileIMage.layer.masksToBounds = true
            cell?.lblUserName.tag = indexPath.row
            cell?.lblUserName.isUserInteractionEnabled = true
            
            cell?.ProfileIMage.addGestureRecognizer(tapOnProfile1)
            cell?.lblUserName.addGestureRecognizer(tapOnProfile)
            cell?.btnMore.addTarget(self, action: #selector(self.options(_:)), for: .touchUpInside)
            //cell?.btnMessage.tag = indexPath.row
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func openChat(_ button:UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MessagesVC") as? MessagesVC else { return }
        vc.RecieverID = self.Posts[button.tag].userID ?? 0
        vc.strUserName = "\(self.Posts[button.tag].user?.firstName ?? "") \(self.Posts[button.tag].user?.lastName ?? "")"
        
        vc.strUserProfile = self.Posts[button.tag].user?.profilePic ?? ""
        
        //        vc.strUserProfile = "\(self.Posts[button.tag].)"
        self.navigationController?.show(vc, sender: nil)
    }
    
    
    @objc func options(_ button:UIButton) {
        if (self.Posts[button.tag].userID ?? 0) == (User.shared.id ?? 0) {
            let Alert = UIAlertController.init(title: "Please select action", message: nil, preferredStyle: .actionSheet)
            let DeleteAction = UIAlertAction.init(title: "Delete", style: .default) { (Action) in
                
                //alert code change by pritesh // 13 june
                self.showAlert(msg: "Are you sure you want to delete this post?", okBtnTitle: "Yes", cancelBtnTitle: "No", okBtnCompletion: {
                    let Tag = button.tag
                    let id = self.Posts[Tag].id ?? 0
                    self.deletePost(ID: id)
                }) {
                    print("No")
                }
            }
            
            let UpdateAAction = UIAlertAction.init(title: "Edit", style: .default) { (Action) in
                _ = button.tag
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditPostsvc") as? EditPostsvc else { return }
                vc.postToEdit = self.Posts[button.tag]
                self.navigationController?.pushViewController(vc, animated: true)
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
                vc.ReportID = self.Posts[Tag].id ?? 0
                vc.userId = self.Posts[Tag].userID ?? 0
                vc.For = "post"
                self.navigationController?.show(vc, sender: nil)
            }
            let BlockUserAction = UIAlertAction.init(title: "Block User", style: .default) { (Action) in
                self.blockUser(TouserId: self.Posts[button.tag].userID ?? 0)
            }
            let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in
            }
            
            Alert.addAction(UpdateAAction)
            Alert.addAction(BlockUserAction)
            Alert.addAction(CancelAction)
            self.present(Alert, animated: true, completion: nil)
        }
    }
    func blockUser(TouserId : Int){
        let serviceManager = ServiceManager<ResponseModelSuccess>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "user-block"
        serviceManager.Parameters = [
            "is_active": 0, // 1:-unblock, 0:- block
            "to_user_id":TouserId
        ]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            self.viewWillAppear(true)
            RDalertcontoller().presentAlertWithMessage(Message:"User block successfully.",onVc:self)
        }
    }
    @objc func Reply(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostReplyVC") as? PostReplyVC else { return }
        vc.postID = self.Posts[button.tag].id ?? 0
        vc.mdlPost = self.Posts[button.tag]
        vc.from = self.from
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func OpenProfile(_ tap:UILongPressGestureRecognizer) {
        if tap.state == .recognized {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else { return }
            let view = tap.view
            vc.postID = self.Posts[view!.tag].userID ?? 0
            //self.navigationController?.show(vc, sender: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//    @objc func OpenCloseLabel(_ tap:UITapGestureRecognizer) {
//        let tag = tap.view?.tag ?? 0
//        let Post = self.Posts[tag]
//        if Post.postPicture != nil {
//            let cell = self.tblView.cellForRow(at: IndexPath.init(row: tag, section: 0)) as? PostCell
//            cell?.lblDescription.collapsed = !(cell?.lblDescription.collapsed ?? false)
//        } else {
//            let cell = self.tblView.cellForRow(at: IndexPath.init(row: tag, section: 0)) as? PostCellWithoutImage
//            cell?.lblDescription.collapsed = !(cell?.lblDescription.collapsed ?? false)
//        }
//        self.tblView.beginUpdates()
//        self.tblView.endUpdates()
//    }
    @objc func Like(_ button:UIButton) {
        
        let index = button.tag
        let Id = self.Posts[index].id ?? 0
        if Posts[button.tag].UserLiked ?? false
        {
            
            
            var like = Posts[button.tag].likesCount ?? 0
            like = like - 1
            if like > 0
            {
                button.setTitle(" \(formatNumber(like ))", for: .normal)
            }
            else
            {
                button.setTitle(" Like", for: .normal)
            }
            button.setImage(UIImage.init(named: "like"), for: .normal)

            self.PostLike(ID: Id, Like: 0)
            
        }
        else
        {
            var like = Posts[button.tag].likesCount ?? 0
            like = like + 1
            if like > 0
            {
                button.setTitle(" \(formatNumber(like ))", for: .normal)
            }
            else
            {
                button.setTitle(" Like", for: .normal)
            }
            button.setImage(UIImage.init(named: "like-sel"), for: .normal)
            self.PostLike(ID: Id, Like: 1)
        }
        
    }
}


extension SchoolPostVC:ExpandableLabelDelegate
{
    func willExpandLabel(_ label: ExpandableLabel) {
        self.tblView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        self.tblView.endUpdates()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        
    }
}

extension SchoolPostVC {
    @objc func getPosts() {
        let serviceManager = ServiceManager<Posts>.init()
        serviceManager.ShowLoader = false
        if from == ""
        {
            serviceManager.ServiceName = "post-list/\(String(describing: User.shared.schoolID ?? 0))"
            //serviceManager.Parameters =  ["search":self.txtSearchPost.text ?? ""]
        }
        else
        {
            serviceManager.ServiceName = "user-post"
        }
        //serviceManager.Parameters =  ["search":self.txtSearchPost.text ?? ""]
        //serviceManager.Parameters = ["search":self.txtSearchPost.text ?? ""]
        serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
            
            
            print(Response)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.removeSpinner()
            }
            let Posts = Response as? ResponseModel<Posts>
            self.tblView.refreshControl?.endRefreshing()
            
            if self.Posts.count > 0 {
                self.Posts.removeAll()
            }
            
            self.Posts = Posts?.Data ?? []
            
            if self.PostsMain.count > 0 {
                self.PostsMain.removeAll()
            }
            self.PostsMain = self.Posts
            
            if self.Posts.count == 0 {
                self.tblView.setEmptyMessage1111("No post found")
            } else {
                self.tblView.setEmptyMessage1111("")
            }
            
            self.tblView.delegate = self
            self.tblView.dataSource = self
            self.tblView.reloadData()

            DispatchQueue.main.async {
                self.tblView.reloadData()
                self.view.layoutIfNeeded()
                self.view.setNeedsDisplay()
                self.view.setNeedsLayout()
            }
            
            
        }
    }
    
    func PostLike(ID:Int,Like:Int) {
        //self.showSpinner(onView: self.view)
        let serviceManager = ServiceManager<PostLike>.init()
        serviceManager.ShowLoader = false
        serviceManager.ServiceName = "post-like"
        serviceManager.Parameters =  ["post_id":ID, "like":Like]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            self.getPosts()
        }
    }
    
    
    
    func GETTtopPost() {
        let serviceManager = ServiceManager<Posts>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "top-post/\(User.shared.schoolID ?? 0)"
        serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
            let Posts = Response as? ResponseModel<Posts>
            self.Posts = Posts?.Data ?? []
            self.PostsMain = self.Posts
            if self.Posts.count == 0 {
                self.tblView.setEmptyMessage1111("No post found")
            } else {
                self.tblView.setEmptyMessage1111("")
            }
            self.tblView.reloadData()
        }
    }
    
    func GETTMostRecent() {
        let serviceManager = ServiceManager<Posts>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "most-recent/\(User.shared.schoolID ?? 0)"
        serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
            
            let Posts = Response as? ResponseModel<Posts>
            self.Posts = Posts?.Data ?? []
            self.PostsMain = self.Posts
            if self.Posts.count == 0 {
                self.tblView.setEmptyMessage1111("No post found")
            } else {
                self.tblView.setEmptyMessage1111("")
            }
            self.tblView.reloadData()
        }
    }
    
    
    func deletePost(ID:Int) {
        let serviceManager = ServiceManager<Posts>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "post/\(ID)"
//        serviceManager.Parameters = ["search":self.txtSearchPost.text ?? ""]
        serviceManager.MakeServiceCall(httpMethod: .delete) { (Response) in
            let Posts = Response as? ResponseModel<Posts>
            self.Posts = Posts?.Data ?? []
            self.getPosts()
        }
    }
    
    func UpdatePost(ID:Int) {
        let serviceManager = ServiceManager<Posts>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "post/\(User.shared.schoolID ?? 0)"
        serviceManager.Parameters = ["search":self.txtSearchPost.text ?? ""]
        serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
            let Posts = Response as? ResponseModel<Posts>
            self.Posts = Posts?.Data ?? []
            self.tblView.reloadData()
        }
    }
}
//MARK:- textfieldDelegate
extension SchoolPostVC: RDSearchTextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.count ?? 0) > 0 {
            
            if self.Posts.count > 0 {
                self.Posts.removeAll()
            }
            
            self.Posts =  self.PostsMain.filter({ value -> Bool in
                guard let text =  textField.text else { return false }
                print(value)
                return (value.name!.lowercased().contains(text.lowercased()) || value.descriptionOfPost!.lowercased().contains(text.lowercased()) || value.schoolPostName!.lowercased().contains(text.lowercased())) // According to title from JSON
            })
        } else {
            
            if self.Posts.count > 0 {
                self.Posts.removeAll()
            }
            
            self.Posts = self.PostsMain
        }
//        self.arrProductModel = filterContentForSearchText(searchText: textField.text!)
        print("-----\(self.Posts)")
        if self.Posts.count == 0 {
            self.tblView.setEmptyMessage1111("No post found")
        } else {
            self.tblView.setEmptyMessage1111("")
        }
        self.tblView.reloadData()
    }
}
        
extension SchoolPostVC: PostDelegate {
    func postDelegate() {
        self.getPosts()
    }
}

// MARK:  PostCellDelegate  
extension SchoolPostVC: PostCellDelegate {
    func displayVideoOption(urlOfVideo: URL) {
        let player = AVPlayer(url: urlOfVideo)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
}
extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}
