//
//  SchoolPostVC.swift
//  MySchollKinect
//
//  Created by Admin on 25/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SDWebImage
import Lightbox
import AVFoundation
import IQKeyboardManagerSwift

class SchoolPostVC: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var PlusButton: UIButton!
    
//    @IBOutlet weak var postMediaVie: UIView!
    @IBOutlet weak var txtSearchPost: RDSearchTextField!
//    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var topPost: UIButton!
    @IBOutlet weak var btnAddPost: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var backview: UIView!
    
    var Posts:[Posts] = []
    var PostsMain:[Posts] = []
    
    var issearching = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlusButton.imageView?.contentMode = .scaleAspectFit
        self.tblView.delegate = self
        self.tblView.dataSource = self
        btnAddPost.addTarget(self, action: #selector(Addpost(_:)), for: .touchUpInside)
        self.tblView.setEmptyMessage1111("No post found")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getPosts()
        self.backview.AddDefaultShadow()
        self.txtSearchPost.delegate = self
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
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
}
extension SchoolPostVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Posts.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.isKind(of: LightboxController.self) {
            let cell = cell as? PostCell
            cell?.controller?.removeFromParent()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Post = self.Posts[indexPath.row]
        if !(Post.userPostPhotos?.isEmpty ?? false) || !(Post.userPostVideos?.isEmpty ?? false) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell
            var photoVideo:[LightboxImage] = []
            for image in Post.userPostPhotos ?? [] {
                if let url = URL.init(string: image.path ?? "") {
                    photoVideo.append(LightboxImage.init(imageURL: url))
                }
            }
            for video in Post.userPostVideos ?? [] {
                if let url = URL.init(string: video.path ?? "") {
                    photoVideo.append(LightboxImage.init(imageURL: url))
                }
            }
            
            
            cell?.controller = LightboxController(images: photoVideo)
            LightboxConfig.hideStatusBar = true
            LightboxConfig.CloseButton.text = ""
            if let controller = cell?.controller {
                self.addChild(controller)
                cell?.PostIMage.addSubview(controller.view)
                controller.view.frame = cell?.PostIMage.bounds ?? CGRect.zero
                controller.view.backgroundColor = UIColor.white
                cell?.PostIMage.clipsToBounds = true
                cell?.controller?.didMove(toParent: self)
            }
            let tapOnProfile = UITapGestureRecognizer.init(target: self, action: #selector(OpenProfile(_:)))
            cell?.lblTItle.text = Post.title
            cell?.btnReplies.addTarget(self, action: #selector(Reply(_:)), for: .touchUpInside)
            cell?.ProfileIMage.tag = indexPath.row
            cell?.ProfileIMage.layer.cornerRadius = (cell?.ProfileIMage.frame.height ?? 0.0)/2
            cell?.ProfileIMage.layer.masksToBounds = true
            cell?.ProfileIMage.isUserInteractionEnabled = true
            
            cell?.lblUserName.tag = indexPath.row
            cell?.ProfileIMage.tag = indexPath.row
            cell?.lblUserName.isUserInteractionEnabled = true
            cell?.ProfileIMage.addGestureRecognizer(tapOnProfile)
            cell?.lblUserName.addGestureRecognizer(tapOnProfile)
            cell?.lblDescription.shouldExpand = true
            cell?.lblDescription.isUserInteractionEnabled = true
            cell?.btnLika.addTarget(self, action: #selector(Like(_:)), for: .touchUpInside)
            cell?.btnLika.tag = indexPath.row
            cell?.selectionStyle = .none
            cell?.lblDescription.numberOfLines = 3
            cell?.lblDescription.text = Post.descriptionOfPost
            cell?.lblDescription.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(OpenCloseLabel(_:))))
            cell?.lblUserName.text = Post.name
            cell?.lblDescription.collapsed = true
            cell?.btnMessage.addTarget(self, action: #selector(openChat(_:)), for: .touchUpInside)
            cell?.lblDescription.collapsedAttributedLink = NSAttributedString.init(attributedString: NSAttributedString.init(string: "See More", attributes: [NSAttributedString.Key.foregroundColor : UIColor.forGroundColor]))
            cell?.btnReply.addTarget(self, action: #selector(Reply(_:)), for: .touchUpInside)
            cell?.ProfileIMage.sd_setImage(with: URL.init(string:  Post.postPicture ?? ""), placeholderImage: UIImage.placeholder2, options: SDWebImageOptions.continueInBackground, completed: nil)
            cell?.lblUserName.text = self.Posts[indexPath.row].name
            cell?.btnMore.addTarget(self, action: #selector(self.options(_:)), for: .touchUpInside)
            cell?.btnMessage.tag = indexPath.row
            cell?.btnMore.tag = indexPath.row
            cell?.btnLika.setTitle(" \(formatNumber(Post.likesCount ?? 0))", for: .normal)
            cell?.btnReplies.setTitle(" \(formatNumber(Post.postcommentCount ?? 0)) Replies", for: .normal)
            if (self.Posts[indexPath.row].userID ?? 0) == (User.shared.id ?? 0) {
                cell?.btnMessage.isHidden = true
            }
            else
            {
                cell?.btnMessage.isHidden = false
            }
            
            return cell ?? UITableViewCell()
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCellWithoutImage") as? PostCellWithoutImage
            cell?.btnMore.tag = indexPath.row
            cell?.btnMore.addTarget(self, action: #selector(self.options(_:)), for: .touchUpInside)
            if (self.Posts[indexPath.row].userID ?? 0) == (User.shared.id ?? 0) {
                cell?.btnMessage.isHidden = true
            }
            else
            {
                cell?.btnMessage.isHidden = false
            }
            cell?.lblDescription.tag = indexPath.row
            cell?.lblDescription.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(OpenCloseLabel(_:))))
            cell?.lblDescription.numberOfLines = 5
            cell?.lblUserName.text = Post.name
            cell?.lblTitle.text = Post.title
            cell?.btnMessage.addTarget(self, action: #selector((openChat(_:))), for: .touchUpInside)
            cell?.btnlike.tag = indexPath.row
            cell?.btnlike.setTitle(" \(formatNumber(Post.likesCount ?? 0))", for: .normal)
            cell?.btnreply.setTitle(" \(formatNumber(Post.postcommentCount ?? 0)) Replies", for: .normal)
            cell?.lblDescription.text = Post.descriptionOfPost
            cell?.lblDescription.isUserInteractionEnabled = true
            cell?.lblDescription.collapsed = true
            cell?.lblDescription.shouldExpand = true
            cell?.lblDescription.collapsedAttributedLink = NSAttributedString.init(attributedString: NSAttributedString.init(string: "See More", attributes: [NSAttributedString.Key.foregroundColor : UIColor.forGroundColor]))
            cell?.selectionStyle = .none
            cell?.btnlike.addTarget(self, action: #selector(Like(_ :)), for: .touchUpInside)
            let tapOnProfile1 = UITapGestureRecognizer.init(target: self, action: #selector(OpenProfile(_:)))
            cell?.ProfileIMage.tag = indexPath.row
            cell?.ProfileIMage.isUserInteractionEnabled = true
            
            cell?.ProfileIMage.layer.cornerRadius = (cell?.ProfileIMage.frame.height ?? 0.0)/2
            cell?.ProfileIMage.layer.masksToBounds = true
            cell?.lblUserName.tag = indexPath.row
            cell?.lblUserName.isUserInteractionEnabled = true
            cell?.ProfileIMage.addGestureRecognizer(tapOnProfile1)
            cell?.lblUserName.addGestureRecognizer(tapOnProfile1)
            cell?.btnMore.addTarget(self, action: #selector(self.options(_:)), for: .touchUpInside)
            cell?.btnMessage.tag = indexPath.row
            return cell ?? UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func openChat(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessagesVC") as? MessagesVC else { return }
        vc.RecieverID = self.Posts[button.tag].userID ?? 0
        print("school posts vc-----------\(self.Posts[button.tag].userID ?? 0)")
        self.navigationController?.show(vc, sender: nil)
    }
    @objc func options(_ button:UIButton) {
        if (self.Posts[button.tag].userID ?? 0) == (User.shared.id ?? 0) {
            let Alert = UIAlertController.init(title: "Please select action", message: nil, preferredStyle: .actionSheet)
            let DeleteAction = UIAlertAction.init(title: "Delete", style: .default) { (Action) in
                let Tag = button.tag
                let id = self.Posts[Tag].id ?? 0
                self.deletePost(ID: id)
            }
            let UpdateAAction = UIAlertAction.init(title: "Update", style: .default) { (Action) in
                _ = button.tag
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditPostsvc") as? EditPostsvc else { return }
                vc.postToEdit = self.Posts[button.tag]
                self.navigationController?.show(vc, sender: nil)
            }
            let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in
            }
            Alert.addAction(DeleteAction)
            Alert.addAction(UpdateAAction)
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
                vc.For = "post"
                self.navigationController?.show(vc, sender: nil)
            }
            let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in
            }
            Alert.addAction(DeleteAction)
            Alert.addAction(UpdateAAction)
            Alert.addAction(CancelAction)
            self.present(Alert, animated: true, completion: nil)
        }
    }
    @objc func Reply(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostReplyVC") as? PostReplyVC else { return }
        vc.postID = self.Posts[button.tag].id ?? 0
        self.navigationController?.show(vc, sender: nil)
    }
    @objc func OpenProfile(_ tap:UILongPressGestureRecognizer) {
        if tap.state == .recognized {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else { return }
            let view = tap.view
            vc.postID = self.Posts[view!.tag].userID ?? 0
            self.navigationController?.show(vc, sender: nil)
        }
    }
    @objc func OpenCloseLabel(_ tap:UITapGestureRecognizer) {
        let tag = tap.view?.tag ?? 0
        let Post = self.Posts[tag]
        if Post.postPicture != nil {
            let cell = self.tblView.cellForRow(at: IndexPath.init(row: tag, section: 0)) as? PostCell
            cell?.lblDescription.collapsed = !(cell?.lblDescription.collapsed ?? false)
        } else {
            let cell = self.tblView.cellForRow(at: IndexPath.init(row: tag, section: 0)) as? PostCellWithoutImage
            cell?.lblDescription.collapsed = !(cell?.lblDescription.collapsed ?? false)
        }
        self.tblView.beginUpdates()
        self.tblView.endUpdates()
    }
    @objc func Like(_ button:UIButton) {
        let index = button.tag
        let Id = self.Posts[index].id ?? 0
        self.PostLike(ID: Id, Like: 1)
    }
}
extension SchoolPostVC {
    func getPosts() {
        let serviceManager = ServiceManager<Posts>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "post-list/\(String(describing: User.shared.schoolID))"
        //serviceManager.Parameters = ["search":self.txtSearchPost.text ?? ""]
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
    func PostLike(ID:Int,Like:Int) {
        let serviceManager = ServiceManager<PostLike>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "post-like"
        serviceManager.Parameters =  ["post_id":ID, "like":Like]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            self.getPosts()
        }
    }
    func deletePost(ID:Int) {
        let serviceManager = ServiceManager<Posts>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "post-list/\(ID)"
//        serviceManager.Parameters = ["search":self.txtSearchPost.text ?? ""]
        serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
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
extension SchoolPostVC:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.count ?? 0) > 0 {
            //            for a
            self.Posts = self.PostsMain.filter({ value -> Bool in
                guard let text =  textField.text else { return false}
                print(value)
                return (value.name!.lowercased().contains(text.lowercased()) || value.descriptionOfPost!.lowercased().contains(text.lowercased()) || value.schoolPostName!.lowercased().contains(text.lowercased())) // According to title from JSON
                
            })
        } else {
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
//    func filterContentForSearchText(searchText: String) -> [ProductModel]{
//        let arr = arrProductModelMain.filter { item in
//                    let arr = item.objProductModel.filter { item1 in
//                        return item1.productName.lowercased().contains(searchText.lowercased())
//                    }
//                    return true
//        //            return item.category_english.lowercased().contains(searchText.lowercased())
//                }
//        return arr
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        //        self.getEvents()
        return true
    }
}
extension SchoolPostVC: PostDelegate {
    func postDelegate() {
        self.getPosts()
    }
}
