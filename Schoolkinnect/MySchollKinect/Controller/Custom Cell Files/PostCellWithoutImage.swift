//
//  PostCellWithoutImage.swift
//  MySchollKinect
//
//  Created by Admin on 26/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import ExpandableLabel

class PostCellWithoutImage: UITableViewCell {

    @IBOutlet weak var objView: UIView!
    @IBOutlet weak var btnreply: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lblDescription: ExpandableLabel!
    
    @IBOutlet weak var ProfileIMage: UIImageView!

    @IBOutlet weak var btnlike: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblDescription.numberOfLines = 3
        lblDescription.collapsed = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
