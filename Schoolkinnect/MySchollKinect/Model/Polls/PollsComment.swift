//
//  Polls Comment.swift
//  MySchollKinect
//
//  Created by Admin on 09/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
struct PollsComment: Codable {
    let id, pollID: Int?
    let toUserID: Int?
    let fromUserID: Int?
    let comment, createdAt, updatedAt: String?
    let fromuser: [User]?

    enum CodingKeys: String, CodingKey {
        case id
        case pollID = "poll_id"
        case toUserID = "to_user_id"
        case fromUserID = "from_user_id"
        case comment
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case fromuser
    }
}

struct TrendingPost: Codable {
    let id, user_id: Int?
    let post_id, school_id: String?

    enum CodingKeys: String, CodingKey {
        case id
        case user_id = "user_id"
        case post_id = "post_id"
        case school_id = "school_id"
    }
}



