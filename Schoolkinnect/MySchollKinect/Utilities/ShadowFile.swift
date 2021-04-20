//
//  ShadowFile.swift
//  MySchollKinect
//
//  Created by Admin on 23/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

extension UIView
{
    func AddDefaultShadow()
    {
        self.layer.shadowPath =
            UIBezierPath(roundedRect: self.bounds,
                         cornerRadius: 15).cgPath
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
    
    }
    
    func AddDefaultShadowToTable()
    {
        
        let shadowLayer = CAShapeLayer.init()
        shadowLayer.shadowPath =
            UIBezierPath(roundedRect: self.bounds,
                         cornerRadius: 15).cgPath
        shadowLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowOffset = CGSize(width: 0, height: 10)
        shadowLayer.shadowRadius = 15
        shadowLayer.masksToBounds = false
        self.layer.insertSublayer(shadowLayer, at: 0)
        
        
        for view in subviews ?? []
        {
            if view.tag == 1
            {
                view.removeFromSuperview()
                break
            }
            let view = UIView.init(frame: self.bounds)
            view.cornerRadius = 15
            view.layer.masksToBounds = true
            view.tag = 1
            self.insertSubview(view, at: 0)
            
        }
        
    }
    
    
//    func AddcellDefaultShadow()
//    {
//        self.layer.shadowPath =
//            UIBezierPath(roundedRect: self.bounds,
//                         cornerRadius: 15).cgPath
//
//        self.layer.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
//        self.layer.shadowOpacity = 1
//        self.layer.shadowOffset = CGSize(width: 0, height: 5)
//        self.layer.shadowRadius = 10
//        self.layer.masksToBounds = false
//
//    }
    
    func AddcellDefaultShadow()
    {
        self.layer.shadowPath =
            UIBezierPath(roundedRect: self.bounds,
                         cornerRadius: 15).cgPath

        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
    }
    
    
    func AddDefaultShadowToButton()
    {
        self.layer.shadowPath =
            UIBezierPath(roundedRect: self.bounds,
                         cornerRadius: 15).cgPath
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
    }
    
    func addShadowToImage()
    {
        self.layer.shadowPath =
            UIBezierPath(roundedRect: self.bounds,
                         cornerRadius: self.bounds.height/2).cgPath
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 10
        
    }
}
    
