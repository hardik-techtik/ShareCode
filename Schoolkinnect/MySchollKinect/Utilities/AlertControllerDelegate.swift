//
//  AlertControllerDelegate.swift
//  CityGuideApp
//
//  Created by mac on 03/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit

class AlertControllerDelegate: NSObject,UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return Rdalert(presentedViewController: presented, presenting: presenting)
    }
    
    
}
