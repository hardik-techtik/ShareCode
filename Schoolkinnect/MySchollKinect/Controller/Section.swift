//
//  Section.swift
//  ExpandableTableView
//
//  Created by Pratik Lad on 01/01/18.
//  Copyright © 2018 Pratik Lad. All rights reserved.
//

import Foundation
class Section {
    var title : String?
    var list : [String]?
    var isColleps : Bool?
    init() {
    }
    
    init(title : String? , list : [String]?, isColleps : Bool?) {
        self.title = title
        self.list = list
        self.isColleps = isColleps
    }
}
class QuizModel {
    var title : String?
    var list : [String]?
    var answer : String?
    var SelectedAnswer : String?
    init() {
    }
    
    init(title : String? , list : [String]?, answer : String?, SelectedAnswer : String?) {
        self.title = title
        self.list = list
        self.answer = answer
        self.SelectedAnswer = SelectedAnswer
    }
}
class AddQualificaionModel {
    var title : String?
    var isDeleted : Bool?
    var isAdded : Bool?
    init() {
    }
    init(title : String? , isDeleted : Bool?, isAdded : Bool?) {
        self.title = title
        self.isDeleted = isDeleted
        self.isAdded = isAdded
    }
}
class AddExperienceModel {
    var companyName : String?
    var expyear : String?
    var isAdded : Bool?
    init() {
    }
    init(companyName : String? , expyear : String?, isAdded : Bool?) {
        self.companyName = companyName
        self.expyear = expyear
        self.isAdded = isAdded
    }
}
class AddLanguageModel {
    var langauge : String?
    var proficiency : String?
    var isAdded : Bool?
    init() {
    }
    init(langauge : String? , proficiency : String?, isAdded : Bool?) {
        self.langauge = langauge
        self.proficiency = proficiency
        self.isAdded = isAdded
    }
}
class AddExtraModel {
    var accessories : String?
    var price : String?
    var isAdded : Bool?
    init() {
    }
    init(accessories : String? , price : String?, isAdded : Bool?) {
        self.accessories = accessories
        self.price = price
        self.isAdded = isAdded
    }
}
