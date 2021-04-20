//
//  LeftMessageCell.swift
//  Agohra
//
//  Created by Anami on 01/01/20.
//  Copyright © 2020 Anami. All rights reserved.
//

import UIKit

class LeftMessageCell: UITableViewCell {

   
    @IBOutlet weak var leftMessageView: UIView!
    @IBOutlet weak var labelLeftMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSeperator: UILabel!
    @IBOutlet weak var conSeperatorHeight: NSLayoutConstraint!
    
    var prevMsg : ChatMessage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var mdlChatMsg : ChatMessage! {
        didSet{
            self.lblTime.text  = mdlChatMsg.sent_datetime
            self.labelLeftMessage.text = mdlChatMsg.msgbody
            
            self.showDateSeperator()
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
    
    override func layoutSubviews() {
//        self.leftMessageView.roundCorners(corners: [.topRight, .bottomRight, .bottomLeft], radius: 10)
//        self.leftMessageView.layoutIfNeeded()

        //TOP
        self.leftMessageView.layer.cornerRadius = 10
        self.leftMessageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        //BOTTOM
        self.leftMessageView.layer.cornerRadius = 10
        self.leftMessageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        
        self.leftMessageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
