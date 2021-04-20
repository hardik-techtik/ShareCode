//
//  RightMessageCell.swift
//  Agohra
//
//  Created by Anami on 01/01/20.
//  Copyright © 2020 Anami. All rights reserved.
//

import UIKit

class RightMessageCell: UITableViewCell {
    
    @IBOutlet weak var rightMessageView: UIView!
    @IBOutlet weak var labelRightMessage: UILabel!
    @IBOutlet weak var lblSeperator: UILabel!
    @IBOutlet weak var conSeperateHeight: NSLayoutConstraint!
    
    var prevMsg : ChatMessage?
    
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var mdlChatMsg : ChatMessage! {
        didSet{
            self.lblTime.text  = mdlChatMsg.sent_datetime
            self.labelRightMessage.text = mdlChatMsg.msgbody
            
            self.showDateSeperator()
        }
    }
    
    func showDateSeperator() {
        if self.prevMsg != nil {
            let prevMessageDateComponents: DateComponents = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: self.prevMsg!.dateCreated)
            let currMessageDateComponents: DateComponents = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: self.mdlChatMsg.dateCreated)
            
            if prevMessageDateComponents.year != currMessageDateComponents.year || prevMessageDateComponents.month != currMessageDateComponents.month || prevMessageDateComponents.day != currMessageDateComponents.day {
                
                self.lblSeperator.isHidden = false
                self.conSeperateHeight.constant = 20
                
            }else {
                self.lblSeperator.isHidden = true
                self.conSeperateHeight.constant = 0
            }
            
        }else {
            self.lblSeperator.isHidden = false
            self.conSeperateHeight.constant = 20
        }
        
        self.lblSeperator.text = self.mdlChatMsg.strCreatedDate
        
        self.layoutIfNeeded()
    }
    
    func setPrevMsg(dict:ChatMessage?) {
        self.prevMsg = dict
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.rightMessageView.roundCorners(corners: [.topLeft, .bottomLeft, .bottomRight], radius: 10)
//        self.rightMessageView.layoutIfNeeded()
        
        //TOP
        self.rightMessageView.layer.cornerRadius = 10
        self.rightMessageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        //BOTTOM
        self.rightMessageView.layer.cornerRadius = 10
        self.rightMessageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        self.rightMessageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
