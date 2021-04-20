//
//  ShareVideoVC.swift
//  MySchollKinect
//
//  Created by Shreyansh on 24/06/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import AVKit
import SDWebImage
import AVFoundation

class ShareVideoVC: BaseVC {
    
    @IBOutlet weak var tblVideoList: reloadTable!
    @IBOutlet weak var vwBack: UIView!
    
    fileprivate var arrVideos : [ShareVideo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupData()
    }
    
    func setupUI() {
        //self.vwBack.AddDefaultShadow()
    }
    
    func setupData() {
        self.getVideolist()
    }

}

//MARK:- Button actions
extension ShareVideoVC {
    @IBAction func actionAddVideo(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddShareVideoVC") as? AddShareVideoVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK:- Custom methods
extension ShareVideoVC {
    func getVideolist() {
        let serviceManager = ServiceManager<ShareVideo>.init()
        serviceManager.ShowLoader = false
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "share-video"
        serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
            
            let videos = Response as? ResponseModel<ShareVideo>
            
            if self.arrVideos.count > 0 {
                self.arrVideos.removeAll()
            }
            
            self.arrVideos = videos?.Data ?? []
            
            self.tblVideoList.setEmptyMsg(msg: "No video shared yet.")
        }
    }
    
    func addVideoCount(videoId:Int,urlOfVideo:URL) {
        let serviceManager = ServiceManager<ShareVideo>.init()
        serviceManager.ShowLoader = false
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "video-view"
        serviceManager.Parameters = ["video_id":videoId,"video_count":100]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            
            let player = AVPlayer(url: urlOfVideo)
            let playerController = AVPlayerViewController()
            playerController.player = player
            self.present(playerController, animated: true) {
                player.play()
            }
//            let videos = Response as? ResponseModel<ShareVideo>
//
//            if self.arrVideos.count > 0 {
//                self.arrVideos.removeAll()
//            }
//
//            self.arrVideos = videos?.Data ?? []
//
//            self.tblVideoList.setEmptyMsg(msg: "No video shared yet.")
        }
    }
    
    func getThumbnailImageFromURL(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func displayVideoOption(urlOfVideo: URL,index : Int) {
        
        if self.arrVideos[index].users?.first?.id != User.shared.id {
            self.addVideoCount(videoId: self.arrVideos[index].id ?? 0,urlOfVideo: urlOfVideo)
        }else {
            let player = AVPlayer(url: urlOfVideo)
            let playerController = AVPlayerViewController()
            playerController.player = player
            present(playerController, animated: true) {
                player.play()
            }
        }
    }
    
    func showActionSheet(btnTag:Int) {
        
        let objVideo = self.arrVideos[btnTag]

        
        let Alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let DeleteAction = UIAlertAction.init(title: "Delete", style: .default) { (Action) in
            self.showAlert(msg: "Are you sure you want to delete this video?", okBtnTitle: "Yes", cancelBtnTitle: "No", okBtnCompletion: {
                self.deleteVideo(videoId: objVideo.id ?? 0)
            }) {
                print("No")
            }
        }
        let ReportAction = UIAlertAction.init(title: "Report", style: .default) { (Action) in
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportVC") as? ReportVC else { return }
            vc.ReportID = objVideo.id ?? 0
            vc.userId = objVideo.userId ?? 0
            vc.For = "video"
            self.navigationController?.show(vc, sender: nil)
        }
        let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in
       
        }
        let BlockUserAction = UIAlertAction.init(title: "Block User", style: .default) { (Action) in
            self.blockUser(TouserId: objVideo.userId ?? 0)
        }
        
        
        if objVideo.users?.first?.id == User.shared.id {
            Alert.addAction(DeleteAction)
        }else {
            Alert.addAction(ReportAction)
            Alert.addAction(BlockUserAction)
        }
        
        Alert.addAction(CancelAction)
        self.present(Alert, animated: true, completion: nil)
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
    func deleteVideo(videoId:Int) {
        let serviceManager = ServiceManager<ShareVideo>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "share-video/\(videoId)"
//        serviceManager.Parameters = ["search":self.txtSearchPost.text ?? ""]
        serviceManager.MakeServiceCall(httpMethod: .delete) { (Response) in
            let response = Response as? ResponseModelSuccess
            RDalertcontoller().presentAlertWithMessage(Message:response?.errorMsg ?? "Video deleted successfully.",onVc:self)
            self.getVideolist()
        }
    }
    
    @objc func openProfile(_ sender:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else { return }
        vc.postID = self.arrVideos[sender.tag].userId ?? 0
        self.navigationController?.show(vc, sender: nil)
    }
    
}
//MARK:- Tableview datasource and delegate
extension ShareVideoVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareVideoIdentifier") as? ShareVideoCell
        
        let objVideo = self.arrVideos[indexPath.row]
        cell?.lblUsername.text = (objVideo.users?.first?.firstName ?? "") + " " + (objVideo.users?.first?.lastName ?? "")
        
        cell?.lblDesscription.text = objVideo.description ?? ""
        
        cell?.imgUserProfile.sd_setImage(with: URL.init(string:  objVideo.users?.first?.profilePic ?? ""), placeholderImage: #imageLiteral(resourceName: "Profile"), options: SDWebImageOptions.continueInBackground, completed: nil)
        
        cell?.lblViewCount.text = "\(objVideo.video_count ?? 0) View\(objVideo.video_count ?? 0 > 1 ? "s":"")"
        
        cell?.lblViewCount.isHidden = objVideo.video_count == 0 ? true : false
        
        if objVideo.users?.first?.id == User.shared.id {
            cell?.btnOption.isHidden = false
        }else {
            cell?.btnOption.isHidden = false
        }
        
        
            
        cell?.setVideoThumnailData(dict: objVideo)
        
       
        
        cell?.btnPlay.isHidden = false
        cell?.btnProfile.tag = indexPath.row
        cell?.btnProfile.addTarget(self, action: #selector(self.openProfile(_:)), for: UIControl.Event.touchUpInside)
        
        
        cell?.playVideoClauser = { ()->() in
            guard let videoPath = URL(string: objVideo.strVideo ?? "") else {
                return
            }
            self.displayVideoOption(urlOfVideo: videoPath,index: indexPath.row)
        }
        
        cell?.moreActionClauser = { () -> () in
            print("more button tapped")
            self.showActionSheet(btnTag: indexPath.row)
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
