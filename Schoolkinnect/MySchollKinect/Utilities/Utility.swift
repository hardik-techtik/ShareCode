//
//  Utility.swift
//  DrWittng
//
//  Created by Shreyansh on 27/06/19.
//  Copyright © 2019 Shreyansh. All rights reserved.
//

import Foundation
import UIKit
import AVKit
//import SKPhotoBrowser

let appDelegate = UIApplication.shared.delegate as! AppDelegate
class Utility {
    static var shared = Utility()
    var rootViewController : UIViewController? = UIApplication.shared.keyWindow?.rootViewController
    var isCameraAllowed = false
    var intImageCount = 0
    var arrImageViewUtility = [[String: Any]]()
    
    var accountSchoolInfo : (Int,String)? 
    
    let Gender = ["Male","Female"]
    let RelationShip = ["Single","In Relationship"]
    let schoolClassification = ["Freshman","Sophomore","Junior","Senior"]
    let schoolType = ["Middle School","High School","College"]
    let characterLimit = 300
    
    lazy var arrAge: [String] = {
        var arr:[String] = []
        for i in 1...99
        {
            arr.append("\(i)")
        }
        return arr
    }()
    
    func presentSKPhotoBrowser(imgUrls:[String],index:Int = 0,viewCotroller : UIViewController) {
        
        if imgUrls.count == 0 {
            return
        }
        
        DispatchQueue.main.async {
            var images = [IDMPhoto]()
            
            for url in imgUrls {
                images.append(IDMPhoto.init(url: URL(string: url)))
            }
            
            let browser = IDMPhotoBrowser.init(photos: images)!
            browser.displayArrowButton = true
            browser.setInitialPageIndex(UInt(index))
            browser.displayCounterLabel = true
            browser.useWhiteBackgroundColor = false
            browser.forceHideStatusBar = true
            
            viewCotroller.present(browser, animated: true) {
                
            }
        }
        
    }

    //MARK: -  pick image from Gallery & Camera 
    static func pickImageFromCameraAndGallery(VC: AnyObject, objViewController: UIViewController, editProfile: String) {
        let imagePicker = UIImagePickerController()
        let alert = UIAlertController(title: "Choose image from", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            // Open Camera
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                if editProfile == "editProfile" {
                    imagePicker.mediaTypes = ["public.image"]
                } else {
                    imagePicker.mediaTypes = ["public.image"]
                }
                
                imagePicker.allowsEditing = true
                imagePicker.videoMaximumDuration = 30
                imagePicker.delegate = VC as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                objViewController.present(imagePicker, animated: true, completion: nil)
            } else {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                objViewController.present(alert, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            // Open Gallery
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            if editProfile == "editProfile" {
                imagePicker.mediaTypes = ["public.image"]
            } else {
                imagePicker.mediaTypes = ["public.image"]
            }
            imagePicker.videoMaximumDuration = 30
            imagePicker.delegate = VC as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            objViewController.present(imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        objViewController.present(alert, animated: true, completion: nil)
    }
    func writeToUserDefaults(value:String,accesskey:String) {
        UserDefaults.standard.set(value, forKey:accesskey)
    }
    
    class func logAllAvailableFonts() {
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
    func setAttributtedText(font1: String, font2: String, fontSize1: Int, fontSize2: Int, strMessage1: String, strMessage2: String, color1: UIColor, color2: UIColor) -> NSAttributedString {
        let yourAttributes = [NSAttributedString.Key.foregroundColor: color1, NSAttributedString.Key.font: UIFont(name:font1,size:CGFloat(fontSize1))]
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: color2, NSAttributedString.Key.font: UIFont(name:font2,size:CGFloat(fontSize2))]
        
        let partOne = NSMutableAttributedString(string: strMessage1, attributes: yourAttributes as [NSAttributedString.Key : Any])
        let partTwo = NSMutableAttributedString(string: strMessage2, attributes: yourOtherAttributes as [NSAttributedString.Key : Any])
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        return combination
    }
    
    func SetDateFormat(startDate: String, endDate: String, inputDateformate: String, outputDateformate: String, outputDateformate2: String) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = inputDateformate//"HH:mm:ss"//07:00:00",
        
        
        let date1 = dateFormatter1.date(from: (startDate))
        dateFormatter1.dateFormat = outputDateformate
        let Date12 = dateFormatter1.string(from: date1!)
        print("12 hour formatted Date:",Date12)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = inputDateformate//"HH:mm:ss"
        
        let date2 = dateFormatter2.date(from: (endDate))
        dateFormatter2.dateFormat = outputDateformate2
        let Date121 = dateFormatter2.string(from: date2!)
        print("12 hour formatted Date:-------",Date121)
        
        let formatedString = "(\(Date12) - \(Date121.lowercased()))"
        return formatedString
    }
    
    func ConvertDateFormateToDate( inputDateformate: String, outputDateformate: String) -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = inputDateformate
        
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = outputDateformate
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        print(myStringafd)
        return myStringafd
    }
    func setAttributtedTextSubmittingDoc(fontBold: String, fontRegular: String, fontSize1: Int, strQuicktype: String, strQuicktypeMessage: String,strHelpMessage: String, strAdvMessage: String,  color1: UIColor, color2: UIColor) -> NSAttributedString {
        let yourAttributes = [NSAttributedString.Key.foregroundColor: color1, NSAttributedString.Key.font: UIFont(name:fontBold,size:CGFloat(fontSize1))]
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: color1, NSAttributedString.Key.font:  UIFont(name:fontRegular,size:CGFloat(fontSize1))]
        let yourOtherAttributes2 = [NSAttributedString.Key.foregroundColor: color2, NSAttributedString.Key.font:  UIFont(name:fontBold,size:CGFloat(fontSize1))]
        let partOne = NSMutableAttributedString(string: strQuicktype, attributes: yourAttributes as [NSAttributedString.Key : Any])
        let partTwo = NSMutableAttributedString(string: strQuicktypeMessage, attributes: yourOtherAttributes as [NSAttributedString.Key : Any])
        let partTwo2 = NSMutableAttributedString(string: strHelpMessage, attributes: yourOtherAttributes2 as [NSAttributedString.Key : Any])
        let partTwo3 = NSMutableAttributedString(string: strAdvMessage, attributes: yourOtherAttributes as [NSAttributedString.Key : Any])
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        combination.append(partTwo2)
        combination.append(partTwo3)
        return combination
    }
    func DateConvertToString(inputDateformate: String, outputDateformate: String, strScheduleDate: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = inputDateformate//"2020-04-18T00:00:00.000Z",
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = outputDateformate
        
        var strDate = ""
//        let scheduleDate = dictTaskInProgressDetail.schedule?.first??.date == nil ? "" : dictTaskInProgressDetail.schedule?.first??.date
        if let date = dateFormatterGet.date(from: (strScheduleDate)) {
            print(dateFormatterPrint.string(from: date))
//            self.eventStartDate = date
            strDate = "\(dateFormatterPrint.string(from: date))"
        } else {
            print("There was an error decoding the string")
            
        }
        return strDate
    }
    
    //MARK: -  Create thumbnail 
    func createVideoThumbnail(url: URL, imageView: UIImageView) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize = CGSize(width: imageView.frame.width, height: imageView.frame.height)

        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        }
        catch {
          print(error.localizedDescription)
          return #imageLiteral(resourceName: "videoPlaceholder")
        }
    }
}

extension NSLayoutConstraint {
    /**
     Change multiplier constraint

     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
    */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {

        NSLayoutConstraint.deactivate([self])

        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)

        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier

        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
extension UITextField {
    
    enum Direction {
        case Left
        case Right
    }
    
    // add image to textfield
    func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        mainView.layer.cornerRadius = 5
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = CGFloat(0.5)
        view.layer.borderColor = colorBorder.cgColor
        mainView.addSubview(view)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
        view.addSubview(imageView)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = colorSeparator
        mainView.addSubview(seperatorView)
        
        if(Direction.Left == direction){ // image left
            seperatorView.frame = CGRect(x: 45, y: 0, width: 5, height: 45)
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            seperatorView.frame = CGRect(x: 0, y: 0, width: 5, height: 35)
            self.rightViewMode = .always
            self.rightView = mainView
        }
        
        self.layer.borderColor = colorBorder.cgColor
        self.layer.borderWidth = CGFloat(0.5)
        self.layer.cornerRadius = 5
    }
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}
