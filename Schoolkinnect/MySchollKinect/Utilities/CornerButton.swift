//
//  CornerButton.swift
//  MySchollKinect
//
//  Created by Admin on 23/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

@IBDesignable
class CornerButton: UIButton {
    

    @IBInspectable var bodrerColor:UIColor = UIColor.clear{
            didSet
            {
                self.layer.borderColor = self.bodrerColor.cgColor
                self.layoutIfNeeded()
        }
    }
    
    @IBInspectable var bodrerWidth:CGFloat = 0{
            didSet
            {
                self.layer.borderWidth = self.bodrerWidth
                self.layoutIfNeeded()
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
    
    
}
