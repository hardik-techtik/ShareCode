//
//  EditPostsvc.swift
//  MySchollKinect
//
//  Created by Admin on 30/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import TLPhotoPicker
import SDWebImage

class EditPostsvc: BaseVC, TLPhotosPickerViewControllerDelegate {

    @IBOutlet weak var collectionviewHeight: NSLayoutConstraint!
    @IBOutlet weak var txtSubject: RDTextField!
    @IBOutlet weak var txtdescription: RDTextView!
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var btnAddphotoVideo: UIButton!
    @IBOutlet weak var btnPost: CornerButton!
    @IBOutlet weak var lblCollege: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblCharacterCount: UILabel!
    
    var SelectedPhotos:[UIImage] = []
    var selectedVIdeos:[URL] = []
    weak var Delegate:PostDelegate?
    var selecteAssets:[UIImage] = []
    
    var postToEdit:Posts?
    var videoToDelete:[String] = []
    var imageToDelete:[String] = []
    
    var selectedAssets = [TLPHAsset]()
    var SelectedPhotosAndVideo = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backview.AddDefaultShadow()
        self.btnPost.addTarget(self, action: #selector(Post(_:)), for: .touchUpInside)
        btnAddphotoVideo.addTarget(self, action: #selector(self.SelectAddionalPhotos(_:)), for: .touchUpInside)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionviewHeight.constant = 0
        
        let text = NSAttributedString.init(string: "Posting to the ", attributes: [NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Regular", size: 16)!,NSAttributedString.Key.foregroundColor:UIColor.init(hexFromString: "666666")])
        
        var schoolName = ""
        if let strSchoolName : String = UserDefaults.standard.value(forKey: "SchoolName") as? String {
            schoolName = strSchoolName
        }else {
            schoolName = "\(User.shared.schoolusers?.last?.school?.theNameOfYourSchool ?? "")"
        }
        
        let UnivwesityName = NSAttributedString.init(string: "\(schoolName)", attributes: [NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Medium", size: 16)!,NSAttributedString.Key.foregroundColor:UIColor.init(hexFromString: "111111")])
        
        let trailingText = NSAttributedString.init(string: " School Posts.", attributes: [NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Regular", size: 16)!,NSAttributedString.Key.foregroundColor:UIColor.init(hexFromString: "666666")])
        
        let Text = NSMutableAttributedString.init()
        Text.append(text)
        Text.append(UnivwesityName)
        Text.append(trailingText)
        
        self.lblCollege.attributedText = Text
        
        self.setupData()
        
    }
    
    func setupData() {
        self.txtSubject.text = self.postToEdit?.title ?? ""
        self.txtdescription.text = self.postToEdit?.descriptionOfPost
        self.lblCharacterCount.text = "\(self.txtdescription.text.count)/\(Utility.shared.characterLimit)"
        
        for userPhoto in self.postToEdit?.userPostPhotos ?? [] {
            var dict = [String: Any]()
            dict["id"] = userPhoto.id
            dict["path"] = ""
            dict["type"] = "image"
            dict["image"] = userPhoto.path
            dict["isNew"] = false
            self.SelectedPhotosAndVideo.append(dict)
        }
        
        for userVideo in self.postToEdit?.userPostVideos ?? [] {
            var dict = [String: Any]()
            dict["id"] = userVideo.id
            dict["path"] = userVideo.path
            dict["type"] = "video"
            dict["image"] = ""
            dict["isNew"] = false
            self.SelectedPhotosAndVideo.append(dict)
        }
        
        if self.SelectedPhotosAndVideo.count > 0 {
            self.collectionviewHeight.constant = 100
        }else {
            self.collectionviewHeight.constant = 0
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func openUserAgreeMent(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsOfUseVC") as? TermsOfUseVC else {return}
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func Post(_ button:UIButton) {
        if self.txtSubject.text?.isEmpty ?? false {
             RDalertcontoller().presentAlertWithMessage(Message:"Please enter subject",onVc:self)
        } else if self.txtdescription.text?.isEmpty ?? false {
             RDalertcontoller().presentAlertWithMessage(Message:"Please enter description",onVc:self)
        } else {
            self.EditPost()
        }
    }
    @objc func SelectAddionalPhotos(_ button:UIButton) {
        /*let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showExceededMaximumAlert(vc: picker)
        }
        viewController.customDataSouces = CustomDataSources()
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.maxVideoDuration = 20
        configure.maxSelectedAssets = 5
        viewController.configure = configure
        viewController.selectedAssets = self.selectedAssets
        viewController.logDelegate = self
        self.present(viewController, animated: true, completion: nil)*/
        
        if self.SelectedPhotosAndVideo.count == 6 {
            self.showAlert(msg: "Exceed Maximum Number Of Selection", okBtnTitle: "Ok", cancelBtnTitle: nil, okBtnCompletion: {
                
            }) {
                
            }
        }else {
            
            let alert = UIAlertController.init(title: "Choose From", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            let Camera = UIAlertAction.init(title: "Camera", style: .default) { (Action) in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    
                    let picker = UIImagePickerController.init()
                    picker.sourceType = .camera
                    picker.mediaTypes = ["public.image", "public.movie"]
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
                picker.mediaTypes = ["public.image", "public.movie"]
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
    }
}
//MARK:- collection delegate and datasource
extension EditPostsvc:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if self.selecteAssets.count > 0 {
//            self.collectionviewHeight.constant = 100
//        } else {
//            self.collectionviewHeight.constant = 0
//        }
//        UIView.animate(withDuration: 0.2) {
//            self.view.layoutIfNeeded()
//        }
         return self.SelectedPhotosAndVideo.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostAddcell", for: indexPath) as? PostAddcell
        cell?.btndelete.addTarget(self, action: #selector(deletephoto(_:)), for: .touchUpInside)
//        cell?.imgCell.image = self.selecteAssets[indexPath.item]
        let dict = self.SelectedPhotosAndVideo[indexPath.row]
               cell?.btndelete.addTarget(self, action: #selector(deletephoto(_:)), for: .touchUpInside)
               if (dict["isNew"] as! Bool) ==  true {
                   if dict["type"] as! String == "image" {
                       //                cell?.imgCell.sd_setImage(with: URL.init(string: dict["image"] as! UIImage ), placeholderImage: nil, options: SDWebImageOptions.continueInBackground, context: nil)//self.selecteAssets[indexPath.item]
                       cell?.imgCell.image = dict["image"] as? UIImage
                   } else {
                       print("---------------\(dict["path"] as! URL)")
                    
                    cell?.imgCell.image = UIImage(named: "videoPlaceholder")
                    
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                        let image = self.generateThumbnail(path: (dict["path"] as! URL?)!)
                        DispatchQueue.main.async {
                            cell?.imgCell.image = image
                        }
                    }
//                        let image = generateThumbnail(path: (dict["path"] as! URL?)!)
//                       cell?.imgCell.image = image
                   }
               } else {
                   if dict["type"] as! String == "image" {
                       cell?.imgCell.sd_setImage(with: URL.init(string: dict["image"] as! String ), placeholderImage: #imageLiteral(resourceName: "Morephotos"), options: SDWebImageOptions.continueInBackground)//self.selecteAssets[indexPath.item]
                   } else {
                    
                    cell?.imgCell.image = UIImage(named: "videoPlaceholder")
                    
                    let url = URL(string: dict["path"] as? String ?? "")
                    
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                        let image = self.generateThumbnail(path: url!)
                        DispatchQueue.main.async {
                            cell?.imgCell.image = image
                        }
                    }
                    
                        
                       
                   }
               }
        cell?.btndelete.tag = indexPath.item
        return cell ?? UICollectionViewCell()
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
//    @objc func deletephoto(_ button:UIButton) {
//        let tag = button.tag
//        let IMage = self.selecteAssets[tag]
//        if let index = self.SelectedPhotos.lastIndex(of: IMage) {
//            self.SelectedPhotos.remove(at: index)
//        }
//        if let id = IMage.accessibilityIdentifier {
//            if let index = self.selectedVIdeos.lastIndex(of: URL.init(string: id)!) {
//                self.selectedVIdeos.remove(at: index)
//            }
//        }
//        self.selecteAssets.remove(at: tag)
//        self.collectionView.reloadData()
//    }
    @objc func deletephoto(_ button:UIButton) {
        let tag = button.tag
        let dict = self.SelectedPhotosAndVideo[tag]
        if (dict["isNew"] as! Bool) ==  true {
            self.SelectedPhotosAndVideo.remove(at: tag)
        } else {
            if dict["type"] as! String == "image" {
                self.imageToDelete.append("\(self.SelectedPhotosAndVideo[tag]["id"] ?? "0")")
                self.SelectedPhotosAndVideo.remove(at: tag)
                //                self.SelectedPhotos.remove(at: tag)
//                self.event_picture_id.append(dict["id"] as! Int)
            } else {
//                event_video_id.append(dict["id"] as! Int)
                self.videoToDelete.append("\(self.SelectedPhotosAndVideo[tag]["id"] ?? "0")")
                self.SelectedPhotosAndVideo.remove(at: tag)
            }
        }
        
        if self.SelectedPhotosAndVideo.count > 0 {
            self.collectionviewHeight.constant = 100
        }else {
            self.collectionviewHeight.constant = 0
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
//MARK:- imagePickerDelegate
//extension EditPostsvc:GMImagePickerControllerDelegate {
//    func assetsPickerController(_ picker: GMImagePickerController!, didFinishPickingAssets assets: [Any]!) {
//        self.dismiss(animated: true, completion: nil)
//        for asset in assets {
//            if (asset as? PHAsset)?.mediaType == PHAssetMediaType.image {
//                if let image = asset as? PHAsset {
//                    PHImageManager().requestImage(for: image, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: .none) { (image, nil) in
//                        self.SelectedPhotos.append(image ?? UIImage())
//                        self.selecteAssets.append(image ?? UIImage())
//                    }
//                }
//            } else if (asset as? PHAsset)?.mediaType == PHAssetMediaType.video {
//                if let video = asset as? PHAsset {
//                    let url = self.getVideoUrlFromPHAsset(video)
//                    self.selectedVIdeos.append(url.url)
//                    getThumbnailImageFromVideoUrl(url: url.url) { (Image) in
//                        Image?.accessibilityIdentifier = url.url.absoluteString
//                        self.selecteAssets.append(Image ?? UIImage())
//                        self.collectionviewHeight.constant = 100
//                        UIView.animate(withDuration: 0.2) {
//                            self.view.layoutIfNeeded()
//                        }
//                        self.collectionView.reloadData()
//                    }
//                }
//            }
//        }
//        if selecteAssets.count > 0 {
//            self.collectionviewHeight.constant = 100
//            UIView.animate(withDuration: 0.2) {
//                self.view.layoutIfNeeded()
//            }
//            self.collectionView.reloadData()
//        }
//    }
    
//}

extension EditPostsvc: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        self.lblCharacterCount.text = "\(numberOfChars)/\(Utility.shared.characterLimit)"
        return numberOfChars < Utility.shared.characterLimit
        
        //        if textView == objTextViewExtraFeedback {
        ////            self.objLabelTellUsAbtTask.text = "\(numberOfChars)/25+"
        ////            intTellAboutTaskCount = numberOfChars
        //            return numberOfChars < 50
        //        } else {
        //        }
        //return true
    }
}
//MARK:- webservice
extension EditPostsvc {
    func getVideoUrlFromPHAsset(_ asset:PHAsset)->AVURLAsset{
        let semaphore = DispatchSemaphore(value: 0)
        var videoObj:AVURLAsset? = nil
        let options = PHVideoRequestOptions()
        // options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        PHImageManager().requestAVAsset(forVideo:asset, options: options, resultHandler: { (avurlAsset, audioMix, dict) in
            videoObj = avurlAsset as? AVURLAsset
            semaphore.signal()
        })
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return videoObj!
    }
    func EditPost() {
        self.SelectedPhotos.removeAll()
        self.selectedVIdeos.removeAll()
        
        for each in self.SelectedPhotosAndVideo {
            if (each["isNew"] as! Bool) ==  true {
                if each["type"] as! String == "image" {
                    //                    let str = imageToBase64((each["image"] as? UIImage)!)
                    self.SelectedPhotos.append((each["image"] as? UIImage)!)//((each["image"] as? UIImage)!)
                } else {
                    self.selectedVIdeos.append(each["path"] as! URL)
                }
            }
        }
        let serviceManager = ServiceManager<EditPosts>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "post-edit/\(self.postToEdit?.id ?? 0)"
        if self.SelectedPhotos.count > 0 {
            serviceManager.AttachmentParameter = "post_picture[]"
            serviceManager.Attachments = self.SelectedPhotos
        }
        if (self.selectedVIdeos.count ) > 0 {
            serviceManager.VideoAttachmentParameter = "post_video[]"
            serviceManager.VideoAttachments = self.selectedVIdeos
        }
        
        var dict : [String:Any] = [String:Any]()
        
        dict["name"] = self.postToEdit?.user?.firstName ?? "" + " " + (self.postToEdit?.user?.lastName ?? "")
        dict["message"] = ""
        dict["school_id"] = User.shared.schoolID ?? ""
        dict["title"] = self.txtSubject.text ?? ""
        dict["description_of_post"] = self.txtdescription.text ?? ""
        
        if self.videoToDelete.count > 0 {
            dict["post_video_id"] = videoToDelete.joined(separator: ",")
        }
        
        if self.imageToDelete.count > 0  {
            dict["post_picture_id"] = imageToDelete.joined(separator: ",")
        }
        
        serviceManager.Parameters = dict
        /*[
            "name": self.postToEdit?.user?.firstName ?? "" + " " + (self.postToEdit?.user?.lastName ?? ""),
            "message": "",
            "school_id":User.shared.schoolID ?? "",
            "title":self.txtSubject.text ?? "",
            "description_of_post":self.txtdescription.text ?? "",
            "post_video_id":videoToDelete.joined(),
            "post_picture_id":imageToDelete.joined(),
        ]*/
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            _ = Response as? ResponseModel<EditPosts>
            
            self.navigationController?.popViewController(animated: true)
            //RDalertcontoller().presentAlertWithMessage(Message:"Update post sucessfully",onVc:self)
            RDalertcontoller().presentAlertWithMessage(Message:"Post updated sucessfully",onVc:self)
            self.Delegate?.postDelegate()
        }
    }
}

extension EditPostsvc : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let url = info[.mediaURL] as? URL {
            
            if getVideoTimeDuration(url: url) > 35 {
                RDalertcontoller().presentAlertWithMessage(Message:"Video should be less than or equal to 35 seconds.",onVc:self)
            }else {
                getThumbnailImageFromVideoUrl(url: url) { (Image) in
                    
                    var dict = [String: Any]()
                    dict["id"] = 0
                    dict["path"] = url
                    dict["type"] = "video"
                    dict["image"] = Image
                    dict["isNew"] = true
                    self.SelectedPhotosAndVideo.append(dict)
                    
                    self.collectionviewHeight.constant = 100
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
        if let editedImg = info[UIImagePickerController.InfoKey.editedImage] {
            
            var dict = [String: Any]()
            dict["id"] = 0
            dict["path"] = ""
            dict["type"] = "image"
            dict["image"] = editedImg as? UIImage
            dict["isNew"] = true
            self.SelectedPhotosAndVideo.append(dict)
            
            self.collectionviewHeight.constant = 100
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        
    }
}

extension EditPostsvc {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets
//        isImageSelectFromGallery = true
        getFirstSelectedImage()
    }
    func exportVideo() {
        if let asset = self.selectedAssets.first, asset.type == .video {
            asset.exportVideoFile(progressBlock: { (progress) in
                print(progress)
            }) { (url, mimeType) in
                print("completion\(url)")
                print(mimeType)
            }
        }
    }
    func getFirstSelectedImage() {
        for each in self.selectedAssets {
            if each.type == .video {
                each.tempCopyMediaFile { (url, strings) in
                    print("-------URl-\(url), ---string ---\(strings)")
                    getThumbnailImageFromVideoUrl(url: url) { (Image) in
                        var dict = [String: Any]()
                        dict["id"] = 0
                        dict["path"] = url
                        dict["type"] = "video"
                        dict["image"] = Image
                        dict["isNew"] = true
                        self.SelectedPhotosAndVideo.append(dict)
                    }
                }
            } else if let image = each.fullResolutionImage {
                print(image)
                var dict = [String: Any]()
                dict["id"] = 0
                dict["path"] = ""
                dict["type"] = "image"
                dict["image"] = image
                dict["isNew"] = true
                self.SelectedPhotosAndVideo.append(dict)
            } else {
                print("Can't get image at local storage, try download image")
                each.cloudImageDownload(progressBlock: { [weak self] (progress) in
                    DispatchQueue.main.async {
                        print(progress)
                    }
                    }, completionBlock: { [weak self] (image) in
                        if image != nil {
                            //use image
                            DispatchQueue.main.async { }
                        }
                })
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        // if you want to used phasset.
    }
    func photoPickerDidCancel() {
        // cancel
    }
    func dismissComplete() {
        // picker dismiss completion
    }
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        self.showExceededMaximumAlert(vc: picker)
    }
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        picker.dismiss(animated: true) {
            let alert = UIAlertController(title: "My School Kinect", message: "Denied albums permissions granted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        let alert = UIAlertController(title: "My School Kinect", message: "Denied camera permissions granted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        picker.present(alert, animated: true, completion: nil)
    }
    func showExceededMaximumAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "My School Kinect", message: "Exceed Maximum Number Of Selection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    func showUnsatisifiedSizeAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "Oups!", message: "The required size is: 300 x 300", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
/*extension EditPostsvc: TLPhotosPickerLogDelegate {
    //For Log User Interaction
    func selectedCameraCell(picker: TLPhotosPickerViewController) {
        print("selectedCameraCell")
    }
    func selectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        print("selectedPhoto")
    }
    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        print("deselectedPhoto")
    }
    func selectedAlbum(picker: TLPhotosPickerViewController, title: String, at: Int) {
        print("selectedAlbum")
    }
}*/
