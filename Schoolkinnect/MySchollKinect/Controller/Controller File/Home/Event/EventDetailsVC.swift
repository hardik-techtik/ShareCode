//
//  EventDetailsVC.swift
//  MySchollKinect
//
//  Created by Admin on 28/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import ExpandableLabel
import AVKit
import SDWebImage

class EventDetailsVC: BaseVC {

    @IBOutlet weak var BackView: UIView!
    @IBOutlet weak var postImage: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var time: ExpandableLabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnoption: UIButton!
//    @IBOutlet weak var objCollectionView: UICollectionView!
    @IBOutlet weak var horizontalView: PagedHorizontalView!
    @IBOutlet weak var conClgHeight: NSLayoutConstraint!
    
    var controller:UIViewController?
    
    var Event:events?
    var arrEventPhotoAndVideoList = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.objCollectionView.dataSource = self
//        self.objCollectionView.delegate = self
        self.horizontalView.collectionView.register(UINib.init(nibName: "ImageAndVideoCell", bundle: nil), forCellWithReuseIdentifier: "ImageAndVideoCell")
        
        var arrEventPhoto = [[String: Any]]()
        for photo in self.Event?.userEventPhotos ?? [] {
            if let url = URL.init(string: photo.path ?? "") {
                var dict = [String: Any]()
                dict["path"] = url
                dict["type"] = "image"
                arrEventPhoto.append(dict)
            }
        }
        for video in self.Event?.userEventVideos ?? [] {
            if let url = URL.init(string: video.path ?? "") {
                var dict = [String: Any]()
                dict["path"] = url
                dict["type"] = "video"
                arrEventPhoto.append(dict)
            }
        }
        arrEventPhotoAndVideoList = arrEventPhoto
        DispatchQueue.main.async {
            self.horizontalView.collectionView.reloadData()
        }
        
        if arrEventPhoto.count > 0 {
            self.conClgHeight.constant = 180
            self.horizontalView.pageControl?.isHidden = false
        }else {
            self.conClgHeight.constant = 0
            self.horizontalView.pageControl?.isHidden = true
        }
        
        self.lblName.text = self.Event?.eventName
        
        self.lblPlace.text = self.Event?.eventLocation
        self.lblPlace.sizeToFit()
        
        self.lblDescription.text = self.Event?.message
        guard let time = self.Event?.eventTime else { return  }
        
        let strdate = Utility.shared.DateConvertToString(inputDateformate: "yyyy-MM-dd HH:mm:ss", outputDateformate: "dd MMM yyyy hh:mm a", strScheduleDate: time)
        self.lblDate.text = strdate
        
        let strTime = Utility.shared.DateConvertToString(inputDateformate: "yyyy-MM-dd HH:mm:ss", outputDateformate: "hh:mm a", strScheduleDate: time)
        self.time.text = strTime
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.BackView.AddDefaultShadow()
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
    
    @IBAction func actionToolMenu(_ sender: UIControl) {
        self.OpenSidemenu(UIButton())
    }
    
    func PlayVideoFromURL(path: URL) {
        let player = AVPlayer(url: path)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    @IBAction func buttonClickOption(_ sender: UIButton) {
        if (self.Event?.userID ?? "") == "\((User.shared.id ?? 0))" {
            let Alert = UIAlertController.init(title: "Please select action", message: nil, preferredStyle: .actionSheet)
            
            let DeleteAction = UIAlertAction.init(title: "Delete", style: .default) { (Action) in
                self.showAlert(msg: "Are you sure want to delete?", okBtnTitle: "Yes", okBtnCompletion: {
                    let id = self.Event?.id ?? 0
                    self.DeleteEvents(ID: id)
                }) {
                    print("No")
                }
            }
            
            let UpdateAAction = UIAlertAction.init(title: "Edit", style: .default) { (Action) in
//                let Tag = button.tag
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditEventVC") as? EditEventVC else { return }
                vc.EventToEdit = self.Event
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
//                let Tag = button.tag
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportVC") as? ReportVC else { return }
                vc.ReportID = self.Event?.id ?? 0
                vc.For = "event"
                self.navigationController?.show(vc, sender: nil)
            }
            
            let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in
            }
            //Alert.addAction(DeleteAction)
            Alert.addAction(UpdateAAction)
            Alert.addAction(CancelAction)
            self.present(Alert, animated: true, completion: nil)
        }
    }
    func DeleteEvents(ID:Int) {
            let serviceManager = ServiceManager<events>.init()
            serviceManager.ShowLoader = true
            serviceManager.ServiceName = "event/\(ID)"
    //        serviceManager.Parameters = ["search":self.txtSearchEvents.text ?? ""]
            serviceManager.MakeServiceCall(httpMethod: .delete) { (Response) in
               // self.getEvents()
                self.navigationController?.popViewController(animated: true)
            }
        }
    @IBAction func buttonClickBack(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
    }
    
    @objc func actionPhoto(sender:UIButton) {
        let arrImages = self.arrEventPhotoAndVideoList.filter({$0["type"] as! String == "image"})
        
        Utility.shared.presentSKPhotoBrowser(imgUrls: arrImages.compactMap({($0["path"] as! URL).absoluteString}), index: sender.tag, viewCotroller: self)
    }
}
extension EventDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrEventPhotoAndVideoList.count == 0 ? 0 : arrEventPhotoAndVideoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageAndVideoCell", for: indexPath as IndexPath) as! ImageAndVideoCell
        let dict = arrEventPhotoAndVideoList[indexPath.item]
//        cell.btnPlay = { () -> () in
//            self.ButtonClickOpenTimeSlotView(index: indexPath.row, tag: tag, cellIndexPath: indexPath, cell: cell)
//        }
        
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk(onCompletion: nil)
        
        if (dict["type"] as? String) == "image" {
            cell.btnPlay.isHidden = true
            cell.objVideoView.isHidden = true
            cell.objOnlyImage.sd_setImage(with: dict["path"] as? URL, placeholderImage: #imageLiteral(resourceName: "Morephotos"), options: SDWebImageOptions.avoidAutoSetImage)
        } else {
            cell.btnPlay.isHidden = false
            cell.objVideoView.isHidden = false
            //let image = generateThumbnail(path: dict["path"] as! URL)
            //cell.objOnlyImage.image = image
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                let image = self.generateThumbnail(path: dict["path"] as! URL)
                DispatchQueue.main.async {
                    cell.objOnlyImage.image = image
                }
            }
            cell.btnPlayVideoClick =  { () -> () in
                print("btn play pressed")
                self.PlayVideoFromURL(path: dict["path"] as! URL)
            }
        }
        cell.objOnlyImage.contentMode = .scaleAspectFill
        
        cell.btnPhoto.tag = indexPath.item
        cell.btnPhoto.addTarget(self, action: #selector(self.actionPhoto(sender:)), for: UIControl.Event.touchUpInside)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if didSelecEvents != nil{
//            let strID = self.arrPopularList?[indexPath.row].strID
//            self.didSelecEvents(strID!)
//        }
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
