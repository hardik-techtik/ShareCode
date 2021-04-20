//
//  EditProfileVC.swift
//  MySchollKinect
//
//  Created by Admin on 30/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SDWebImage
import BSImagePicker
import Photos
import IQKeyboardManagerSwift
import TLPhotoPicker
import IQDropDownTextField

protocol profieDelegate:class {
    func profileDidEdit()
}

extension UIImage
{
    static let placeholder = UIImage.init(named: "Profile")
    static let placeholder2 = UIImage.init(named: "Morephotos")
}

class EditProfileVC: BaseVC {
    private var rootView:UINavigationController?
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var CollectioView: UICollectionView!
    //@IBOutlet weak var lblNOAdditionalDataFound: UILabel!
    @IBOutlet weak var txtfirstname: UITextField!
    @IBOutlet weak var txtlastNam: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtrelationhipstatus: IQDropDownTextField!
    @IBOutlet weak var txtschoolMajor: UITextField!
    @IBOutlet weak var txtSchoolMinor: UITextField!
    @IBOutlet weak var txtSchoolClassification: IQDropDownTextField!
    @IBOutlet weak var txtFirstname: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    
    @IBOutlet weak var txtGraduationDate: IQDropDownTextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtAboutME: IQTextView!
    @IBOutlet weak var txtInterests: IQTextView!
    @IBOutlet weak var conCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imgEdit: UIImageView!
    
    @IBOutlet weak var btnSave: CornerButton! 
    var user:UserProfile?
    
    @IBOutlet weak var btnAddtionaPhotos: UIButton!
    weak var delegate:profieDelegate?
    var AdditionalPhotos:[UIImage]?
    
    let Group = DispatchGroup.init()
    //let Gender = ["Male","Female"]
    //let RelationShip = ["single","married"]
    
    //let DOBPicker = Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?.last as? CustomPicker
    //let GenderPicker = Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?.last as? CustomPicker
    //let RelatiopSheepPicker = Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?.last as? CustomPicker
    //let ExpectedGraduationDate = Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?.last as? CustomPicker
    
    //let AgePicker = Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?.last as? CustomPicker
    
    var selectedImage:UIImage?
    
    var AddtoMorePhotos = false
    
    var DeletedIDs:[String] = []
    
    var Age:[String] = []
    
    var selectedAssets = [TLPHAsset]()
    
    var SelectedPhotosAndVideo = [[String: Any]]()
    var isImageSelectFromGallery = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.setUpData()
        
        //self.txtSchoolClassification.selectedItem = self.user?.schoolClassigication
        
        /*GenderPicker?.btnCancel.addTarget(self, action: #selector(GenderCancelPicker(_:)), for: .touchUpInside)
        GenderPicker?.DataSource = self.Gender
        GenderPicker?.btnOk.addTarget(self, action: #selector(GenderDoneSelection(_:)), for: .touchUpInside)
        GenderPicker?.DatePickerView.isHidden = true
        
        RelatiopSheepPicker?.DataSource = self.RelationShip
        RelatiopSheepPicker?.btnCancel.addTarget(self, action: #selector(RelationCancelPicker(_:)), for: .touchUpInside)
        RelatiopSheepPicker?.btnOk.addTarget(self, action: #selector(RelationDoneSelection(_:)), for: .touchUpInside)
        RelatiopSheepPicker?.DatePickerView.isHidden = true
        
        txtrelationhipstatus.inputView = RelatiopSheepPicker
        txtrelationhipstatus.delegate = self
         
        DOBPicker?.btnCancel.addTarget(self, action: #selector(DOBCancelPicker(_:)), for: .touchUpInside)
        DOBPicker?.btnOk.addTarget(self, action: #selector(DOBDoneSelection(_:)), for: .touchUpInside)
        DOBPicker?.Picker.isHidden = true
        
        
        for i in 20...100
        {
            self.Age.append("\(i)")
        }
        
        
        AgePicker?.btnCancel.addTarget(self, action: #selector(AgeCancelPicker(_:)), for: .touchUpInside)
        AgePicker?.btnOk.addTarget(self, action: #selector(AgeDoneSelection(_:)), for: .touchUpInside)
        AgePicker?.Picker.isHidden = true
        AgePicker?.DataSource = self.Age
        txtAge.delegate = self
        txtAge.inputView = AgePicker
        
        
        ExpectedGraduationDate?.btnCancel.addTarget(self, action: #selector(GraduationCancelPicker(_:)), for: .touchUpInside)
        ExpectedGraduationDate?.btnOk.addTarget(self, action: #selector(GraduationDoneSelection(_:)), for: .touchUpInside)
        ExpectedGraduationDate?.Picker.isHidden = true
        
        txtGraduationDate.delegate = self
        txtGraduationDate.inputView = self.ExpectedGraduationDate
        
        
        /*imgEdit.layer.cornerRadius = self.imgProfile.frame.height/2
        imgEdit.layer.masksToBounds = true
        imgEdit.clipsToBounds = true*/
        
        btnAddtionaPhotos.addTarget(self, action: #selector(SelectaddionalPhotos(_:)), for: .touchUpInside)
        imgProfile.addShadowToImage()
        // Do any additional setup after loading the view.
        AgePicker?.DatePickerView.isHidden = false
        AgePicker?.Picker.isHidden = true*/

    }
    
    func setUpData() {
        self.txtfirstname.text = self.user?.firstName
        self.txtlastNam.text = self.user?.lastName
        
        self.txtAge.text = "\(self.user?.age ?? "") Years"
        self.txtAge.isEnabled = false
        
        self.txtschoolMajor.text = self.user?.schoolMajor
        self.txtSchoolMinor.text = self.user?.schoolMinor
        
        self.txtAboutME.text = self.user?.aboutYourself
        self.txtInterests.text = self.user?.interest
        
        self.imgProfile.sd_setImage(with: URL.init(string: self.user?.profilePic ?? ""), placeholderImage: UIImage.placeholder, options: .continueInBackground)
        self.imgProfile.accessibilityHint = self.user?.profilePic
        
        self.txtrelationhipstatus.selectedItem = self.user?.relationshipStatus ?? ""
        
        self.txtSchoolClassification.selectedItem = self.user?.schoolClassigication ?? ""
        
        //self.txtGraduationDate.date = String().ConvertTostingDate(stringDate: self.user?.expectedGradutionDate ?? "")
        print("\(String().ConvertToDate(stringDate: self.user?.expectedGradutionDate ?? "") ?? "")")
        self.txtGraduationDate.selectedItem = "\(String().ConvertToDate(stringDate: self.user?.expectedGradutionDate ?? "") ?? "")"
        

        var dic = [String:Any]()
        for image in self.user?.photos ?? []
        {
            dic["id"] = 0
            dic["path"] = image.uploadImagePath ?? ""
            dic["type"] = "image"
            dic["image"] = ""
            dic["isNew"] = false
            self.SelectedPhotosAndVideo.append(dic)
        }
        
        if self.SelectedPhotosAndVideo.count > 0 {
            self.conCollectionViewHeight.constant = 140
        } else {
            self.conCollectionViewHeight.constant = 0
        }
        
        DispatchQueue.main.async {
            self.CollectioView.reloadData()
        }
        
    }
    
    func setUpUI() {
        
        self.txtAboutME.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        self.txtInterests.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.height/2
        self.imgProfile.layer.masksToBounds = true
        
        imgProfile.addShadowToImage()
        
        self.CollectioView.delegate = self
        self.CollectioView.dataSource = self

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        self.txtGraduationDate.dropDownMode = .datePicker
        self.txtGraduationDate.dateFormatter = dateFormatter
        
        //self.txtGender.itemList = Utility.shared.Gender
        self.txtrelationhipstatus.itemList = Utility.shared.RelationShip
        self.txtSchoolClassification.itemList = Utility.shared.schoolClassification
        
        btnSave.addTarget(self, action: #selector(SaveProfile(_:)), for: .touchUpInside)
        
        btnAddtionaPhotos.addTarget(self, action: #selector(SelectaddionalPhotos(_:)), for: .touchUpInside)
        
        imgProfile.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.ChoosePhotoForProfile(_:))))
        imgProfile.isUserInteractionEnabled = true
    }
    
    func showExceededMaximumAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "", message: "Exceed Maximum Number Of Selection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    @objc func AgeCancelPicker(_ button:UIButton)
    {
         self.view.endEditing(true)
    }
    
    /*@objc func AgeDoneSelection(_ button:UIButton) {
        let index = self.AgePicker?.Picker.selectedRow(inComponent: 0) ?? 0
        let value = self.Age[index]
        self.txtAge.text = "\(value) Years"
        self.view.endEditing(true)
    }*/
    @objc func SelectaddionalPhotos(_ button:UIButton) {
        /*let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showExceededMaximumAlert(vc: picker)
        }
        viewController.customDataSouces = CustomDataSources()
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.maxVideoDuration = 20
        configure.maxSelectedAssets = 6 - self.selectedAssets.count
        configure.groupByFetch = .day
        viewController.configure = configure
        viewController.logDelegate = self
        self.present(viewController, animated: true, completion: nil)*/
        
        let alert = UIAlertController.init(title: "Choose From", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let Camera = UIAlertAction.init(title: "Camera", style: .default) { (Action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                let picker = UIImagePickerController.init()
                picker.sourceType = .camera
                //picker.mediaTypes = ["public.image", "public.movie"]
                picker.mediaTypes = ["public.image"]
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
            //picker.mediaTypes = ["public.image", "public.movie"]
            picker.mediaTypes = ["public.image"]
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
    
    func validateProfile() -> Bool {
        
        if self.txtfirstname.text?.trim().count ?? 0 == 0 {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter first name",onVc:self)
            return false
        }
        if self.txtlastNam.text?.trim().count ?? 0 == 0 {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter last name",onVc:self)
            return false
        }
        guard let _ = self.txtGraduationDate.date else {
            RDalertcontoller().presentAlertWithMessage(Message:"Please select expected graduation date",onVc:self)
            return false
        }
        /*if (self.txtEmail.text?.isValidEmail() ?? false) {
         RDalertcontoller().presentAlertWithMessage(Message:"Please enter valid email address",onVc:self)
         return false
         }*/
        
        return true
        
    }

    @objc func SaveProfile(_ button:UIButton) {
        if self.validateProfile() {
            self.UpdateProfile()
        }
    }
    @objc func GenderCancelPicker(_ button:UIButton) {
        self.view.endEditing(true)
    }
    @objc func GenderDoneSelection(_ button:UIButton) {
        self.view.endEditing(true)
    }
    @objc func RelationCancelPicker(_ button:UIButton) {
        self.view.endEditing(true)
    }
    
    @IBAction func actioEditPic(sender:UIButton) {
        self.ChoosePhotoForProfile(sender)
    }
    
    @objc func ChoosePhotoForProfile(_ button:UIButton) {
        let alert = UIAlertController.init(title: "Choose From", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let Camera = UIAlertAction.init(title: "Camera", style: .default) { (Action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                let picker = UIImagePickerController.init()
                picker.sourceType = .camera
                picker.mediaTypes = ["public.image"]
                picker.accessibilityHint = "ProfilePhoto"
                picker.allowsEditing = true
                picker.delegate = self
                picker.showsCameraControls = true
                self.present(picker, animated: true, completion: nil)
            }
        }
        let Gallery = UIAlertAction.init(title: "Gallery", style: .default) {[unowned self] (Action) in
            /*self.AddtoMorePhotos = false
            let Picker = ImagePickerController.init()
            Picker.settings.selection.max = 6 - (self.AdditionalPhotos?.count ?? 0)
            self.presentImagePicker(Picker, select: { (assets) in
                
            }, deselect: { (Assets) in
                
            }, cancel: { (Assets) in
                self.dismiss(animated: true, completion: nil)
            }, finish: { (Aseets) in
                self.AdditionalPhotos = []
                Aseets.forEach { (assets) in
                    PHImageManager.default().requestImage(for: assets, targetSize: CGSize.zero, contentMode: .default, options: nil) { (Image, info) in
                        if let image = Image {
                            self.imgProfile.image = image
                            self.selectedImage = image
                        }
                    }
                }
                self.CollectioView.reloadData()
            })*/
            
            let picker = UIImagePickerController.init()
            picker.sourceType = .photoLibrary
            picker.mediaTypes = ["public.image"]
            picker.allowsEditing = true
            picker.accessibilityHint = "ProfilePhoto"
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
        let Cancel = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(Camera)
        alert.addAction(Gallery)
        alert.addAction(Cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    /*@objc func RelationDoneSelection(_ button:UIButton) {
        self.view.endEditing(true)
        let picker = self.RelationShip[self.RelatiopSheepPicker?.Picker.selectedRow(inComponent: 0) ?? 0]
        self.txtrelationhipstatus.text = picker
    }*/
    
    @objc func DOBCancelPicker(_ button:UIButton) {
        self.view.endEditing(true)
    }
    @objc func DOBDoneSelection(_ button:UIButton) { }
    
    @objc func GraduationCancelPicker(_ button:UIButton) {
        self.view.endEditing(true)
    }
    
    /*@objc func GraduationDoneSelection(_ button:UIButton) {
        self.view.endEditing(true)
        let date = self.ExpectedGraduationDate?.DatePickerView.date
        self.txtGraduationDate.text = date?.ConvertDate()
    }*/
}
/*extension EditProfileVC:TLPhotosPickerViewControllerDelegate,TLPhotosPickerLogDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func selectedCameraCell(picker: TLPhotosPickerViewController) { }
    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) { }
    func selectedPhoto(picker: TLPhotosPickerViewController, at: Int) { }
    func selectedAlbum(picker: TLPhotosPickerViewController, title: String, at: Int) { }
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
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
        if self.SelectedPhotosAndVideo.count > 0 {
             lblNOAdditionalDataFound.isHidden = true
             CollectioView.isHidden = false
         } else {
             lblNOAdditionalDataFound.isHidden = false
             CollectioView.isHidden = true
         }
        
        DispatchQueue.main.async {
            self.CollectioView.reloadData()
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
    func showUnsatisifiedSizeAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "Oups!", message: "The required size is: 300 x 300", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}*/
extension EditProfileVC:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtrelationhipstatus || textField == txtGraduationDate || textField == txtAge {
            IQKeyboardManager.shared.enable = false
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtrelationhipstatus || textField == txtGraduationDate || textField == txtAge {
            IQKeyboardManager.shared.enable = true
            IQKeyboardManager.shared.enableAutoToolbar = true
        }
    }
}
extension EditProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.SelectedPhotosAndVideo.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdditionalPhotos", for: indexPath) as? AdditionalPhotos
        let dict = self.SelectedPhotosAndVideo[indexPath.row]
        
        cell?.btnDelete.addTarget(self, action: #selector(deletephoto(_:)), for: .touchUpInside)
        
        if (dict["isNew"] as? Bool) ==  true {
            if dict["type"] as! String == "image" {
                cell?.photo.image = dict["image"] as? UIImage
            } else {
                print("---------------\(dict["path"] as! URL)")
                let image = generateThumbnail(path: (dict["path"] as! URL?)!)
                cell?.photo.image = image
            }
        } else {
            if dict["type"] as! String == "image" {
                cell?.photo.sd_setImage(with: URL.init(string: dict["path"] as! String ), placeholderImage: nil, options: SDWebImageOptions.continueInBackground)//self.selecteAssets[indexPath.item]
            } else {
                let image = generateThumbnail(path: URL(string: dict["path"] as! String)!)
                cell?.photo.image = image
            }
        }
        cell?.photo.layer.cornerRadius = 6
        cell?.photo.layer.masksToBounds = true
        cell?.photo.contentMode = .scaleAspectFill
        cell?.btnDelete.tag = indexPath.item
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
                self.DeletedIDs.append("\(self.user?.photos?[tag].id ?? 0)")
            } else {
                self.SelectedPhotosAndVideo.remove(at: tag)
            }
        }
        if self.SelectedPhotosAndVideo.count > 0 {
            self.conCollectionViewHeight.constant = 140
        } else {
            self.conCollectionViewHeight.constant = 0
        }
        DispatchQueue.main.async {
            self.CollectioView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize.init(width: (collectionView.bounds.width/3 - 6), height: (collectionView.bounds.height/2 - 10))
    }
    @objc func Deleteimage(_ button:UIButton) {
        let index = button.tag
        self.DeletedIDs.append("\(self.user?.photos?[index].id ?? 0)")
        self.user?.photos?.remove(at: index)
        if self.SelectedPhotosAndVideo.count > 0 {
            self.conCollectionViewHeight.constant = 140
        } else {
            self.conCollectionViewHeight.constant = 0
        }
        DispatchQueue.main.async {
            self.CollectioView.reloadData()
        }
        //self.CollectioView.reloadData()
    }
}
//MARK"- webservices
extension EditProfileVC {
    func UpdateProfile() {
        let serviceManager = ServiceManager<UpdateUserProfile>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "update-profile"
        if self.imgProfile.accessibilityHint == "changed" {
            if let image = self.imgProfile.image {
                serviceManager.AttachmentParameter = "profile_pic"
                serviceManager.Attachments = [image]
            }
        }
        
        serviceManager.Parameters = [
            "date_of_birth":User.shared.dateOfBirth ?? "",
            "relationship_status":txtrelationhipstatus.selectedItem ?? "",
            "school_major":txtschoolMajor.text ?? "",
            "school_minor":txtSchoolMinor.text ?? "",
            "expected_gradution_date":txtGraduationDate.date?.convertDate() ?? "",
            "school_university":User.shared.schoolUniversity ?? "",
            "school_classigication":txtSchoolClassification.selectedItem ?? "",
            "interest":self.txtInterests.text ?? "",
            "age":self.txtAge.text?.replacingOccurrences(of: " Years", with: "") ?? "",
            "gender": User.shared.gender ?? "",
            "first_name": txtfirstname.text ?? "",
            "last_name": txtlastNam.text ?? "",
            "about_yourself": txtAboutME.text ?? "",
            "latitude":21.102,
            "longitude":22.1234123
        ]
            serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
                _ = Response as? ResponseModel<UpdateUserProfile>
    //
    //            self.delegate?.profileDidEdit()
                self.navigationController?.popViewController(animated: true)
                
                RDalertcontoller().presentAlertWithMessage(Message:"Profile updated successfully",onVc:self)
                
                self.getAdditionalimage()
                for id in self.DeletedIDs {
                    self.DeleteAdditionalPhotos(ID: id)
                }
                if (self.SelectedPhotosAndVideo.count) <= 0 {
                    self.delegate?.profileDidEdit()
                } else {
                    for image in self.SelectedPhotosAndVideo {
                        
                        if let img = image["image"] as? UIImage
                        {
                            self.UploadAdditionalPhotos(image:img)
                        }
                    }
                }
            }
    }
    
    func UploadAdditionalPhotos(image:UIImage) {
        let serviceManager = ServiceManager<uploads>.init()
        serviceManager.ServiceName = "img-upload"
        serviceManager.HandleResponse = true
        serviceManager.Attachments = [image]
        serviceManager.AttachmentParameter = "path"
        serviceManager.ShowProgess()
        self.Group.enter()
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let Uploads = Response as? ResponseModelDic<uploads>
            print(Uploads!)
            self.Group.leave()
        }
        self.Group.notify(queue: DispatchQueue.main) {
            serviceManager.DismissProgress()
            self.delegate?.profileDidEdit()
        }
    }
    func DeleteAdditionalPhotos(ID:String) {
        let serviceManager = ServiceManager<uploads>.init()
        serviceManager.ServiceName = "img-delete/\(ID)"
        serviceManager.HandleResponse = false
        serviceManager.ShowProgess()
        serviceManager.MakeServiceCall(httpMethod: .delete) { (Response) in
            _ = Response as? ResponseModelDic<uploads>
            print("--------\(Response)")
            print("------------")
        }
    }
    
    func getAdditionalimage() {
        let serviceManager = ServiceManager<uploads>.init()
        serviceManager.ServiceName = "all-image"
        serviceManager.HandleResponse = false
        serviceManager.ShowProgess()
        serviceManager.MakeServiceCall(httpMethod: .delete) { (Response) in
            let upload = Response as? ResponseModelDic<uploads>
            if let images = upload?.Data {
                self.user?.photos?.append(images)
            }
            
            if self.SelectedPhotosAndVideo.count > 0 {
                self.conCollectionViewHeight.constant = 140
            } else {
                self.conCollectionViewHeight.constant = 0
            }
            DispatchQueue.main.async {
                self.CollectioView.reloadData()
            }
        }
    }
}
extension EditProfileVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let editedImg = info[UIImagePickerController.InfoKey.editedImage] {
            print(editedImg)
            if picker.accessibilityHint == "ProfilePhoto" {
                self.imgProfile.image = editedImg as? UIImage
                self.imgProfile.accessibilityHint = "changed"
            }else {
                var dict = [String: Any]()
                dict["id"] = 0
                dict["path"] = ""
                dict["type"] = "image"
                dict["image"] = editedImg as? UIImage
                dict["isNew"] = true
                self.SelectedPhotosAndVideo.append(dict)
                
                self.conCollectionViewHeight.constant = 140
                DispatchQueue.main.async {
                    self.CollectioView.reloadData()
                }
                    
            }
        }
    }
}
