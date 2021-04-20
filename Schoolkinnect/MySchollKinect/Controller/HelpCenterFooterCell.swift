//
//  HelpCenterFooterCell.swift
//  MySchollKinect
//
//  Created by Pritesh on 04/07/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class HelpCenterFooterCell: UITableViewHeaderFooterView {

    @IBOutlet weak var objHelpCenterStackView: UIStackView!
    @IBOutlet weak var objContactView: UIView!
    @IBOutlet weak var objContactDetailView: UIView!
    @IBOutlet weak var objBtnContact: UIButton!
    var ContactButtonClickClosure: ((Bool, Int) -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    @IBAction func contactButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.ContactButtonClickClosure != nil {
            
            self.ContactButtonClickClosure!(sender.isSelected, sender.tag)
        }
    }
}
