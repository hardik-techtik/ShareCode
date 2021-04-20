//
//  ExpandableCells.swift
//  ExpandableCell
//
//  Created by sumit singh
//  Copyright © 2018 sumit singh. All rights reserved.
//

import UIKit
import ExpandableCell


class NormalCell: UITableViewCell {
    static let ID = "NormalCell"
}

class ExpandableCell2: ExpandableCell {
    static let ID = "ExpandableCell"
    @IBOutlet weak var titleLable: UILabel!
}
class ExpandableSelectableCell2: ExpandableCell {
    static let ID = "ExpandableSelectableCell2"

    override func isSelectable() -> Bool {
        return true
    }
}

class ExpandableInitiallyExpanded: ExpandableCell {
    static let ID = "InitiallyExpandedExpandableCell"
    
    override func isSelectable() -> Bool {
        return true
    }
    
    override func isInitiallyExpanded() -> Bool {
        return true
    }
}

class ExpandedCell: UITableViewCell {
    static let ID = "ExpandedCell"
    
    @IBOutlet var titleLabel: UILabel!
}
