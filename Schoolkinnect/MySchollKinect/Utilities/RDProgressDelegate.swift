//
//  RDProgressDelegate.swift
//  CityGuideApp
//
//  Created by mac on 18/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit

class RDProgressView: NSObject,UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return RDProgress(presentedViewController: presented, presenting: presenting)
    }
}
