//
//  SchoolPostCollectionViewCell.swift
//  MySchollKinect
//
//  Created by Pritesh on 26/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SDWebImage
class SchoolPostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var objView:UIView!
    @IBOutlet weak var objVideoView:UIView!
    @IBOutlet weak var objOnlyImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnPhoto: UIButton!
    
    
    private var task: URLSessionDataTask?

    var btnPlayVideoClick : (()->())?
    
    override func prepareForReuse() {
        super.prepareForReuse()

        task?.cancel()
        task = nil
        objOnlyImage.image = nil
    }
    
    // Called in cellForRowAt / cellForItemAt
    func configureWith(urlString: String) {
        if task == nil {
            print("image downloading=========",urlString)

            // Ignore calls when reloading
//            task = objOnlyImage.downloadImage(from: urlString)
            objOnlyImage.sd_setImage(with: URL(string: urlString) , placeholderImage: #imageLiteral(resourceName: "Morephotos"), options: SDWebImageOptions.refreshCached)

        }else{
            print("image stop downloading=========",urlString)
        }
    }
    
    // Called in cellForRowAt / cellForItemAt
    func configureWithThumnial(url: URL) {
        if task == nil {
            // Ignore calls when reloading
            print("Thumbnil downloading.....",url)
            getThumbnailImageFromVideoUrl(url: url) { (thumbNailImage) in
                if thumbNailImage != nil{
                    self.objOnlyImage.image = thumbNailImage
                    self.objVideoView.backgroundColor = .clear
                }else{
                    self.objVideoView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1).withAlphaComponent(0.6)
                }
                self.objOnlyImage.contentMode = .scaleAspectFill
            }
        }else{
            print("Thumbnil stop downloading.....",url)
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        objOnlyImage.layer.cornerRadius = 0
        objVideoView.layer.cornerRadius = 0
    }
    @IBAction func didClickBtnPlayNow(_ sender: UIButton) {
        if self.btnPlayVideoClick != nil{
            self.btnPlayVideoClick!()
        }
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        objOnlyImage.image = nil
//        objOnlyImage.sd_cancelCurrentImageLoad()
//    }
}
