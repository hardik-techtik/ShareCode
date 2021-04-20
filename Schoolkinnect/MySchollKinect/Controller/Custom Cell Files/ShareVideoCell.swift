//
//  ShareVideoCell.swift
//  MySchollKinect
//
//  Created by Shreyansh on 24/06/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import UIKit
import ExpandableLabel
import AVFoundation
import Photos
import SDWebImage
import Kingfisher


class ShareVideoCell: UITableViewCell {
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgVideoThubmail: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnOption: UIButton!
    @IBOutlet weak var lblDesscription: UILabel!
    @IBOutlet weak var lblViewCount: UILabel!
    @IBOutlet weak var btnProfile: UIButton!
    
    
    var playVideoClauser : (()->())?
    var moreActionClauser : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        for view in self.imgVideoThubmail.subviews
//        {
//            view.removeFromSuperview()
//        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionMore(_ sender: UIButton) {
        if self.moreActionClauser != nil {
            self.moreActionClauser!()
        }
    }
    
    @IBAction func actionPlay(_ sender: UIButton) {
        if self.playVideoClauser != nil {
            self.playVideoClauser!()
        }
    }
    
    func getThumbnailImageFromURL(forUrl : URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: forUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value:3, timescale: 120) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        return nil
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


    func setVideoThumnailData(dict:ShareVideo){
        if let urlThumbnail = dict.strVideo {
               // self.imgVideoThubmail.image = self.previewImageFromVideo(url: NSURL(string: urlThumbnail)!)
            if let urlThumbnail = URL(string: urlThumbnail) {
                DispatchQueue.global().async {
                    
                    self.getThumbnailImageFromVideoUrl(url: urlThumbnail) { (thumbNailImage) in
                        self.imgVideoThubmail.image = thumbNailImage
                        self.imgVideoThubmail.contentMode = .scaleAspectFill
//                        objVideoView.backgroundColor = .clear
                    }

//                    if let img = self.previewImageFromVideo(url: urlThumbnail as NSURL) {
//                        DispatchQueue.main.async {
//                            self.imgVideoThubmail.image = img
//                        }
//                    }
//                    else{
                        DispatchQueue.main.async {
                            self.imgVideoThubmail.image = #imageLiteral(resourceName: "Morephotos")
                        }
//                    }
                }
            }
            else {
                self.imgVideoThubmail.image = #imageLiteral(resourceName: "Morephotos")
            }
        }else{
            self.imgVideoThubmail.image = #imageLiteral(resourceName: "Morephotos")
        }

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
    
    
}
