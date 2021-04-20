//
//  StringExtension.swift
//  Wela
//
//  Created by Tai Le on 8/9/16.
//  Copyright © 2016 Wela. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}


extension String {
    static let dayOptions = [NSLocalizedString("Last 90 days", comment: ""),
                             NSLocalizedString("Last 30 days", comment: ""),
                             NSLocalizedString("Last 3 months", comment: ""),
                             NSLocalizedString("Last 6 months", comment: ""),
                             NSLocalizedString("Last 12 months", comment: ""),
                             NSLocalizedString("Last 24 months", comment: "")]
    static let AllCountryCodes = ["93","355","213","1","376","244","54","374","297","247","61","43","994","973",
                                  "880","375","32","501","229","975","591","387","267","55","673","359","226",
                                  "257","855","237","238","236","235","56","86","57","269","242","682","506",
                                  "385","53","599","357","420","243","45","246","253","670","593","20","503",
                                  "240","291","372","251","500","298","679","358","33","594","689","241","220",
                                  "995","49","233","350","30","299","590","502","224","245","592","509",
                                  "504","852","36","354","91","62","870","98","964","353","8810","8811",
                                  "8812","8813","8816","8817","8818","8819","972","39","225","81","962","7",
                                  "254","686","965","996","856","371","961","266","231","218","423","370","352",
                                  "853","389","261","265","60","960","223","356","692","596","222","230","262",
                                  "52","691","373","377","976","382","212","258","95","264","674","977","31",
                                  "687","64","505","227","234","683","6723","850","47","968","92","680","970",
                                  "507","675","595","51","63","48","351","974","40","250","290","508","685",
                                  "378","239","966","221","381","248","232","65","421","386","677","252","27",
                                  "82","211","34","94","249","597","268","46","41","963","886","992","255",
                                  "66","882","228","690","676","216","90","993","688","256","380","971","44",
                                  "598","998","678","379","58","84","681","967","260","263"]
    
    func stringNumberOnly(defaultVal: String = "", stringFilter: String = "0123456789.") -> String {
        let filter   = NSCharacterSet(charactersIn: stringFilter)
        let stringArray = self.components(
            separatedBy: filter.inverted)
        let newString = stringArray.joined(separator: "")
        
        if newString.trim().length() == 0 {return defaultVal}
        
        if self.hasPrefix("-") {
            return "-" + newString
        }
        
        return newString
    }
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    func length() -> Int {
        return self.count
    }
    
    func stringPercent() -> String {
        var numberOnly = self.stringNumberOnly()
        
        if let intStr = Int(numberOnly) {
            if intStr > 100 {
                numberOnly = "100"
            } else if intStr < 0 {
                numberOnly = "0"
            }
        }
        
        return numberOnly
    }
    
    func stringPercentFloat() -> String {
        var numberOnly = self.stringNumberOnly(defaultVal: "0", stringFilter: "0123456789.-")
        
        if let intStr = Float(numberOnly) {
            if intStr >= 0 {
                numberOnly = "+" + numberOnly
            }
        }
        
        return numberOnly + "%"
    }
    
    
    
    func encodeUrl() -> String {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    func encodeBlank() -> String {
        return replacingOccurrences(of: " ", with: "+")
    }
    
    func isEqualString(_ string: String?) -> Bool {
        guard string != nil else { return false }
        return compare(string!) == .orderedSame
    }
    
    func substringToIndex(_ index: Int) -> String {
        
        if index < 0
        {
            return ""
        }
        
        return (self as NSString).substring(to: index)
    }
    
    func substringFromIndex(_ index: Int) -> String {
        return (self as NSString).substring(from: index)
    }
    
    func rangeOfString(_ string: String) -> NSRange {
        return (self as NSString).range(of: string)
    }
    
    func isBlank() -> Bool {
        return self.trim().length() == 0
    }
    
    func isContainSpaces() -> Bool {
        return self.contains(" ")
    }
    
    
    
    func isValidFullName() -> Bool {
        return trim().components(separatedBy: " ").count > 1
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func percentEscapeString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    
    func isAValidEmail() -> Bool {
        let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    
    func isAValidPassword(text:String) -> Bool {
        if text.count < 8 || text .contains("") {
            return false
        } else {
            return true
        }
    }
    
    func notValidPhoneNumber() -> Bool {
        
        let numberRegEx  = "[0]{0,10}"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: self)
        
        return containsNumber
    }
    
    func notValidAge() -> Bool {
        
        let numberRegEx  = "[0]{0,4}"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: self)
        
        return containsNumber
    }
    
    func notValidWeight() -> Bool {
        
        let numberRegEx  = "[0]{0,3}"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: self)
        
        return containsNumber
    }
    
    // Mark: - phone number formatting -
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func formattedAge(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XX.XX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func formatToPhoneNumberCheckAddPlus() -> String {
        // (123) 456
        if (self.length() < 7) {
            return (self as NSString).replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: NSMakeRange(0, self.length()))
        }
            // (123) 456-7890
        else if self.length() < 11 {
            return (self as NSString).replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: NSMakeRange(0, self.length()))
        }
        
        // +12-34-567-890123
        return (self as NSString).replacingOccurrences(of: "(\\d{2})(\\d{2})(\\d{3})(\\d+)", with: "+$1-$2-$3-$4", options: .regularExpression, range: NSMakeRange(0, self.length()))
    }
    
    static func emptyStringIfNil(_ string: String?) -> String {
        guard string != nil else { return "" }
        return string!
    }
    
    func toFloat() -> Float!
    {
        let floatValue :Float? = Float(self)
        
        if floatValue == nil
        {
            return 0
        }
        return floatValue
    }
    
    func toInt() -> Int!
    {
        let intValue :Int? = Int(self)
        
        if intValue == nil
        {
            return 0
        }
        return intValue
    }
    
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
    
    func capitalizingFirstLetter() -> String {
        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func urlValue() -> URL {
        return URL(string: self)!
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func toDateTime() -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateFromString : Date = dateFormatter.date(from: self)! as Date
        return dateFromString
    }
    func decodeUrl() -> String
    {
        return self.removingPercentEncoding ?? ""
    }
}
