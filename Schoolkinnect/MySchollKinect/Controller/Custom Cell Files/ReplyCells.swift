//
//  ReplyCells.swift
//  MySchollKinect
//
//  Created by Admin on 26/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import ExpandableLabel
import UIKit

class ReplyCells: UITableViewCell {

    @IBOutlet weak var lblpollscommentdescriptio: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDayAgo: UIButton!
    @IBOutlet weak var lblMessage: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var btnoptins: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
