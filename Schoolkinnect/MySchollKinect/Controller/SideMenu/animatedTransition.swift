//
//  animatedTransition.swift
//  FirMogoDev
//
//  Created by mac on 08/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit

class AnimatedTransion: NSObject,UIViewControllerAnimatedTransitioning {
    
    var isPresented:Bool
    
    init(isPresented:Bool) {
        self.isPresented = isPresented
        super.init()
    }
    
    func transitionDuration(using   : UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        
        if let tovc = toVC
        {
            
            var fromvc = transitionContext.finalFrame(for: tovc)
            if isPresented
            {
                tovc.view.frame.origin.y = -(tovc.view.frame.height)
                transitionContext.containerView.addSubview(tovc.view)
                UIView.animate(withDuration: 0.2, animations: {
                    tovc.view.transform = CGAffineTransform.init(translationX: 0, y: fromvc.height)
                }) { (completed) in
                    transitionContext.completeTransition(completed)
                }
            }
            else
            {
                //tovc.view.removeFromSuperview()
                UIView.animate(withDuration: 0.2, animations: {
                    tovc.view.frame.origin.y = -(tovc.view.frame.height)
                }) { (completed) in
                    transitionContext.completeTransition(completed)
                }
            }
        }
    }
}
