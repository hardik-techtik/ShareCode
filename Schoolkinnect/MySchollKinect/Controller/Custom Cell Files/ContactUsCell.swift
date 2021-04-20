//
//  ContactUsCell.swift
//  MySchollKinect
//
//  Created by Shreyansh on 17/07/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ContactUsCell: UITableViewCell {
    
    @IBOutlet weak var txtName: RDTextField!
    @IBOutlet weak var txtEmail: RDTextField!
    @IBOutlet weak var tvQuetion: RDTextView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var contactUsCompletion : ((String?, String?, String?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionContactUs(btnContactUs : UIButton) {
        contactUsCompletion?(self.txtName.text,self.txtEmail.text,self.tvQuetion.text)
    }
    

}
