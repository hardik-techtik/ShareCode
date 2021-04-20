//
//  EventsCell.swift
//  MySchollKinect
//
//  Created by Admin on 28/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SDWebImage
import Photos

public protocol EventsCellDelegate: class {
    func displayVideoOptionInEventVC(urlOfVideo: URL)
    func redirectToDetail(indx:Int)
}


class EventsCell: UITableViewCell {
    
    weak var objEventsCellDelegate: EventsCellDelegate?
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var PostIMage: UIView!
    @IBOutlet weak var btnOptions: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var  lblDate: UILabel!
    @IBOutlet weak var conClgHeight: NSLayoutConstraint!
    
    
//    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrEventPhotoAndVideoList = [[String: Any]]()
//    @IBOutlet weak var objCollectionView: UICollectionView!
    
     @IBOutlet weak var horizontalView: PagedHorizontalView!
    
    var vc : UIViewController!
    var cellIndex : Int = -1
    
//    class var customCell : ImageAndVideoCell {
//        let cell = Bundle.main.loadNibNamed("ImageAndVideoCell", owner: self, options: nil)?.last
//        return cell as! ImageAndVideoCell
//    }
    func updateArrayList(array:[[String: Any]]) {
       
        arrEventPhotoAndVideoList = array
        print("arrEventPhotoAndVideoList count in cell ------\(arrEventPhotoAndVideoList)")
        
        self.horizontalView.pageControl?.numberOfPages = self.arrEventPhotoAndVideoList.count
        
        DispatchQueue.main.async {
            self.horizontalView.collectionView.reloadData()
        }
        
        if array.count > 0 {
            self.conClgHeight.constant = 330
        }else {
            self.conClgHeight.constant = 0
        }
        
        self.horizontalView.setNeedsLayout()
        self.horizontalView.layoutIfNeeded()
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.horizontalView.collectionView.register(UINib.init(nibName: "ImageAndVideoCell", bundle: nil), forCellWithReuseIdentifier: "ImageAndVideoCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var controller:UIViewController?

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
        imageGenerator.maximumSize = CGSize(width: 250, height: 120)

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
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbNailImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }

    @objc func showImagePreview(btnPhoto:UIButton) {
        /*print("btnPhoto ---> \(btnPhoto.tag)")
        //let topViewController = appDelegate.window?.rootViewController
        let arrImages = self.arrEventPhotoAndVideoList.filter({$0["type"] as! String == "image" })
        
        Utility.shared.presentSKPhotoBrowser(imgUrls: arrImages.compactMap({($0["path"] as! URL).absoluteString}), index: btnPhoto.tag, viewCotroller: self.vc!)*/
        self.objEventsCellDelegate?.redirectToDetail(indx: self.cellIndex)
        
    }
    
}
extension EventsCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrEventPhotoAndVideoList.count == 0 ? 0 : arrEventPhotoAndVideoList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageAndVideoCell", for: indexPath as IndexPath) as! ImageAndVideoCell
        let dict = arrEventPhotoAndVideoList[indexPath.item]
        
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk(onCompletion: nil)
        
        if (dict["type"] as? String) == "image" {
            cell.btnPlay.isHidden = true
            cell.objVideoView.isHidden = true
            cell.objOnlyImage.sd_setImage(with: dict["path"] as? URL, placeholderImage: #imageLiteral(resourceName: "Morephotos"), options: SDWebImageOptions.continueInBackground)
            cell.objOnlyImage.contentMode = .scaleAspectFill
            cell.btnPhoto.isHidden = false
        } else {
            
            cell.objOnlyImage.image = UIImage(named: "videoPlaceholder")
            
            cell.btnPlay.isHidden = false
            cell.objVideoView.isHidden = false
            
           
            
            if let image =  dict["path"] as? URL {
                
                
                self.getThumbnailImageFromVideoUrl(url: image) { (thumbNailImage) in
                    cell.objOnlyImage.image = thumbNailImage
                    cell.objOnlyImage.contentMode = .scaleToFill
                    cell.objVideoView.backgroundColor = .clear
                }

//                if let img = self.previewImageFromVideo(url: image as NSURL) {
//                    DispatchQueue.main.async {
//                        cell.objOnlyImage.image = img
//                        cell.objOnlyImage.contentMode = .scaleToFill
//                    }
//                }
                
            }else{
                DispatchQueue.main.async {
                    cell.objOnlyImage.image = #imageLiteral(resourceName: "videoPlaceholder")
                    cell.objOnlyImage.contentMode = .scaleAspectFit
                }
            }
            
            
            cell.btnPlayVideoClick =  { () -> () in
                self.objEventsCellDelegate?.displayVideoOptionInEventVC(urlOfVideo: dict["path"] as! URL)
            }
            cell.btnPhoto.isHidden = true
        }
        
        cell.btnPhoto.tag = indexPath.item
        cell.btnPhoto.addTarget(self, action: #selector(self.showImagePreview(btnPhoto:)), for: UIControl.Event.touchUpInside)
        
//        cell.objOnlyImage.contentMode = .scaleAspectFill
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 200)
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)

    }
}
