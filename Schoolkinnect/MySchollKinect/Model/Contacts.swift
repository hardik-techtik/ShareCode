//
//  Contacts.swift
//  MySchollKinect
//
//  Created by Admin on 13/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct Contacts: Codable {
    let statusCode: Int
    let data: [Datum]

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

// MARK: - Datum
struct Datum: Codable {
    let id, toUserID, userID: Int
    let name: String
    let title, number: String
    let isFollow: Int
    let createdAt, updatedAt: String
    let userMember: [UserMember]

    enum CodingKeys: String, CodingKey {
        case id
        case toUserID = "to_user_id"
        case userID = "user_id"
        case name, title, number
        case isFollow = "is_follow"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userMember = "user_member"
    }
}

// MARK: - UserMember
struct UserMember: Codable {
    let id: Int
    let firstName, lastName, dateOfBirth, gender: String
    let relationshipStatus, schoolMajor, schoolMinor: String
    let latitude: String
    let fourDigitPin: String
    let useFourDigitPin: Int
    let longitude: String
    let expectedGradutionDate, schoolClassigication: String
    let interest: String
    let aboutYourself: String
    let profilePic: String
    let schoolUniversity, email: String
    let emailVerifiedAt: String
    let otp, isVerifiedOtp, age: String
    let deviceType, status, appleID: String
    let isActive: Int
    let name: String
    let schoolpostCount, schooleventCount, schoolID: Int

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
        case name
        case schoolpostCount = "schoolpost_count"
        case schooleventCount = "schoolevent_count"
        case schoolID = "school_id"
    }
}
