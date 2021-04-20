//
//  ViewExtension.swift
//  ProjectStructure
//
//  Created by Sumit on 29/08/19.
//  Copyright © 2019 Sumit. All rights reserved.
//

import UIKit

enum viewBorder: String {
    case Left = "borderLeft"
    case Right = "borderRight"
    case Top = "borderTop"
    case Bottom = "borderBottom"
}
var cornerRadiusValue : CGFloat = 0
var corners : UIRectCorner = []
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable public var topLeft : Bool {
        get {
            return corners.contains(.topLeft)
        }
        set {
            setCorner(newValue: newValue, for: .topLeft)
        }
    }
    
    @IBInspectable public var topRight : Bool {
        get {
            return corners.contains(.topRight)
        }
        set {
            setCorner(newValue: newValue, for: .topRight)
        }
    }
    
    @IBInspectable public var bottomLeft : Bool {
        get {
            return corners.contains(.bottomLeft)
        }
        set {
            setCorner(newValue: newValue, for: .bottomLeft)
        }
    }
    
    @IBInspectable public var bottomRight : Bool {
        get {
            return corners.contains(.bottomRight)
        }
        set {
            setCorner(newValue: newValue, for: .bottomRight)
        }
    }
    
    @IBInspectable
    var borderColorView: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = false
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.shadowColor!)
            return color
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shouldRasterize: Bool {
        get {
            return layer.shouldRasterize
        }
        set {
            layer.masksToBounds = false
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = .zero
        }
    }
    
    @IBInspectable
    var rasterizationScale: CGFloat {
        get {
            return layer.rasterizationScale
        }
        set {
            layer.rasterizationScale = newValue
        }
    }
    
    public func showInfoLabel(label: UILabel, _ text: String, animated: Bool = true) {
        if animated {
            UIView.transition(with: label, duration: 1, options: .transitionCrossDissolve, animations: {
                label.alpha = 1
                label.text = text
            })
        } else {
            label.text = text
        }
    }
    
    public func hideInfoLabel(label: UILabel, animated: Bool = true) {
        if animated {
            UIView.transition(with: label, duration: 1, options: .transitionCrossDissolve, animations: {
                label.alpha = 0
            })
        } else {
            label.alpha = 0
        }
    }
    
    func setCorner(newValue: Bool, for corner: UIRectCorner) {
        if newValue {
            addRectCorner(corner: corner)
        } else {
            removeRectCorner(corner: corner)
        }
    }
    
    func addRectCorner(corner: UIRectCorner) {
        corners.insert(corner)
        updateCorners()
    }
    
    func removeRectCorner(corner: UIRectCorner) {
        if corners.contains(corner) {
            corners.remove(corner)
            updateCorners()
        }
    }
    
    func updateCorners() {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadiusValue, height: cornerRadiusValue))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

//protocol MaterialView {
//   func elevate(elevation: Double)
//}
//
//extension UIView: MaterialView {
//    func elevate(elevation: Double) {
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = shadowColor.cgColor
//        self.layer.shadowOffset = shadowOffset
//        self.layer.shadowRadius = abs(CGFloat(elevation))
//        self.layer.shadowOpacity = shadowOpacity
//    }
//}
