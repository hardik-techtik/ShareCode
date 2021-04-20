//
//  PostCommnets.swift
//  MySchollKinect
//
//  Created by Admin on 22/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct PostCommnets: Codable {
    let id, postID, toUserID, fromUserID: Int?
    let comment, createdAt, updatedAt: String?
    let fromuser: [User]?

    enum CodingKeys: String, CodingKey {
        case id
        case postID = "post_id"
        case toUserID = "to_user_id"
        case fromUserID = "from_user_id"
        case comment
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case fromuser
    }
}
