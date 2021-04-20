//
//  MessageCell.swift
//  MySchollKinect
//
//  Created by Admin on 31/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var ProfileImg: UIImageView!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblMsgDate: UILabel!
    
    
//    @IBOutlet weak var lblSubjName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserLastMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
