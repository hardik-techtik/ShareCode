//
//  RDalertcontoller.swift
//  CityGuideApp
//
//  Created by mac on 03/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

 class RDalertcontoller: UIViewController {

    @IBOutlet weak var MeassageView: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    var Message =  ""
    override func viewDidLoad() {
        super.viewDidLoad()
        MeassageView.frame.origin.y = -100
        btnClose.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
        self.lblMessage.text = Message
    }
    
    @objc func close(_ button:UIButton)
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 15, initialSpringVelocity: 25, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.MeassageView.frame.origin.y = 20
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 25, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.MeassageView.frame.origin.y = -100
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: false, completion: nil)
    }

    func presentAlertWithMessage(Message:String,onVc ViewController:UIViewController?)
    {
        let vc = RDalertcontoller.init(nibName: "RDalertcontoller", bundle: nil)
        vc.Message = Message
        vc.modalPresentationStyle = .custom
        let transitionDelegate = AlertControllerDelegate()
        vc.transitioningDelegate = transitionDelegate
        ViewController?.present(vc, animated: false, completion: nil)
    }
    
}


