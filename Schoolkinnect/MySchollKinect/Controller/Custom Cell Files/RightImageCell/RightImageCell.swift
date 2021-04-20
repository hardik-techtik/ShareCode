//
//  RightImageCell.swift
//  Agohra
//
//  Created by Anami on 13/04/20.
//  Copyright © 2020 Anami. All rights reserved.
//

import UIKit

class RightImageCell: UITableViewCell {
    @IBOutlet weak var rightImageMessagPic: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSeperator: UILabel!
    @IBOutlet weak var conSeperatorHeight: NSLayoutConstraint!
    @IBOutlet weak var btnPhoto: UIButton!
    
    var prevMsg : ChatMessage?
    
    var mdlChatMsg : ChatMessage! {
        didSet{
            self.lblTime.text  = mdlChatMsg.sent_datetime
            self.rightImageMessagPic!.sd_setImage(with: URL.init(string: mdlChatMsg.mediaPath), placeholderImage: #imageLiteral(resourceName: "Morephotos"), options: SDWebImageOptions.continueInBackground)
            self.imageView!.contentMode = .scaleAspectFit
            
            self.layer.cornerRadius = 5
            self.layer.masksToBounds = true
            self.clipsToBounds = true
            
            
            
            self.showDateSeperator()
            
            self.layer.masksToBounds = true
        }
    }
    
    func showDateSeperator() {
        if self.prevMsg != nil {
            let prevMessageDateComponents: DateComponents = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: self.prevMsg!.dateCreated)
            let currMessageDateComponents: DateComponents = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: self.mdlChatMsg.dateCreated)
            
            if prevMessageDateComponents.year != currMessageDateComponents.year || prevMessageDateComponents.month != currMessageDateComponents.month || prevMessageDateComponents.day != currMessageDateComponents.day {
                
                self.lblSeperator.isHidden = false
                self.conSeperatorHeight.constant = 20
                
            }else {
                
                self.lblSeperator.isHidden = true
                self.conSeperatorHeight.constant = 0
                
            }
            
        }else {
            self.lblSeperator.isHidden = false
            self.conSeperatorHeight.constant = 20
        }
        
        self.lblSeperator.text = self.mdlChatMsg.strCreatedDate
        
        self.layoutIfNeeded()
    }
    
    func setPrevMsg(dict:ChatMessage?) {
        self.prevMsg = dict
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.rightImageMessagPic.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
