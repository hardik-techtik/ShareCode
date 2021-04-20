//
//  RDScrollView.swift
//  MySchollKinect
//
//  Created by Admin on 29/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class RDScrollView: UIScrollView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.isDirectionalLockEnabled = true
    }
}
