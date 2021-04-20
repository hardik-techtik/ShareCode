//
//  EditEventVC.swift
//  MySchollKinect
//
//  Created by Admin on 30/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

import SDWebImage
import TLPhotoPicker
import Photos
import Alamofire
import GooglePlaces
import IQDropDownTextField

class EditEventVC: BaseVC, TLPhotosPickerViewControllerDelegate {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView! 
    
    @IBOutlet weak var eventsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tstDescription: RDTextView!
    @IBOutlet weak var txtSubject: RDTextField!
    @IBOutlet weak var txtDate: RDTextFieldDropDown!
    @IBOutlet weak var txtLocation: RDTextField!
    @IBOutlet weak var btnPost: CornerButton!
    @IBOutlet weak var txtTime: RDTextFieldDropDown!
    @IBOutlet weak var addMedia: UIButton!
    var SelectedPhotosAndVideo = [[String: Any]]()
    var SelectedPhotosInEditEvent:[UIImage] = []
    var selectedVIdeos:[URL] = []
    var selecteAssets:[UIImage] = []
    //    var selectedVIdeos:[URL] = []
    var event_video_id:[Int] = []
    var event_picture_id:[Int] = []
    @IBOutlet weak var collectionviewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCollege: UILabel!
    @IBOutlet weak var lblCharacterCount: UILabel!
    
    var EventToEdit:events?
    
    var selectedDate = Date()
    var time_to_pass = ""
    var isImageSelectFromGallery = false
    //let timePicker = Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?.last as? CustomPicker
    //let DatePicker = Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?.last as? CustomPicker
    var selectedAssets = [TLPHAsset]()
    var stringLatitude = ""
    var stringLongitude = ""
    
    static let APIManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        let delegate = Session.default.delegate
        let manager = Session.init(configuration: configuration, delegate: delegate, startRequestsImmediately: true, cachedResponseHandler: nil)
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addMedia.addTarget(self, action: #selector(self.SelectAddionalPhotos(_:)), for: .touchUpInside)
        
        /*timePicker?.btnCancel.addTarget(self, action: #selector(GraduationCancelPicker(_:)), for: .touchUpInside)
        timePicker?.btnOk.addTarget(self, action: #selector(GraduationDoneSelection(_:)), for: .touchUpInside)
        
        timePicker?.Picker.isHidden = true
        timePicker?.DatePickerView.datePickerMode = .time
        
        DatePicker?.btnCancel.addTarget(self, action: #selector(DOBCancelPicker(_:)), for: .touchUpInside)
        DatePicker?.btnOk.addTarget(self, action: #selector(DOBDoneSelection(_:)), for: .touchUpInside)
        DatePicker?.Picker.isHidden = true
        DatePicker?.DatePickerView.datePickerMode = .date
        
        self.txtDate.inputView = DatePicker
        self.txtTime.inputView = timePicker*/
        
        backView.AddDefaultShadow()
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
        
            self.txtDate.dropDownMode = .datePicker
            self.txtDate.datePicker.minimumDate = Date()
            self.txtDate.delegate = self
            self.txtDate.showDismissToolbar = true
            self.txtDate.dateFormatter = dateFormatter
            
            self.txtTime.dropDownMode = .timePicker
            self.txtTime.delegate = self
            self.txtTime.showDismissToolbar = true
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "HH:mm:ss"
            self.txtTime.dateFormatter = dateFormatter1
        
        btnPost.addTarget(self, action: #selector(self.Post(_:)), for: .touchUpInside)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let text = NSAttributedString.init(string: "Posting to the ", attributes: [NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Regular", size: 16)!,NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        
        var schoolName = ""
        if let strSchoolName : String = UserDefaults.standard.value(forKey: "SchoolName") as? String {
            schoolName = strSchoolName
        }else {
            schoolName = "\(User.shared.schoolusers?.last?.school?.theNameOfYourSchool ?? "")"
        }
        
        let UnivwesityName = NSAttributedString.init(string: "\(schoolName)", attributes: [NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Medium", size: 16)!,NSAttributedString.Key.foregroundColor:UIColor(hexFromString: "#111111")])
        
        let trailingText = NSAttributedString.init(string: " School Events.", attributes: [NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Regular", size: 16)!,NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        
        let Text = NSMutableAttributedString.init()
        Text.append(text)
        Text.append(UnivwesityName)
        Text.append(trailingText)
        
        self.lblCollege.attributedText = Text
        
        self.setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setData() {
        tstDescription.text = EventToEdit?.message
        self.lblCharacterCount.text = "\(self.tstDescription.text.count)/\(Utility.shared.characterLimit)"
         txtSubject.text = EventToEdit?.eventName
         
        let strDate = Utility.shared.DateConvertToString(inputDateformate: "yyyy-MM-dd HH:mm:ss", outputDateformate: "yyyy-MM-dd", strScheduleDate: EventToEdit?.eventTime ?? "")
         let strTime = Utility.shared.DateConvertToString(inputDateformate: "yyyy-MM-dd HH:mm:ss", outputDateformate: "HH:mm a", strScheduleDate: EventToEdit?.eventTime ?? "")
        let datetime = DateFormatter.init()
        datetime.dateFormat = "HH:mm a"
        let finaltime = datetime.date(from: strTime)
         txtDate.selectedItem = strDate
         txtTime.date = finaltime
        
        //let dateFormatter = UIDateFor
        //txtTime.date =
        
         txtLocation.text = EventToEdit?.eventLocation
         
         if isImageSelectFromGallery == false {
             for photo in EventToEdit?.userEventPhotos ?? []  {
                 if let url = URL.init(string: photo.path ?? "") {
                     var dict = [String: Any]()
                     dict["id"] = photo.id
                     dict["path"] = photo.path
                     dict["type"] = "image"
                     dict["image"] = UIImage()
                     dict["isNew"] = false
                     SelectedPhotosAndVideo.append(dict)
                 }
             }
             for video in EventToEdit?.userEventVideos ?? [] {
                 if let url = URL.init(string: video.path ?? "") {
                     var dict = [String: Any]()
                     dict["id"] = video.id
                     dict["path"] = video.path
                     dict["type"] = "video"
                     dict["image"] = UIImage()
                     dict["isNew"] = false
                     SelectedPhotosAndVideo.append(dict)
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
    }
    
    func validateData() -> Bool {
        if self.txtSubject.text?.trim().count ?? 0 == 0 {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter subject",onVc:self)
            return false
        }
        /*if self.txtDate.selectedItem {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter date",onVc:self)
            return false
        }*/
        guard let _ = self.txtDate.date else {
            RDalertcontoller().presentAlertWithMessage(Message:"Please select date",onVc:self)
            return false
        }
        
        if self.txtLocation.text?.trim().count ?? 0 == 0 {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter location",onVc:self)
            return false
        }
        
        guard let _ = self.txtTime.date else {
            RDalertcontoller().presentAlertWithMessage(Message:"Please select time",onVc:self)
            return false
        }
        
        if self.tstDescription.text?.trim().count ?? 0 == 0 {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter description",onVc:self)
            return false
        }
        
        return true
    }
    
    @objc func Post(_ button:UIButton) {
        
        guard validateData() else { return }
        if self.SelectedPhotosAndVideo.count > 0 {
            self.EditEvents()
        } else {
            RDalertcontoller().presentAlertWithMessage(Message:"Please select atleast one photo or video",onVc:self)
        }
        /*if !(txtSubject.text?.isEmpty ?? false) {
            if !(txtDate.text?.isEmpty ?? false) {
                if !(txtLocation.text?.isEmpty ?? false) {
                    if !(tstDescription.text?.isEmpty ?? false) {
                        self.EditEvents()
                    } else {
                        RDalertcontoller().presentAlertWithMessage(Message:"Please enter location",onVc:self)
                    }
                } else {
                    RDalertcontoller().presentAlertWithMessage(Message:"Please enter location",onVc:self)
                }
            } else {
                RDalertcontoller().presentAlertWithMessage(Message:"Please enter date",onVc:self)
            }
        } else {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter subject",onVc:self)
        }*/
    }
    @objc func GraduationCancelPicker(_ button:UIButton) {
        self.view.endEditing(true)
    }
    @objc func GraduationDoneSelection(_ button:UIButton) {
        //self.view.endEditing(true)
        //let date = self.timePicker?.DatePickerView.date
        //let formatter = DateFormatter.init()
        //formatter.dateFormat = "HH:mm:ss"
        //let txttime = formatter.string(from: date ?? Date())
        //self.time_to_pass = txttime
        //self.txtTime.text = date?.ConvertTime()
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
    @objc func DOBCancelPicker(_ button:UIButton) {
        self.view.endEditing(true)
    }
    @objc func DOBDoneSelection(_ button:UIButton) {
        self.view.endEditing(true)
        //let date = self.DatePicker?.DatePickerView.date ?? Date()
        //self.selectedDate = date
        //let formatter = DateFormatter.init()
        //formatter.dateFormat = "yyyy-MM-dd"
        //let txtdate = formatter.string(from: date)
        //self.txtDate.text = txtdate
    }
    func getVideoUrlFromPHAsset(_ asset:PHAsset)->AVURLAsset {
        let semaphore = DispatchSemaphore(value: 0)
        var videoObj:AVURLAsset? = nil
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        PHImageManager().requestAVAsset(forVideo:asset, options: options, resultHandler: { (avurlAsset, audioMix, dict) in
            videoObj = avurlAsset as? AVURLAsset
            semaphore.signal()
        })
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return videoObj!
    }
}
//MARK:- collection view delegate and data
extension EditEventVC:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.SelectedPhotosAndVideo.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostAddcell", for: indexPath) as? PostAddcell
        let dict = self.SelectedPhotosAndVideo[indexPath.row]
        cell?.btndelete.addTarget(self, action: #selector(deletephoto(_:)), for: .touchUpInside)
        if (dict["isNew"] as! Bool) ==  true {
            if dict["type"] as! String == "image" {
                //                cell?.imgCell.sd_setImage(with: URL.init(string: dict["image"] as! UIImage ), placeholderImage: nil, options: SDWebImageOptions.continueInBackground, context: nil)//self.selecteAssets[indexPath.item]
                cell?.imgCell.image = dict["image"] as? UIImage
            } else {
                print("---------------\(dict["path"] as! URL)")
                let image = generateThumbnail(path: (dict["path"] as! URL?)!)
                cell?.imgCell.image = image
            }
        } else {
            if dict["type"] as! String == "image" {
                cell?.imgCell.sd_setImage(with: URL.init(string: dict["path"] as! String ), placeholderImage: #imageLiteral(resourceName: "Morephotos"), options: SDWebImageOptions.continueInBackground)//self.selecteAssets[indexPath.item]
            } else {
                
                cell?.imgCell.image = UIImage(named: "videoPlaceholder")
                
                let url = URL(string: dict["path"] as? String ?? "")
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                    let image = self.generateThumbnail(path: url!)
                    DispatchQueue.main.async {
                        cell?.imgCell.image = image
                    }
                }
                
                /*let image = generateThumbnail(path: URL(string: dict["path"] as! String)!)
                cell?.imgCell.image = image*/
            }
        }
        cell?.imgCell.layer.cornerRadius = 6
        cell?.imgCell.layer.masksToBounds = true
        cell?.imgCell.contentMode = .scaleAspectFill
        cell?.btndelete.tag = indexPath.item
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
                //                self.SelectedPhotos.remove(at: tag)
                self.event_picture_id.append(dict["id"] as! Int)
            } else {
                event_video_id.append(dict["id"] as! Int)
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
//MARK:- webservice
extension EditEventVC {
    func EditEvents() {
        for each in self.SelectedPhotosAndVideo {
            if (each["isNew"] as! Bool) ==  true {
                if each["type"] as! String == "image" {
//                    let str = imageToBase64((each["image"] as? UIImage)!)
                    self.SelectedPhotosInEditEvent.append((each["image"] as? UIImage)!)//((each["image"] as? UIImage)!)
                } else {
                    self.selectedVIdeos.append(each["path"] as! URL)
                }
            }
        }
        let serviceManager = ServiceManager<AddEvent>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "event-edit/\(self.EventToEdit?.id ?? 0)"

        if self.SelectedPhotosInEditEvent.count > 0 {
            serviceManager.AttachmentParameter = "event_picture[]"
            serviceManager.Attachments = self.SelectedPhotosInEditEvent
        }
        if (self.selectedVIdeos.count ) > 0 {
            serviceManager.VideoAttachmentParameter = "event_video[]"
            serviceManager.VideoAttachments = self.selectedVIdeos
        }
        
        /*let arrImages : [[String: Any]] = self.SelectedPhotosAndVideo.filter({$0["type"] as! String == "image" })
        serviceManager.AttachmentParameter = "event_picture[]"
        serviceManager.Attachments = arrImages.compactMap({$0["image"] as? UIImage})
        
        serviceManager.VideoAttachmentParameter = "event_video[]"
        serviceManager.VideoAttachments = self.SelectedPhotosAndVideo.compactMap({$0["path"] as? URL})*/
//
        let event_video = event_video_id.map(String.init).joined(separator: ",")//event_video_id.map {"\($0)"}.reduce(",") {$0 + $1 }//event_video_id.joined(separator: ",")
        let event_picture = event_picture_id.map(String.init).joined(separator: ",")//event_picture_id.map {"\($0)"}.reduce(",") {$0 + $1 }//event_picture_id.joined(separator: ",")
        
        serviceManager.Parameters = [
            "event_name": txtSubject.text ?? "",
            "event_time": (self.txtDate.selectedItem ?? "") + " " + time_to_pass,
            "event_location":txtLocation.text ?? "",
            "latitude":"",
            "longitude":"",
            "message":self.tstDescription.text ?? "",
            "event_video_id":event_video,
            "event_picture_id":event_picture
        ]
        
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let Post = Response as? ResponseModel<AddEvent>
            self.navigationController?.popViewController(animated: true)
            RDalertcontoller().presentAlertWithMessage(Message:Post?.errorMsg ?? "",onVc:self)
        }
        
//        serviceManager.Parameters = [
//            "event_name": txtSubject.text ?? "",
//            "event_time": (self.txtDate.text ?? "") + " " + self.time_to_pass,
//            "event_location":txtLocation.text ?? "",
//            "latitude":"",
//            "longitude":"",
//            "message":self.tstDescription.text ?? "",
//            "event_video_id":event_video,
//            "event_picture_id":event_picture
//        ]
//        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
//            let Post = Response as? ResponseModel<events>
//            RDalertcontoller().presentAlertWithMessage(Message:Post?.errorMsg ?? "",onVc:self)
//            self.navigationController?.popViewController(animated: true)
//        }
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        
        /*var parameters = [String: Any]()
        parameters["event_name"] = txtSubject.text ?? ""
        parameters["event_time"] =  (self.txtDate.text ?? "") + " " + self.time_to_pass
        parameters["event_location"] = txtLocation.text ?? ""
        parameters["latitude"] = Double(stringLatitude)
        parameters["longitude"] = Double(stringLongitude)
        parameters["message"]  = self.tstDescription.text ?? ""
        parameters["event_video_id"] = event_video
        parameters["event_picture_id"] = event_picture
        print("Authorization parameters-----\(parameters)")
        let token = UserDefaults.standard.object(forKey: "logintoken")  as? String
        print("Authorization token-----\(token ?? "")")
        let authToken = (token == nil || token == "") ? "" : token ?? ""
        let headers: HTTPHeaders =  ["Authorization":"Bearer \(authToken)","Accept":"application/json"]
        AF.upload(multipartFormData: { multipartFormData in

                for (key,value) in parameters {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }

            for i in 0..<self.SelectedPhotosInEditEvent.count {
                let data1 = self.SelectedPhotosInEditEvent[i].jpegData(compressionQuality: 0.7)//(compressionQuality: 0.7) // UIImageJPEGRepresentation(listOfImage[j],0.4)
//                let str = data1?.base64EncodedString()
//                let strBase64 = "data:image/png;base64,\(str ?? "")"
//                debugPrint(strBase64)
//                let data111 = Data(strBase64.utf8)
                multipartFormData.append(data1!, withName: "event_picture[\(i)]", fileName: "\(Calendar.current).png", mimeType: "image/png")
            }
            _ = arc4random()
            for i in 0..<self.selectedVIdeos.count {
                  let randome = arc4random()
                let str1 = (self.selectedVIdeos[i] as URL).lastPathComponent
                let fileArray = str1.components(separatedBy: ".")
                let finalFileName = fileArray.last
                multipartFormData.append(self.selectedVIdeos[i], withName: "event_video[\(i)]" , fileName: "randome\(randome).\(finalFileName ?? "mp4")", mimeType: "video/\(finalFileName ?? "mp4")")
            }
        }, to: serviceManager.Url + serviceManager.ClientVersion + "event/\(self.EventToEdit?.id ?? 0)",method: .put, headers: headers)
            .responseJSON { response in
                debugPrint(response)
                self.navigationController?.popViewController(animated: true)
                RDalertcontoller().presentAlertWithMessage(Message: "Event updated successfully",onVc:self)
                
                
        }*/
    }
    func base64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    }
    func imageToBase64(_ image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}
extension EditEventVC {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets
        isImageSelectFromGallery = true
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
            let alert = UIAlertController(title: "", message: "Denied albums permissions granted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        let alert = UIAlertController(title: "", message: "Denied camera permissions granted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        picker.present(alert, animated: true, completion: nil)
    }
    func showExceededMaximumAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "", message: "Exceed Maximum Number Of Selection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    func showUnsatisifiedSizeAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "Oups!", message: "The required size is: 300 x 300", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
extension EditEventVC: TLPhotosPickerLogDelegate {
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
extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}
extension EditEventVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        /*let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)*/
        if textField == txtLocation {
            let searchVenueVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchVenuesVC") as! SearchVenuesVC
            searchVenueVC.delegate = self
            self.present(searchVenueVC, animated: true) {
                self.view.endEditing(true)
            }
        }
    }
    
    
}

extension EditEventVC : UITextViewDelegate {
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

// MARK: - Search Venue delegate extension -
extension EditEventVC : SearchVenueDelegate {
    func selectedVenue(obj:[String:String]?) {
        if let ob = obj {
            print("--- obj -- \(ob)")
            
            txtLocation.text = ob["address"]
            //txtLocation.textColor = .black
            
            self.stringLatitude = "\(ob["lat"] ?? "0.0")"
            self.stringLongitude = "\(ob["lng"] ?? "0.0")"
        }
        
        self.dismiss(animated: true) {
            
        }
    }
}

// MARK: - GMSAutocompleteViewControllerDelegate -
extension EditEventVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place Details :- \(place.coordinate)")
        print("Place name: \(place.name ?? "")")
        print("Place address: \(place.formattedAddress ?? "")")
        //       print("Place attributions: \(String(describing: place.attributions))")
        txtLocation.text = place.formattedAddress!
        txtLocation.textColor = .black
//        txtStreet.text = "\(place.name ?? "")"
        for component in place.addressComponents! {
            for type in component.types {
                print("-------\(type)")
                switch(type){
                case "country":
                    let country = component.name
                    
                    print("country name ----\(country)")
                case "locality" :
                    let city = component.name
                    print("city name ----\(city)")
//                    self.txtCity.text = city
                case "administrative_area_level_1":
                    
                    let state = component.name
                    print("state name ----\(state)")
//                    self.txtState.text = state
                    
                case "postal_code":
                    let postCode = component.name
                    print("postCode ----\(postCode)")
//                    self.txtZipCode.text = postCode
                default:
                    break
                }
                
            }
        }
        //        stringAddress = textViewAddress.text
        stringLatitude = "\(place.coordinate.latitude)"
        stringLongitude = "\(place.coordinate.longitude)"
        
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
// MARK: - UIImagePickercontroller -
extension EditEventVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
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
extension EditEventVC : IQDropDownTextFieldDelegate {
    func textField(_ textField: IQDropDownTextField, didSelect date: Date?) {
        let dateFormattter = DateFormatter()
        dateFormattter.dateFormat = "yyyy-MM-dd"
        if textField == self.txtDate {
            dateFormattter.dateFormat = "yyyy-MM-dd"
        }
        
        if textField == self.txtTime {
            dateFormattter.dateFormat = "HH:mm:ss"
            time_to_pass = dateFormattter.string(from: date ?? Date())
        }
    }
}
