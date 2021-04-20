//
//  AlertController.swift
//  CityGuideApp
//
//  Created by mac on 03/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit

class RDProgress: UIPresentationController {
    
    
    override var frameOfPresentedViewInContainerView: CGRect{
        return self.containerView?.bounds ?? CGRect.zero
    }
    
    let DimmView:UIView = {
        let uiview = UIView.init()
        uiview.backgroundColor = UIColor.clear
        return uiview
    }()

    override func presentationTransitionWillBegin() {
        self.containerView?.addSubview(DimmView)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        DimmView.removeFromSuperview()
    }
}
