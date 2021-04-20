//
//  colors.swift
//  MySchollKinect
//
//  Created by Admin on 23/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }

        self.init(
            
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    static let forGroundColor = UIColor.init(red: 182/255, green: 103/255, blue: 52/255, alpha: 1)
    static let readMore = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    static let TextForgroundColor = UIColor(red: 0.075, green: 0.204, blue: 0.38, alpha: 1).cgColor
    static let lightBorderColor = UIColor(red: 0.937, green: 0.928, blue: 0.97, alpha: 1)
}
