//
//  ServiceManager.swift
//  CityGuideApp
//
//  Created by mac on 26/09/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import Alamofire
import NVActivityIndicatorView
import AVFoundation

func Print(object: Any) {
    Swift.print(object)
}

func getVideoTimeDuration(url : URL) -> Double {
    let asset = AVURLAsset(url: url as URL)
    return asset.duration.seconds
}

class ServiceManager<T:Codable> {
    
    typealias completionHandler = (_ Responce:Codable) -> Void
    
//    private(set) var Url = "http://45.79.111.106/my-school-kinect/api/"
    private(set) var Url = "http://api.myschoolkinect.com/api/"
    private(set) var ClientVersion = ""
    var ServiceName = ""
    var VideoAttachments:[URL]?
    var VideoAttachmentParameter:String?
    var VideoThumbnail: UIImage?
    var arrVideoThumbnail: [UIImage]?
    var VideoThumbnailParameter: String?
    var Attachments:[Any]?
    var AttachmentParameter:String?
    var ShowLoader = true
    var Parameters:[String:Any]?
    var HandleResponse = true
    private var Manager:Session!
    let progress = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.white)
    var RootViewController:UIViewController? = {
        if #available(iOS 13.0, *) {
            let Scenes = UIApplication.shared.connectedScenes
            for scene in Scenes {
                if scene.activationState == .foregroundActive {
                    let vc = ((scene as! UIWindowScene).delegate as! UIWindowSceneDelegate).window!!.rootViewController
                    if let rootVC = vc{
                        return rootVC
                    } else {
                        return nil
                    }
                }
            }
            return nil
        } else {
            return nil
        }
    }()
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        config.timeoutIntervalForRequest = 1000
        
        let token = UserDefaults.standard.object(forKey: "logintoken")  as? String
        print("Authorization token-----\(token ?? "")")
        let authToken = (token == nil || token == "") ? "" : token ?? ""
        config.headers = HTTPHeaders.init(["Authorization":"Bearer \(authToken)","Accept":"application/json"])
        
        Manager = Alamofire.Session(configuration: config)
    }
    func ShowProgess() {
        let ProgessView = UIViewController.init()
        progress.hidesWhenStopped = true
        progress.color = UIColor.white
        progress.layer.cornerRadius = 10
        progress.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        progress.backgroundColor = UIColor.lightGray
        progress.center = ProgessView.view.center
        ProgessView.view.addSubview(self.progress)
        progress.startAnimating()
        ProgessView.modalPresentationStyle = .custom
        let transitinDelegate = RDProgressView.init()
        ProgessView.transitioningDelegate = transitinDelegate
        if let _ = self.RootViewController {
            RootViewController?.present(ProgessView, animated: false, completion: nil)
        }else {
            RootViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.children.last
            RootViewController?.present(ProgessView, animated: false, completion: nil)
        }
    }
    func DismissProgress() {
        progress.stopAnimating()
        RootViewController?.dismiss(animated: false, completion: nil)
    }
    
    
    
    func removeSpinner() {
        let vc = self.RootViewController as? UINavigationController
        for vc in vc?.viewControllers ?? [] where vc is BaseVC
        {
            let basevc = vc as? BaseVC
            basevc?.stopAnimating(nil)
            //            self.vSpinner?.superview!.removeFromSuperview()
            basevc?.vSpinner?.removeFromSuperview()
            
            basevc?.vSpinner = nil
        }
    }
    
    func MakeServiceCall(httpMethod:HTTPMethod,CompletionHandler:@escaping completionHandler) {
        if Attachments != nil || self.VideoAttachments != nil {
            if NetworkReachabilityManager()?.isReachable ?? false {
                let finalUrl = self.Url + ClientVersion + ServiceName
                guard let url = URL.init(string: finalUrl) else {
                    return
                }
                Print(object: "URL:-\(url)")
                print("parameter======",AttachmentParameter!)
                if self.ShowLoader {
                    self.ShowProgess()
                }
                Manager.upload(multipartFormData: { (MultipartData) in
                    for attachment in self.Attachments ?? [] {
                        let randome = arc4random()
                        if attachment is UIImage {
                            let data = (attachment as! UIImage).jpegData(compressionQuality: 0.75)
                            //                            if httpMethod.rawValue == "PUT" {
                            ////                                let str = imageToBase64(tempImage)
                            //                                let str = data?.base64EncodedString()
                            //                                let strBase64 = "data:image/jpeg;base64,\(str ?? "")"
                            //                               let data111 = Data(strBase64.utf8)
                            //
                            //                                MultipartData.append(data111, withName: self.AttachmentParameter!, fileName: "randome\(randome).jpeg", mimeType: "image/jpeg")
                            //                            } else {
                            MultipartData.append(data!, withName: self.AttachmentParameter!, fileName: "randome\(randome).jpg", mimeType: "image/jpg")
                            //                            }
                            
                        }
                        else
                        {
                            guard let data = attachment as? Data else {return}
                            let ext = data.mimeType.components(separatedBy: "/").last ?? ""
                            MultipartData.append(data, withName: self.AttachmentParameter!, fileName: "randome\(randome).\(ext)", mimeType: data.mimeType)
                        }
                    }
                    for Videoattachment in self.VideoAttachments ?? [] {
                        let randome = arc4random()
                        MultipartData.append(Videoattachment, withName: self.VideoAttachmentParameter ?? "", fileName: "randome\(randome).mp4", mimeType: "video/mp4")
                        
//                        if self.ServiceName != "post" {
//                            let thumbnailData = (self.VideoThumbnail ?? #imageLiteral(resourceName: "videoPlaceholder")).jpegData(compressionQuality: 0.75)
//                            MultipartData.append(thumbnailData!, withName: self.VideoThumbnailParameter ?? "thumbnail_image", fileName: "randome\(randome).jpg", mimeType: "image/jpg")
//                        }
                    }
                    
                    for videoThumb in self.arrVideoThumbnail ?? [] {
                        let randome = arc4random()
                        let thumbnailData = (videoThumb).jpegData(compressionQuality: 0.75)
                        MultipartData.append(thumbnailData!, withName: "thumbnail_image[]", fileName: "randome\(randome).jpg", mimeType: "image/jpg")

                    }
                    if let Paras = self.Parameters {
                        Print(object: "Parameters:-\(Paras)")
                        for (key,value) in Paras {
                            guard let data = "\(value)".data(using: String.Encoding.utf8) else {
                                return
                            }
                            MultipartData.append(data, withName: key)
                        }
                    }
                }, to: url).responseData(completionHandler: { (Response) in
                    if self.ShowLoader {
                        self.DismissProgress()
                    }
                    switch Response.result {
                    case .success(let data):
                        do {
                            let Dic = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            print(Dic)
                        } catch  {
                            print(error)
                        }
                        guard var Dic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {return}
                        Dic = (Dic as! [String : Any]).removeNull()
                        Print(object: "Responce:-\(Dic as? [String:Any] ?? [:])")
                        let ResponseData = (Dic as? [String:Any])?["data"]
                        var ResponseToSend:GenericResponse
                        do {
                            if ResponseData is [[String:Any]] {
                                ResponseToSend = try JSONDecoder().decode(ResponseModel<T>.self, from: data)
                                Print(object: ResponseToSend)
                            } else if ResponseData is [String:Any] {
                                ResponseToSend = try JSONDecoder().decode(ResponseModelDic<T>.self, from: data)
                                Print(object: ResponseToSend)
                            } else {
                                ResponseToSend = try JSONDecoder().decode(ResponseModelSuccess.self, from: data)
                                Print(object: ResponseToSend)
                            }
                            if self.HandleResponse {
                                if ResponseToSend.statusCode ?? 0 == 200 {
                                    self.removeSpinner()
                                    CompletionHandler(ResponseToSend)
                                } else if ResponseToSend.statusCode ?? 0 == 401 || (ResponseToSend.errorMsg ?? "").lowercased().contains("token")  {
                                    self.removeSpinner()
                                    let StoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
                                    guard let vc = StoryBoard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC else {return}
                                    self.RootViewController?.show(vc, sender: self.RootViewController)
                                } else {
                                    //CompletionHandler(ResponseToSend)
                                    self.removeSpinner()
                                    RDalertcontoller().presentAlertWithMessage(Message:ResponseToSend.errorMsg ?? "" , onVc: self.RootViewController)
                                }
                            } else {
                                CompletionHandler(ResponseToSend)
                            }
                        }
                        catch let DecodingError.dataCorrupted(context) {
                            Print(object: context)
                        } catch let DecodingError.keyNotFound(key, context) {
                            Print(object: "Key '\(key)' not found:\(context.debugDescription)")
                            Print(object: "codingPath:\(context.codingPath)")
                        } catch let DecodingError.valueNotFound(value, context) {
                            Print(object: "Value '\(value)' not found:\(context.debugDescription)")
                            Print(object: "codingPath:\(context.codingPath)")
                        } catch let DecodingError.typeMismatch(type, context)  {
                            Print(object: "Type '\(type)' mismatch:\(context.debugDescription)")
                            Print(object: "codingPath:\(context.codingPath)")
                        } catch {
                            Print(object: "Error:-\(error.localizedDescription)")
                        }
                    case .failure(let error):
                        Print(object: "Error:-\(error)")
                        break
                    }
                })
            } else  {
                RDalertcontoller().presentAlertWithMessage(Message:"No Internet", onVc: self.RootViewController)
            }
        } else {
            if NetworkReachabilityManager()?.isReachable ?? false {
                let finalUrl = self.Url + ClientVersion + ServiceName
                guard let url = URL.init(string: finalUrl) else {
                    return
                }
                Print(object: "URL:-\(finalUrl)")
                Print(object: "Parameters:-\(self.Parameters ?? [:])")
                if ShowLoader {
                    self.ShowProgess()
                }
                
                let token = UserDefaults.standard.object(forKey: "logintoken")
                print("-----\(token)")
                Manager.request(url, method: httpMethod, parameters: Parameters).responseData { (Response) in
                    if self.ShowLoader {
                        self.DismissProgress()
                    }
                    switch Response.result {
                    case .success(let data):
                        do {
                            let Dic = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            print(Dic)
                        } catch  {
                            print(error)
                        }
                        guard var Dic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {return}
                        Print(object: "Responce:-\(Dic as? [String:Any] ?? [:])")
                        
                        let ResponseData = (Dic as? [String:Any])?["data"]
                        var ResponseToSend:GenericResponse
                        do {
                            if ResponseData is [[String:Any]] {
                                ResponseToSend = try JSONDecoder().decode(ResponseModel<T>.self, from: data)
                                Print(object: ResponseToSend)
                            } else if ResponseData is [String:Any] {
                                ResponseToSend = try JSONDecoder().decode(ResponseModelDic<T>.self, from: data)
                                Print(object: ResponseToSend)
                            } else {
                                ResponseToSend = try JSONDecoder().decode(ResponseModelSuccess.self, from: data)
                                Print(object: ResponseToSend)
                            }
                            if self.HandleResponse {
                                if ResponseToSend.statusCode ?? 0 == 200 {
                                    CompletionHandler(ResponseToSend)
                                    self.removeSpinner()
                                } else if ResponseToSend.statusCode ?? 0 == 401 ||  (ResponseToSend.errorMsg ?? "").lowercased().contains("token") {
                                    self.removeSpinner()
                                    
                                    let vc = appDelegate.window?.rootViewController
                                
                                    if (ResponseToSend.errorMsg ?? "").lowercased().contains("token") {
                                        if !vc!.isKind(of: SignInVC.self) || !vc!.isKind(of: CreateProfileVC.self) || !vc!.isKind(of: GetStartedVC.self) {
                                            UserDefaults.standard.removeObject(forKey: "User")
                                            UserDefaults.standard.removeObject(forKey: "SchoolName")
                                            self.RootViewController?.navigationController?.popToRootViewController(animated: true)
                                        }
                                    }else {
                                        if let _ = self.RootViewController {
                                            RDalertcontoller().presentAlertWithMessage(Message:ResponseToSend.errorMsg ?? "" , onVc: self.RootViewController)
                                        }else {
                                            let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.children.last
                                             RDalertcontoller().presentAlertWithMessage(Message:ResponseToSend.errorMsg ?? "" , onVc: vc)
                                        }
                                        
                                    }
                                }
                                else if ResponseToSend.statusCode == 403 {
                                    self.removeSpinner()
                                    let StoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
                                    guard let vc = StoryBoard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC else {return}
                                    self.RootViewController?.show(vc, sender: self.RootViewController)
                                    
                                    RDalertcontoller().presentAlertWithMessage(Message:ResponseToSend.errorMsg ?? "" , onVc: self.RootViewController)
                                    
                                }
                                else {
                                    if let _ = self.RootViewController {
                                        print(ResponseToSend.errorMsg)
                                        RDalertcontoller().presentAlertWithMessage(Message:ResponseToSend.errorMsg ?? "" , onVc: self.RootViewController)
                                    }else {
                                        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.children.last
                                        RDalertcontoller().presentAlertWithMessage(Message:ResponseToSend.errorMsg ?? "" , onVc: vc)
                                    }
                                }
                            } else {
                                self.removeSpinner()
                                CompletionHandler(ResponseToSend)
                            }
                        }
                        catch let DecodingError.dataCorrupted(context) {
                            Print(object: context)
                        } catch let DecodingError.keyNotFound(key, context) {
                            Print(object: "Key '\(key)' not found:\(context.debugDescription)")
                            Print(object: "codingPath:\(context.codingPath)")
                        } catch let DecodingError.valueNotFound(value, context) {
                            Print(object: "Value '\(value)' not found:\(context.debugDescription)")
                            Print(object: "codingPath:\(context.codingPath)")
                        } catch let DecodingError.typeMismatch(type, context)  {
                            Print(object: "Type '\(type)' mismatch:\(context.debugDescription)")
                            Print(object: "codingPath:\(context.codingPath)")
                        } catch {
                            Print(object: "Error:-\(error.localizedDescription)")
                        }
                    case .failure(let error):
                        Print(object: "Error:-\(error)")
                        break
                    }
                }
            } else {
                
                RDalertcontoller().presentAlertWithMessage(Message:"No Internet" , onVc: self.RootViewController)
            }
        }
    }
    func imageToBase64(_ image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}
extension Data {
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
    ]
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
}
extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
}

extension Dictionary {

   func removeNull() -> Dictionary {
       let mainDict = NSMutableDictionary.init(dictionary: self)
       for _dict in mainDict {
           if _dict.value is NSNull {
               mainDict.removeObject(forKey: _dict.key)
           }
           if _dict.value is NSDictionary {
               let test1 = (_dict.value as! NSDictionary).filter({ $0.value is NSNull }).map({ $0 })
               let mutableDict = NSMutableDictionary.init(dictionary: _dict.value as! NSDictionary)
               for test in test1 {
                   //mutableDict.removeObject(forKey: test.key)
                    mutableDict[test.key] = ""
               }
               mainDict.removeObject(forKey: _dict.key)
               mainDict.setValue(mutableDict, forKey: _dict.key as? String ?? "")
           }
           if _dict.value is NSArray {
               let mutableArray = NSMutableArray.init(object: _dict.value)
               for (index,element) in mutableArray.enumerated() where element is NSDictionary {
                   let test1 = (element as! NSDictionary).filter({ $0.value is NSNull }).map({ $0 })
                   let mutableDict = NSMutableDictionary.init(dictionary: element as! NSDictionary)
                   for test in test1 {
                       //mutableDict.removeObject(forKey: test.key)
                        mutableDict[test.key] = ""
                   }
                   mutableArray.replaceObject(at: index, with: mutableDict)
               }
               mainDict.removeObject(forKey: _dict.key)
               mainDict.setValue(mutableArray, forKey: _dict.key as? String ?? "")
           }
       }
       return mainDict as! Dictionary<Key, Value>
   }
}
