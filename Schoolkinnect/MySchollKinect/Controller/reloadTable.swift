//
//  reloadTable.swift
//  MySchollKinect
//
//  Created by Admin on 04/06/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol refreshProtocol:class {
    func didRefresh(tableView:UITableView)
}

class reloadTable: UITableView {
    
    
    weak var RefresgDelegete:refreshProtocol?

    let refresh = UIRefreshControl.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
    override func awakeFromNib() {
        super.awakeFromNib()
        self.refreshControl = refresh
        refresh.addTarget(self, action: #selector(Refresh), for: .valueChanged)
    }
    
    @objc func Refresh()
    {
        self.RefresgDelegete?.didRefresh(tableView: self)
    }
    
}
