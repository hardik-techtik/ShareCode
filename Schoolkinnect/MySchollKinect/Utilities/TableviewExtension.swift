//
//  TableviewExtension.swift
//  MySchollKinect
//
//  Created by Pritesh on 15/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
extension UITableView {
    func setEmptyView(title: String = "", message: String , image:UIImage? = nil) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let titleLabel = UILabel()
        
        let messageLabel = UILabel()
        
        let noDataImage = UIImageView()
        
        
        noDataImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        
        emptyView.addSubview(noDataImage)
        
        emptyView.addSubview(messageLabel)
        emptyView.addSubview(titleLabel)
        
        if image == nil{
            titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        }else{
            titleLabel.isHidden = true
            noDataImage.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
            noDataImage.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
            messageLabel.topAnchor.constraint(equalTo: noDataImage.bottomAnchor, constant: 20).isActive = true
        }
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        
        titleLabel.text = title
        
        messageLabel.text = message
        noDataImage.image = image
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
    func reloadTableview(){
        self.reloadData()
        if self.numberOfRows(inSection: 1) == 0 {
        }
    }
}
