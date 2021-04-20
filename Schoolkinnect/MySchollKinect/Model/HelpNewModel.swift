//
//  HelpNewModel.swift
//  MySchollKinect
//
//  Created by Pritesh on 27/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class HelpNewModel {
    var id = Int()
    var answer = ""
    var created_at = ""
    var question = ""
    var updated_at = ""
    
    init() {}
    init(json : [String: Any]) {
        self.id = (json["id"] as? Int)!
        self.answer = (json["answer"] as? String)!
        
        self.created_at = (json["created_at"] as? String)!
        self.question = (json["question"] as? String)!
        self.updated_at = (json["updated_at"] as? String)!
    }
}
