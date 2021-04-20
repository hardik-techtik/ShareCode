//
//  ButtonFormatter.swift
//  MySchollKinect
//
//  Created by Admin on 02/06/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ButtonFormatter: UIButton {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.layer.cornerRadius = bounds.height/2
        self.layer.masksToBounds = true
        self.setImage(UIImage.init(named: "Close"), for: .normal)
    }

}
