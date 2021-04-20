//
//  RDTextField.swift
//  MySchollKinect
//
//  Created by Admin on 23/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import IQDropDownTextField

@IBDesignable
class RDTextField: UITextField {
    
    @IBInspectable var leftImage:UIImage?{
        didSet{
            if let image = leftImage{
                self.leftViewMode = .always
                let image = UIImageView.init(image: image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate))
                image.contentMode = .scaleAspectFit
                image.frame = CGRect(x: self.LeftInset, y: 15, width: 20, height: 13)
                self.leftView = image
                self.layoutIfNeeded()
            }
        }
    }

    @IBInspectable var RightImage:UIImage?{
        didSet{
            if let image = RightImage {
                self.rightViewMode = .always
                let image = UIImageView.init(image: image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate))
                image.tintColor = self.tintColor
                image.contentMode = .scaleAspectFit
                image.frame = CGRect(x: self.LeftInset, y: 15, width: 40, height: 15)
                self.rightView = image
                self.layoutIfNeeded()
            }
            
        }
    }
    
    @IBInspectable var LeftInset:CGFloat = 0.0
    {
        didSet
        {
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable var rightInset:CGFloat = 0.0
    {
        didSet
        {
            self.layoutIfNeeded()
        }
    }
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.attributedPlaceholder = NSAttributedString.init(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(hexFromString: "666666").withAlphaComponent(0.5),NSAttributedString.Key.font:UIFont(name: "SFProDisplay-Regular", size: 15)!])
        self.font = UIFont.init(name: "SFProDisplay-Regular", size: 15)!
        //self.layer.cornerRadius = self.frame.height/2
        //self.layer.masksToBounds = true
        //self.layer.borderColor = UIColor.init(hexFromString: "EFEDF7").cgColor
        //self.layer.borderWidth = 1
        self.autocapitalizationType = .words
    }

    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 0, left: LeftInset, bottom: 0, right: rightInset))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 0, left: LeftInset, bottom: 0, right: rightInset))
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 0, left: LeftInset, bottom: 0, right: rightInset))
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var Rect = super.rightViewRect(forBounds: bounds)
        Rect.origin.x = Rect.origin.x - 15
        return Rect
    }

}

@IBDesignable
class RDTextFieldDropDown : IQDropDownTextField {
    
    @IBInspectable var LeftInset:CGFloat = 0.0
    {
        didSet
        {
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable var rightInset:CGFloat = 0.0
    {
        didSet
        {
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable var RightImage:UIImage?{
        didSet{
            if let image = RightImage {
                self.rightViewMode = .always
                let image = UIImageView.init(image: image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate))
                image.tintColor = self.tintColor
                image.contentMode = .scaleAspectFit
                image.frame = CGRect(x: self.LeftInset, y: 15, width: 40, height: 15)
                self.rightView = image
                self.layoutIfNeeded()
            }
            
        }
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 0, left: LeftInset, bottom: 0, right: rightInset))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 0, left: LeftInset, bottom: 0, right: rightInset))
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 0, left: LeftInset, bottom: 0, right: rightInset))
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var Rect = super.rightViewRect(forBounds: bounds)
        Rect.origin.x = Rect.origin.x - 15
        return Rect
    }
}


protocol RDSearchTextFieldDelegate:class {
    func textFieldDidBeginEditing(_ textField: UITextField)
    func textFieldDidEndEditing(_ textField: UITextField)
}


class RDSearchTextField: UITextField{
    
    @IBInspectable var leftImage:UIImage?{
        didSet{
            if let image = leftImage {
                self.leftViewMode = .always
                let image = UIImageView.init(image: image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate))
                image.contentMode = .scaleAspectFit
                image.frame = CGRect(x: self.LeftInset, y: 15, width: 20, height: 13)
                self.leftView = image
                self.layoutIfNeeded()
            }
        }
    }

    @IBInspectable var RightImage:UIImage?{
        didSet{
            if let image = RightImage {
                self.rightViewMode = .unlessEditing
                let image = UIImageView.init(image: image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate))
                image.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(closeSelection(_:))))
                self.rightView?.isUserInteractionEnabled = true
                image.tintColor = self.tintColor
                image.contentMode = .scaleAspectFit
                image.frame = CGRect(x: self.LeftInset, y: 15, width: 40, height: 15)
                self.rightView = image
                self.layoutIfNeeded()
            }
        }
    }
    
     weak var Delegate:RDSearchTextFieldDelegate?
    
    
    @IBInspectable var LeftInset:CGFloat = 0.0
    {
        didSet
        {
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable var rightInset:CGFloat = 0.0
    {
        didSet
        {
            self.layoutIfNeeded()
        }
    }
    
    @objc func closeSelection(_ button:UIButton){
        self.text = nil
        
        for view in subviews ?? []
        {
            if view.tag == 1
            {
                view.removeFromSuperview()
            }
        }
        RightImage = UIImage.init(named: "Serch Blue")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.attributedPlaceholder = NSAttributedString.init(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(hexFromString: "111111"),NSAttributedString.Key.font:UIFont(name: "SFProDisplay-Regular", size: 15)!])
        //self.layer.cornerRadius = self.frame.height/2
        //self.layer.masksToBounds = true
        //self.layer.borderColor = UIColor.init(hexFromString: "EFEDF7").cgColor
        //self.layer.borderWidth = 1
        //self.tintColor = UIColor.init(hexFromString: "000000")
        delegate = self
    }

    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 0, left: LeftInset, bottom: 0, right: rightInset))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 0, left: LeftInset, bottom: 0, right: rightInset))
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 0, left: LeftInset, bottom: 0, right: rightInset))
    }
    
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var Rect = super.rightViewRect(forBounds: bounds)
        Rect.origin.x = Rect.origin.x - 15
        return Rect
    }
    
}

extension RDSearchTextField: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                let text = (textField.text as? NSString)?.replacingCharacters(in: range, with: string)
        if (text?.count ?? 0) > 0
        {
            //self.RightImage = UIImage.init(named: "Close")
            let Closebutton = UIButton.init(frame: self.rightViewRect(forBounds: self.bounds))
            Closebutton.addTarget(self, action: #selector(self.closeSelection(_:)), for: .touchUpInside)
            Closebutton.tag = 1
            //self.addSubview(Closebutton)
        }
        else{
            self.RightImage = UIImage.init(named: "Serch Blue")
            for view in subviews ?? []
            {
                if view.tag == 1
                {
                    view.removeFromSuperview()
                }
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.Delegate?.textFieldDidBeginEditing(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.Delegate?.textFieldDidEndEditing(textField)
    }
}
