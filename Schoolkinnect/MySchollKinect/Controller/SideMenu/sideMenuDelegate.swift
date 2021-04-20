
//
//  sideMenuDelegate.swift
//  FirMogoDev
//
//  Created by mac on 08/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit

class siemenuDelegate: NSObject,UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimatedTransion(isPresented: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimatedTransion(isPresented: false)
    }
}
