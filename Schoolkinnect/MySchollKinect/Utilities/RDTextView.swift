    //
//  RDTextView.swift
//  MySchollKinect
//
//  Created by Admin on 25/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@IBDesignable
class RDTextView:  IQTextView{

    //@IBInspectable var color:UIColor = UIColor.clear
    //@IBInspectable var width:CGFloat = 0.0
    
    /*@IBInspectable var PlaceholderTextColor:UIColor?
        {
        didSet{
            self.layoutIfNeeded()
        }
    }*/

    /*@IBInspectable var placeholderSting:String = "" {
        didSet
        {
            if self.placeholderSting != ""
            {
                /*let placeholder = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 21))
                placeholder.translatesAutoresizingMaskIntoConstraints = false
                placeholder.text = self.placeholderSting
                placeholder.textColor = UIColor.init(hexFromString: "666666").withAlphaComponent(0.5)
                placeholder.font = UIFont(name: "SFProDisplay-Regular", size: 15)
                placeholder.tag = 1
                self.addSubview(placeholder)
                let layouts = self.layoutMarginsGuide
                placeholder.leadingAnchor.constraint(equalTo: layouts.leadingAnchor, constant: 13).isActive = true
                placeholder.trailingAnchor.constraint(equalTo: layouts.trailingAnchor, constant: 5).isActive = true
                placeholder.topAnchor.constraint(equalTo: layouts.topAnchor, constant: 16).isActive = true*/
                self.text = placeholderSting
                self.textColor = UIColor.init(hexFromString: "666666").withAlphaComponent(0.5)
                self.layoutIfNeeded()
            }
            else
            {
                for view in self.subviews
                {
                    if view.tag == 1
                    {
                        view.removeFromSuperview()
                    }
                }
            }
        }
        
    }*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.layer.cornerRadius = 25
        //self.layer.masksToBounds = true
        //self.layer.borderColor = color.cgColor
        //self.layer.borderWidth = width
        self.attributedPlaceholder = NSAttributedString.init(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(hexFromString: "666666").withAlphaComponent(0.5),NSAttributedString.Key.font:UIFont(name: "SFProDisplay-Regular", size: 15)!])
        self.font = UIFont.init(name: "SFProDisplay-Regular", size: 15)!
        self.contentInset = UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15)
        self.clipsToBounds = true
        
        //self.delegate = self
    }

    /*override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        super.setContentOffset(contentOffset, animated: false)
    }*/
}


extension RDTextView:UITextViewDelegate {
    
    /*func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.placeholderSting && textView.textColor == UIColor.init(hexFromString: "666666").withAlphaComponent(0.5) {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trim().length() == 0 {
            self.text = placeholderSting
            self.textColor = UIColor.init(hexFromString: "666666").withAlphaComponent(0.5)
        }
    }*/

//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let textview = (self.text as NSString).replacingCharacters(in: range, with: text)
//        if textview.count > 0
//        {
//            for view in subviews
//            {
//                if view.tag == 1
//                {
//                    view.isHidden = true
//                }
//            }
//        }
//        else
//        {
//            for view in subviews
//            {
//                if view.tag == 1
//                {
//                    view.isHidden = false
//                }
//            }
//        }
//
//        return true
//    }
}
