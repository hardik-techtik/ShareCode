//
//  SchoolPolls.swift
//  MySchollKinect
//
//  Created by Admin on 08/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct Schoolpolls: Codable {
    let id: Int?
    let schoolID : String?
    let userID, datumDescription: String?
    let pollPicture: String?
    let createdAt, updatedAt, status: String?
    var likesCount, dislikesCount: Int?
    let schoolPollName: String?
    let pollcommentCount: Int?
    let UserLike:Bool?
    let UserDisLike:Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case schoolID = "school_id"
        case datumDescription = "description"
        case pollPicture = "poll_picture"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status
        case likesCount = "likes_count"
        case dislikesCount = "dislikes_count"
        case schoolPollName = "school_poll_name"
        case pollcommentCount = "pollcomment_count"
        case UserLike = "user_likes"
        case UserDisLike = "user_dislikes"
    }
}

struct SchoolpollsLikeUnlike: Codable {
    let id: Int?
    let userID: Int?
    let schooID: String?
    let datumDescription: String?
    let pollPicture : String?
    var comment:String?
    var like:Int?
    var dislike: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case schooID = "schoo_id"
        case datumDescription = "description"
        case pollPicture = "poll_picture"
        case comment
        case like = "like"
        case dislike = "dislike"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


struct PollCreated: Codable {
    let dataDescription: String?
    let userID: Int?
    let updatedAt, createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case dataDescription = "description"
        case userID = "user_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
