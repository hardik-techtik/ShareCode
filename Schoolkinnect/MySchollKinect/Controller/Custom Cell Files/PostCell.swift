//
//  PostCell.swift
//  MySchollKinect
//
//  Created by Admin on 25/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import ExpandableLabel
//import Lightbox
import AVFoundation
import Photos
import SDWebImage
import Kingfisher

public protocol PostCellDelegate: class {
    func displayVideoOption(urlOfVideo: URL)
}

class PostCell: UITableViewCell {

    weak var objPostCellDelegate: PostCellDelegate! = nil
    @IBOutlet weak var objView: UIView!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var PostIMage:UIView!
    @IBOutlet weak var btnReply: UIButton!
    
    @IBOutlet weak var btnLika: UIButton!
    @IBOutlet weak var ProfileIMage: UIImageView!
    @IBOutlet weak var lblDescription: ExpandableLabel!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnMessagw: NSLayoutConstraint!
    @IBOutlet weak var lblTItle: UILabel!
    
    @IBOutlet weak var btnpostreplies: UIButton!
    // Create an instance of LightboxController.
    var controller:UIViewController?
    var viewController : UIViewController?

    var arrEventPhotoAndVideoList = [[String: Any]]()
    //@IBOutlet weak var objCollectionView: UICollectionView!
     @IBOutlet weak var horizontalView: PagedHorizontalView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnMore.imageView?.contentMode = .scaleAspectFit
        self.horizontalView.collectionView.register(UINib.init(nibName: "SchoolPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SchoolPostCollectionViewCell")
        
        self.horizontalView.collectionView.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for view in self.PostIMage.subviews
        {
            view.removeFromSuperview()
        }
        controller?.removeFromParent()
        self.setNeedsLayout()
        self.setNeedsDisplay()
        self.resetCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateArrayList(array:[[String: Any]]) {
//            self.objCollectionView.dataSource = self
//            self.objCollectionView.delegate = self
    //        self.objCollectionView.register(UINib.init(nibName: "ImageAndVideoCell", bundle: nil), forCellWithReuseIdentifier: "ImageAndVideoCell")
        
            arrEventPhotoAndVideoList = array
            print("arrEventPhotoAndVideoList count in cell ------\(arrEventPhotoAndVideoList)")
        
            self.horizontalView.pageControl?.numberOfPages = self.arrEventPhotoAndVideoList.count
        
            DispatchQueue.main.async {
                self.horizontalView.collectionView.reloadData()
            }
        
        self.horizontalView.setNeedsLayout()
        self.horizontalView.layoutIfNeeded()
        
        
//        self.horizontalView.collectionView.delegate = self
        }
    
    func resetCollectionView() {
        guard !arrEventPhotoAndVideoList.isEmpty else { return }
        arrEventPhotoAndVideoList = []
        self.horizontalView.collectionView.reloadData()
    }
    
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
    
    func getThumbnailImageFromURL(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value:3, timescale: 120) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func previewImageFromVideo(url: NSURL) -> UIImage? {
        
        let url = url as URL
        let request = URLRequest(url: url)
        let cache = URLCache.shared

        if
            let cachedResponse = cache.cachedResponse(for: request),
            let image = UIImage(data: cachedResponse.data)
        {
            return image
        }

        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = CGSize(width: UIScreen.main.bounds.size.width, height: 120)

        var time = asset.duration
        time.value = min(time.value, 2)

        var image: UIImage?

        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            image = UIImage(cgImage: cgImage)
        } catch { }

        if
            let image = image,
            let data = image.pngData(),
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        {
            let cachedResponse = CachedURLResponse(response: response, data: data)

            cache.storeCachedResponse(cachedResponse, for: request)
        }

        return image
    }
    @objc func showImagePreview(btnPhoto:UIButton) {
        let dict = arrEventPhotoAndVideoList[btnPhoto.tag]

        self.trendingPostsAPI(post_id: dict["post_id"] as! Int, school_id: dict["school_id"] as! Int)
        print("btnPhoto ---> \(btnPhoto.tag)")
        //let topViewController = appDelegate.window?.rootViewController
        let arrImages = self.arrEventPhotoAndVideoList.filter({$0["type"] as! String == "image" })
        
        print("----- arrImages ------ \(arrImages)")
        
        Utility.shared.presentSKPhotoBrowser(imgUrls: arrImages.compactMap({($0["path"] as! URL).absoluteString}), index: btnPhoto.tag, viewCotroller: self.viewController!)
    }
    
    @objc func trendingPostsAPI(post_id: Int, school_id: Int) {
        var dictFilter = [String: Any]()
        dictFilter["school_id"] = school_id
        dictFilter["post_id"] = post_id
        
        NotificationCenter.default.post(name: NSNotification.Name("Call API"), object: dictFilter)
    }
}
extension PostCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrEventPhotoAndVideoList.count == 0 ? 0 : arrEventPhotoAndVideoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchoolPostCollectionViewCell", for: indexPath as IndexPath) as! SchoolPostCollectionViewCell
        let dict = arrEventPhotoAndVideoList[indexPath.item]
//        cell.btnPlay = { () -> () in
//            self.ButtonClickOpenTimeSlotView(index: indexPath.row, tag: tag, cellIndexPath: indexPath, cell: cell)
//        }
        
        cell.objOnlyImage.image = nil
        
        if (dict["type"] as? String) == "image" {
            
            cell.btnPlay.isHidden = true
            cell.objVideoView.isHidden = true
                        
            if dict["path"] as? URL != nil {
                
                cell.objOnlyImage.sd_setImage(with: dict["path"] as? URL , placeholderImage: #imageLiteral(resourceName: "Morephotos"), options: SDWebImageOptions.refreshCached)
            } else {
                cell.objOnlyImage.image = #imageLiteral(resourceName: "Morephotos")
            }
            
            cell.btnPhoto.isHidden = false
            
            cell.btnPlayVideoClick =  { () -> () in
                print("btn play pressed")
            }
            
        } else {
            
            cell.btnPlayVideoClick =  { () -> () in
                print("btn play pressed")
                
                print("dict === \(dict)")
                self.trendingPostsAPI(post_id: dict["post_id"] as! Int, school_id: dict["school_id"] as! Int)
                self.objPostCellDelegate?.displayVideoOption(urlOfVideo: dict["path"] as! URL)
            }
            
            //Fixed by sima
            if let urlThumbnail = dict["thumbnail"] as? String {
                cell.objOnlyImage.sd_setImage(with: URL(string: urlThumbnail) , placeholderImage: #imageLiteral(resourceName: "videoPlaceholder"), options: SDWebImageOptions.refreshCached)
                cell.objVideoView.backgroundColor = .clear
                            cell.objOnlyImage.contentMode = .scaleAspectFill
            }else{
                cell.objOnlyImage.contentMode = .scaleAspectFill
                cell.objOnlyImage.image = #imageLiteral(resourceName: "Morephotos")
                cell.objVideoView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1).withAlphaComponent(0.6)

            }
            cell.btnPlay.isHidden = false
            cell.objVideoView.isHidden = false
            
            cell.btnPhoto.isHidden = true
        }
        
        cell.btnPhoto.tag = indexPath.item
        cell.btnPhoto.addTarget(self, action: #selector(self.showImagePreview(btnPhoto:)), for: UIControl.Event.touchUpInside)
        
        cell.objOnlyImage.contentMode = .scaleAspectFill
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


extension URL {
    func generateThumbnail1() -> UIImage? {
        do {
            let asset = AVURLAsset(url: self)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            // Swift 5.3
            let cgImage = try imageGenerator.copyCGImage(at: .zero,
                                                         actualTime: nil)

            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)

            return nil
        }
    }
}
