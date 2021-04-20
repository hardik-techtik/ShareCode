//
//  User.swift
//  MySchollKinect
//
//  Created by Admin on 03/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

// MARK: - DataClass
struct User:Codable {
    
    var id: Int?
    var firstName, lastName, dateOfBirth, gender: String?
    var relationshipStatus, schoolMajor, schoolMinor, latitude: String?
    var fourDigitPin: String?
    var useFourDigitPin: Int?
    var longitude, expectedGradutionDate, schoolClassigication: String?
    var interest: String?
    var aboutYourself: String?
    var profilePic: String?
    var schoolUniversity, email: String?
    var emailVerifiedAt: String?
    var otp, isVerifiedOtp, age: String?
    var deviceType, status, appleID: String?
    var isActive:Int?
    var schoolID: Int?
    var schoolName:String?
    var schoolusers: [Schooluser]?
    
    static var Token = ""
    
    static var shared = User.init(id: nil, firstName: nil, lastName: nil, dateOfBirth: nil, gender: nil, relationshipStatus: nil, schoolMajor: nil, schoolMinor: nil, latitude: nil, fourDigitPin: nil, useFourDigitPin: nil, longitude: nil, expectedGradutionDate: nil, schoolClassigication: nil, interest: nil, aboutYourself: nil, profilePic: nil, schoolUniversity: nil, email: nil, emailVerifiedAt: nil, otp: nil, isVerifiedOtp: nil, age: nil, deviceType: nil, status: nil, appleID: nil, isActive: nil, schoolID: nil, schoolName:nil, schoolusers: nil)
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case dateOfBirth = "date_of_birth"
        case gender
        case relationshipStatus = "relationship_status"
        case schoolMajor = "school_major"
        case schoolMinor = "school_minor"
        case latitude
        case fourDigitPin = "four_digit_pin"
        case useFourDigitPin = "use_four_digit_pin"
        case longitude
        case expectedGradutionDate = "expected_gradution_date"
        case schoolClassigication = "school_classigication"
        case interest
        case aboutYourself = "about_yourself"
        case profilePic = "profile_pic"
        case schoolUniversity = "school_university"
        case email
        case emailVerifiedAt = "email_verified_at"
        case otp
        case isVerifiedOtp = "is_verified_otp"
        case age
        case deviceType = "device_type"
        case status
        case appleID = "apple_id"
        case isActive = "is_active"
        case schoolID = "school_id"
        case schoolusers
    }
}

struct UserContact : Codable {
    let id,to_user_id, user_id : Int?
    let name,title,number : String?
    let isFollow : Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case to_user_id = "to_user_id"
        case user_id = "user_id"
        case name = "name"
        case title = "title"
        case number = "number"
        case isFollow = "is_follow"
    }
}

struct Schooluser: Codable {
    let id, userID, schoolID: Int?
    let createdAt, updatedAt: String?
    var school: UserSchool?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case schoolID = "school_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case school
    }
    
}


struct AppleUser:Codable {
    
    var userIdentifier:String?
    var fullName:String?
    var email:String?
    var Token:String?
    
    static var shared = AppleUser.init(userIdentifier: nil, fullName: nil, email: nil, Token: nil)
    
}


// MARK: - School
struct UserSchool: Codable {
    let id: Int?
    var firstname, lastname, userID, theNameOfYourSchool: String?
    let schoolMascot, email, phone, city: String?
    let state, zipCode: String?
    let country, address, latitude, longitude: String?
    let createdAt, updatedAt: String?
    
    static var shared = UserSchool.init(id: nil, firstname: nil, lastname: nil, userID: nil, theNameOfYourSchool: nil, schoolMascot: nil, email: nil, phone: nil, city: nil, state: nil, zipCode: nil, country: nil, address: nil, latitude: nil, longitude: nil, createdAt: nil, updatedAt: nil)

    enum CodingKeys: String, CodingKey {
        case id, firstname, lastname
        case userID = "user_id"
        case theNameOfYourSchool = "the_name_of_your_school"
        case schoolMascot = "school_mascot"
        case email, phone, city, state
        case zipCode = "zip_code"
        case country, address, latitude, longitude
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    
}


struct AccountUser:Codable {
    
    var id: Int?
    let firstName, lastName, dateOfBirth, gender: String?
    let relationshipStatus, schoolMajor, schoolMinor, latitude: String?
    let fourDigitPin: String?
    let useFourDigitPin: Int?
    let longitude, expectedGradutionDate, schoolClassigication: String?
    let interest: String?
    let aboutYourself: String?
    let profilePic: String?
    var schoolUniversity, email: String?
    let emailVerifiedAt: String?
    let otp, isVerifiedOtp, age: String?
    let deviceType, status, appleID: String?
    let isActive:String?
    var schoolID: Int?
    let schoolusers: [Schooluser]?
    
    static var Token = ""
    
    static var shared = User.init(id: nil, firstName: nil, lastName: nil, dateOfBirth: nil, gender: nil, relationshipStatus: nil, schoolMajor: nil, schoolMinor: nil, latitude: nil, fourDigitPin: nil, useFourDigitPin: nil, longitude: nil, expectedGradutionDate: nil, schoolClassigication: nil, interest: nil, aboutYourself: nil, profilePic: nil, schoolUniversity: nil, email: nil, emailVerifiedAt: nil, otp: nil, isVerifiedOtp: nil, age: nil, deviceType: nil, status: nil, appleID: nil, isActive: nil, schoolID: nil, schoolusers: nil)
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case dateOfBirth = "date_of_birth"
        case gender
        case relationshipStatus = "relationship_status"
        case schoolMajor = "school_major"
        case schoolMinor = "school_minor"
        case latitude
        case fourDigitPin = "four_digit_pin"
        case useFourDigitPin = "use_four_digit_pin"
        case longitude
        case expectedGradutionDate = "expected_gradution_date"
        case schoolClassigication = "school_classigication"
        case interest
        case aboutYourself = "about_yourself"
        case profilePic = "profile_pic"
        case schoolUniversity = "school_university"
        case email
        case emailVerifiedAt = "email_verified_at"
        case otp
        case isVerifiedOtp = "is_verified_otp"
        case age
        case deviceType = "device_type"
        case status
        case appleID = "apple_id"
        case isActive = "is_active"
        case schoolID = "school_id"
        case schoolusers
    }
}
