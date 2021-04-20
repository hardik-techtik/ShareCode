//
//  AddEventsVC.swift
//  MySchollKinect
//
//  Created by Admin on 28/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import TLPhotoPicker
import GooglePlaces
import Photos
import IQKeyboardManagerSwift
import IQDropDownTextField

class AddEventsVC: BaseVC, TLPhotosPickerViewControllerDelegate {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var lblCollege: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var eventsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblCharacterCount: UILabel!
    
    @IBOutlet weak var tstDescription: RDTextView!
    @IBOutlet weak var txtSubject: RDTextField!
    @IBOutlet weak var txtDate: RDTextFieldDropDown!
    @IBOutlet weak var txtLocation: RDTextField!
    @IBOutlet weak var btnPost: CornerButton!
    @IBOutlet weak var txtTime: RDTextFieldDropDown!
    @IBOutlet weak var addMedia: UIButton!
    var SelectedPhotos:[UIImage] = []
    var selectedVIdeos:[URL] = []
    var selecteAssets:[UIImage] = []
    var stringLatitude = ""
    var stringLongitude = ""
    @IBOutlet weak var collectionviewHeight: NSLayoutConstraint!
    
    var SelectedPhotosAndVideo = [[String: Any]]()
    var selectedDate = Date()
    var time_to_pass = ""
    
    //let timePicker = Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?.last as? CustomPicker
    //let DatePicker = Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?.last as? CustomPicker
    
    
    var selectedAssets = [TLPHAsset]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.addMedia.addTarget(self, action: #selector(self.SelectAddionalPhotos(_:)), for: .touchUpInside)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionviewHeight.constant = 0
        
        //timePicker?.btnCancel.addTarget(self, action: #selector(GraduationCancelPicker(_:)), for: .touchUpInside)
        
        //timePicker?.btnOk.addTarget(self, action: #selector(GraduationDoneSelection(_:)), for: .touchUpInside)
        
        //timePicker?.Picker.isHidden = true
        //timePicker?.DatePickerView.datePickerMode = .time
        
        //DatePicker?.btnCancel.addTarget(self, action: #selector(DOBCancelPicker(_:)), for: .touchUpInside)
        //DatePicker?.btnOk.addTarget(self, action: #selector(DOBDoneSelection(_:)), for: .touchUpInside)
        //DatePicker?.Picker.isHidden = true
        //DatePicker?.DatePickerView.datePickerMode = .date
        //DatePicker?.DatePickerView.minimumDate = Date.init()
        
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
        
        //self.txtDate.inputView = DatePicker
        //self.txtTime.inputView = timePicker
        
        btnPost.addTarget(self, action: #selector(self.Post(_:)), for: .touchUpInside)
        
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
        //txtDate.delegate = self
        //txtTime.delegate = self
        
        //tstDescription.text = "Message:"
        //tstDescription.textColor = .lightGray
        //tstDescription.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backView.AddDefaultShadow()
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
    @IBAction func buttonClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonClickUserAgreement(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsOfUseVC") as? TermsOfUseVC else { return }
        
        self.navigationController?.show(vc, sender: nil)
    }
    @objc func Post(_ button:UIButton) {
        guard validateData() else { return }
        if self.SelectedPhotosAndVideo.count > 0 {
            self.AddEvents()
        } else {
            RDalertcontoller().presentAlertWithMessage(Message:"Please select atleast one photo or video",onVc:self)
        }
    }
    @objc func GraduationCancelPicker(_ button:UIButton) {
        self.view.endEditing(true)
    }
    @objc func GraduationDoneSelection(_ button:UIButton) {
        /*self.view.endEditing(true)
        let date = self.timePicker?.DatePickerView.date
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "HH:mm:ss"
        
        let txttime = formatter.string(from: date ?? Date())
        self.time_to_pass = txttime
        
        self.txtTime.text = date?.ConvertTime()*/
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
        /*self.view.endEditing(true)
        let date = self.DatePicker?.DatePickerView.date ?? Date()
        self.selectedDate = date
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let txtdate = formatter.string(from: date)
        self.txtDate.text = txtdate*/
    }
}

//MARK:- collection view delegate and data
extension AddEventsVC:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.selecteAssets.count
        return self.SelectedPhotosAndVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostAddcell", for: indexPath) as? PostAddcell
        cell?.btndelete.addTarget(self, action: #selector(deletephoto(_:)), for: .touchUpInside)
        let dict = self.SelectedPhotosAndVideo[indexPath.row]
        if (dict["isNew"] as! Bool) ==  true {
            if dict["type"] as! String == "image" {
                //                cell?.imgCell.sd_setImage(with: URL.init(string: dict["image"] as! UIImage ), placeholderImage: nil, options: SDWebImageOptions.continueInBackground, context: nil)//self.selecteAssets[indexPath.item]
                cell?.imgCell.image = dict["image"] as? UIImage
            } else {
                print("---------------\(dict["path"] as! URL)")
                let image = generateThumbnail(path: (dict["path"] as! URL?)!)
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
//MARK:- webservice
extension AddEventsVC {
    func AddEvents() {
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
        serviceManager.ServiceName = "event"
        
        let arrImages : [[String: Any]] = self.SelectedPhotosAndVideo.filter({$0["type"] as! String == "image" })
        serviceManager.AttachmentParameter = "event_picture[]"
        serviceManager.Attachments = arrImages.compactMap({$0["image"] as? UIImage})
        
        serviceManager.VideoAttachmentParameter = "event_video[]"
        serviceManager.VideoAttachments = self.SelectedPhotosAndVideo.compactMap({$0["path"] as? URL})
        
        serviceManager.Parameters = [
            "event_name": txtSubject.text ?? "",
            "event_time": (self.txtDate.selectedItem ?? "") + " " + time_to_pass,
            "school_id":User.shared.schoolID ?? "",
            "event_location":self.txtLocation.text ?? "",
            "message":self.tstDescription.text ?? "",
            "latitude": Double(stringLatitude) ?? 0.0,
            "longitude": Double(stringLongitude) ?? 0.0
        ]
        
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            _ = Response as? ResponseModel<AddEvent>
            //RDalertcontoller().presentAlertWithMessage(Message:"Event add sucessfully",onVc:self)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Search Venue delegate extension -
extension AddEventsVC : SearchVenueDelegate {
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

extension AddEventsVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtDate {
            //IQKeyboardManager.shared.enable = false
            //IQKeyboardManager.shared.enableAutoToolbar = false
        } else if textField == txtTime {
            //IQKeyboardManager.shared.enable = false
            //IQKeyboardManager.shared.enableAutoToolbar = false
        } else if textField == txtLocation {
            /*let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)*/
            /*let searchVenueVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchVenuesVC") as!  SearchVenuesVC
            searchVenueVC.delegate = self
            self.present(searchVenueVC, animated: true) {
                self.view.endEditing(true)
            }*/
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //IQKeyboardManager.shared.enable = true
        //IQKeyboardManager.shared.enableAutoToolbar = true
    }
}



// MARK: - GMSAutocompleteViewControllerDelegate -
extension AddEventsVC: GMSAutocompleteViewControllerDelegate {
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
extension AddEventsVC {
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
/*extension AddEventsVC: TLPhotosPickerLogDelegate {
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

extension AddEventsVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
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
extension AddEventsVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView == tstDescription {
//            if (textView.text == "Message:" && textView.textColor == .lightGray) {
//                textView.text = ""
//                textView.textColor = .black
//            }
//        }
//        textView.becomeFirstResponder() //Optional
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
//        if textView == tstDescription {
//            if textView.text.isEmpty {
//                tstDescription.text = "Message:"
//                tstDescription.textColor = .lightGray
//            }
//        }
    }
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

extension AddEventsVC : IQDropDownTextFieldDelegate {
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

