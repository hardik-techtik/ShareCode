//
//  ImageAndVideoCell.swift
//  MySchollKinect
//
//  Created by Pritesh on 26/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ImageAndVideoCell: UICollectionViewCell {

    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var objView:UIView!
    @IBOutlet weak var objVideoView:UIView!
    @IBOutlet weak var objOnlyImage: UIImageView!
    @IBOutlet weak var btnPhoto: UIButton!
    
    
    var btnPlayVideoClick : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        objOnlyImage.layer.cornerRadius = 2
        objVideoView.layer.cornerRadius = 2
        // Initialization code
    }

    @IBAction func didClickBtnPlayNow(_ sender: UIButton) {
           if self.btnPlayVideoClick != nil{
               self.btnPlayVideoClick!()
           }
       }
}
