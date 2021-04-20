//
//  Presentationcontroller.swift
//  FirMogoDev
//
//  Created by mac on 08/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit

class PresentationController: UIPresentationController {
    
    
    override var frameOfPresentedViewInContainerView: CGRect
    {
        return self.containerView?.bounds ?? CGRect.zero
    }
    
    lazy var dimView: UIView = {
        let view = UIView.init(frame: self.containerView?.bounds ?? CGRect.zero)
        view.backgroundColor = UIColor.init(hexFromString: "979797")
        
        return view
    }()
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        self.containerView?.insertSubview(dimView, at: 0)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        dimView.removeFromSuperview()
    }
    
    @objc func Close()
    {
        guard let sidemenu = (self.presentedViewController as? SideMenuVC) else {return}
        sidemenu.CloseTools(sidemenu.btnCloseTools)
    }
}
