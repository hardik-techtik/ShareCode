//
//  AddpostVC.swift
//  MySchollKinect
//
//  Created by Admin on 26/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import TLPhotoPicker
import SDWebImage
import AVKit
import Photos


protocol PostDelegate:class {
    func postDelegate()
}

class AddpostVC: BaseVC, TLPhotosPickerViewControllerDelegate {

    @IBOutlet weak var collectionviewHeight: NSLayoutConstraint!
    @IBOutlet weak var txtSubject: RDTextField!
    @IBOutlet weak var txtdescription: RDTextView!
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var btnAddphotoVideo: UIButton!
    @IBOutlet weak var btnPost: CornerButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblCollege: UILabel!
    @IBOutlet weak var lblCharacterCount: UILabel!
    
    var SelectedPhotos:[UIImage] = []
    var selectedVIdeos:[URL] = []
    weak var Delegate:PostDelegate?
    var selecteAssets:[UIImage] = []
    
    var postToEdit:Posts?
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
        //Posting to the University of Texas San Antonio School Posts.
        let text = NSAttributedString.init(string: "Posting to the", attributes: [NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Regular", size: 16)!,NSAttributedString.Key.foregroundColor:UIColor.init(hexFromString: "666666")])
        
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

    }
    
    
    @objc func Post(_ button:UIButton) {
        if self.txtSubject.text?.isEmpty ?? false {
             RDalertcontoller().presentAlertWithMessage(Message:"Please enter subject",onVc:self)
        } else if self.txtdescription.text?.isEmpty ?? false {
             RDalertcontoller().presentAlertWithMessage(Message:"Please enter description",onVc:self)
        } else {
            self.Addpost()
        }
    }
    @objc func SelectAddionalPhotos(_ button:UIButton) {
        
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
    
    @IBAction func actionUserAgrrement(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsOfUseVC") as? TermsOfUseVC else {return}
        self.navigationController?.show(vc, sender: nil)
    }
}
//MARK:- collection delegate and datasource
extension AddpostVC:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if self.selecteAssets.count > 0 {
//            self.collectionviewHeight.constant = 100
//        } else {
//            self.collectionviewHeight.constant = 0
//        }
//        UIView.animate(withDuration: 0.2) {
//            self.view.layoutIfNeeded()
//        }
//        return self.selecteAssets.count
        return self.SelectedPhotosAndVideo.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostAddcell", for: indexPath) as? PostAddcell
        cell?.btndelete.addTarget(self, action: #selector(deletephoto(_:)), for: .touchUpInside)
         let dict = self.SelectedPhotosAndVideo[indexPath.row]
         
          if (dict["isNew"] as! Bool) ==  true {
            
            cell?.imgCell.image = dict["image"] as? UIImage
//               if dict["type"] as! String == "image" {
//                   //                cell?.imgCell.sd_setImage(with: URL.init(string: dict["image"] as! UIImage ), placeholderImage: nil, options: SDWebImageOptions.continueInBackground, context: nil)//self.selecteAssets[indexPath.item]
//                   cell?.imgCell.image = dict["image"] as? UIImage
//               } else {
//                   print("---------------\(dict["path"] as! URL)")
//                   //let image = generateThumbnail(path: (dict["path"] as! URL?)!)
//                   cell?.imgCell.image = dict["image"] as? UIImage
//               }
          }else {
            if dict["type"] as! String == "image" {
                cell?.imgCell.sd_setImage(with: URL.init(string: dict["path"] as! String), placeholderImage: nil, options: SDWebImageOptions.continueInBackground)//self.selecteAssets[indexPath.item]
            } else {
                let image = generateThumbnail(path: URL(string: dict["path"] as! String)!)
                cell?.imgCell.image = image
            }
          }
           cell?.imgCell.layer.cornerRadius = 6
           cell?.imgCell.layer.masksToBounds = true
           cell?.imgCell.contentMode = .scaleAspectFill
           cell?.btndelete.tag = indexPath.item
           cell?.imgCell.contentMode = .scaleAspectFill
        
        return cell ?? UICollectionViewCell()
    }
    @objc func deletephoto(_ button:UIButton) {
        let tag = button.tag
        let dict = self.SelectedPhotosAndVideo[tag]
        if (dict["isNew"] as! Bool) ==  true {
            self.SelectedPhotosAndVideo.remove(at: tag)
        } else {
            if dict["type"] as! String == "image" {
                self.SelectedPhotosAndVideo.remove(at: tag)
                
            } else {
                self.SelectedPhotosAndVideo.remove(at: tag)
            }
        }
        if SelectedPhotosAndVideo.count > 0 {
            self.collectionviewHeight.constant = 100
        } else {
            collectionviewHeight.constant = 0
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
//MARK:- imagePickerDelegate
extension AddpostVC : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        self.lblCharacterCount.text = "\(numberOfChars)/\(Utility.shared.characterLimit)"
        return numberOfChars < Utility.shared.characterLimit
    }
    
}

//MARK:- imagePickerDelegate
//extension AddpostVC:GMImagePickerControllerDelegate {
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
//    func getVideoUrlFromPHAsset(_ asset:PHAsset)->AVURLAsset {
//        let semaphore = DispatchSemaphore(value: 0)
//        var videoObj:AVURLAsset? = nil
//        let options = PHVideoRequestOptions()
//        // options.isSynchronous = true
//        options.deliveryMode = .highQualityFormat
//        PHImageManager().requestAVAsset(forVideo:asset, options: options, resultHandler: { (avurlAsset, audioMix, dict) in
//            videoObj = avurlAsset as? AVURLAsset
//            semaphore.signal()
//        })
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//        return videoObj!
//    }
//}
//MARK:- webservice
extension AddpostVC {
    func Addpost() {
        /*for each in self.SelectedPhotosAndVideo {
                    if (each["isNew"] as! Bool) ==  true {
                        if each["type"] as! String == "image" {
        //                    let str = imageToBase64((each["image"] as? UIImage)!)
                            self.SelectedPhotos.append((each["image"] as? UIImage)!)//((each["image"] as? UIImage)!)
                        } else {
                            self.selectedVIdeos.append(each["path"] as! URL)
                        }
                    }
                }*/
        
        let serviceManager = ServiceManager<AddPosts>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "post"
        serviceManager.AttachmentParameter = "post_picture[]"
        //serviceManager.Attachments = self.SelectedPhotosAndVideo.compactMap({$0["image"] as? UIImage})
        let arrImages : [[String: Any]] = self.SelectedPhotosAndVideo.filter({$0["type"] as! String == "image" })
        serviceManager.Attachments = arrImages.compactMap({$0["image"] as? UIImage})
        serviceManager.VideoAttachmentParameter = "post_video[]"
        let str = self.SelectedPhotosAndVideo.compactMap({$0["path"] as? URL})
        
        if str.count != 0{
            let image = generateThumbnail(path: str[0]) ?? #imageLiteral(resourceName: "videoPlaceholder")
           serviceManager.arrVideoThumbnail = [UIImage]()
            serviceManager.arrVideoThumbnail?.append(image)
        }
//        }
       
        print(serviceManager.arrVideoThumbnail)
//        serviceManager.VideoThumbnail = image
        serviceManager.VideoAttachments = self.SelectedPhotosAndVideo.compactMap({$0["path"] as? URL})
        /*if self.SelectedPhotos.count > 0 {
            serviceManager.AttachmentParameter = "post_picture[]"
            serviceManager.Attachments = self.SelectedPhotosAndVideo.compactMap({$0["image"] as? UIImage})
        }
        if (self.selectedVIdeos.count ) > 0 {
            serviceManager.VideoAttachmentParameter = "post_video[]"
            serviceManager.VideoAttachments = self.SelectedPhotosAndVideo.compactMap({$0["path"] as? URL})
        }*/
        serviceManager.Parameters = [
            "name": User.shared.firstName ?? "" + " " + (User.shared.lastName ?? ""),
            "message": "",
            "school_id":User.shared.schoolID ?? "",
            "title":self.txtSubject.text ?? "",
            "description_of_post":self.txtdescription.text ?? ""
        ]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            _ = Response as? ResponseModel<AddPosts>
            self.navigationController?.popViewController(animated: true)
            RDalertcontoller().presentAlertWithMessage(Message:"Post added sucessfully",onVc:self)
            self.Delegate?.postDelegate()
        }
    }
}
extension AddpostVC {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets
        
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
        if SelectedPhotosAndVideo.count > 0 {
            self.collectionviewHeight.constant = 100
        } else {
            collectionviewHeight.constant = 0
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
        let alert = UIAlertController(title: "Ops!", message: "The required size is: 300 x 300", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
extension AddpostVC: TLPhotosPickerLogDelegate {
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
}
extension AddpostVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
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
