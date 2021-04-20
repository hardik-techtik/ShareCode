//
//  PollsCell.swift
//  MySchollKinect
//
//  Created by Admin on 26/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import ExpandableLabel
class PollsCell: UITableViewCell {
 @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var lblPollDescription: ExpandableLabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnDislike: UIButton!
    @IBOutlet weak var btnReplies: UIButton!
    @IBOutlet weak var btnOptions: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
