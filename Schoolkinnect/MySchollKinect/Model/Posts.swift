//
//  Posts.swift
//  MySchollKinect
//
//  Created by Admin on 13/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct Posts: Codable {
    let id, schoolID, userID: Int?
    let name: String?
    let title, descriptionOfPost: String?
    let postPicture: String?
    let postVideo: String?
    let message: String?
    let createdAt, updatedAt: String?
    let status: String?
    var likesCount, dislikesCount: Int?
    let schoolPostName: String?
    let postcommentCount: Int?
    let userPostPhotos, userPostVideos: [UserPost]?
    var UserLiked:Bool?
    let ProfilePic : String?
    let user:User?
    var intPostID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case intPostID
        case schoolID = "school_id"
        case userID = "user_id"
        case name, title
        case descriptionOfPost = "description_of_post"
        case postPicture = "post_picture"
        case postVideo = "post_video"
        case message
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status
        case likesCount = "likes_count"
        case dislikesCount = "dislikes_count"
        case schoolPostName = "school_post_name"
        case postcommentCount = "postcomment_count"
        case userPostPhotos = "user_post_photos"
        case userPostVideos = "user_post_videos"
        case UserLiked = "user_likes"
        case ProfilePic = "profile_pic"
        case user
    }
}

struct ShareVideo: Codable {
    let id,userId,schoolId,video_count : Int?
    let strVideo : String?
    let description: String?
    let thumbnail_image: String?
    let users : [User]?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case schoolId = "school_id"
        case strVideo = "video"
        case users = "user"
        case description = "description"
        case video_count = "video_count"
        case thumbnail_image = "thumbnail_image"
    }
    
}

struct UserPost: Codable {
    let id, userID: Int?
    let path: String?
    let postID: Int?
    let schoolID: Int?
    let eventID: Int?
    let type, createdAt, updatedAt, thumbnail_image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case path
        case postID = "post_id"
        case schoolID = "school_id"
        case eventID = "event_id"
        case type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case thumbnail_image = "thumbnail_image"
    }
}


struct AddPosts: Codable {
    let id, userID : Int?
    let schoolID: String?
    let name, title, descriptionOfPost: String?
    let postPicture: String?
    let message, createdAt, updatedAt: String?
    //let likesCount, dislikesCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case schoolID = "school_id"
        case userID = "user_id"
        case name, title
        case descriptionOfPost = "description_of_post"
        case postPicture = "post_picture"
        case message
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        //case likesCount = "likes_count"
        //case dislikesCount = "dislikes_count"
    }
}

struct EditPosts: Codable {
    let id, userID : Int?
    let schoolID: Double?
    
    //let likesCount, dislikesCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case schoolID = "school_id"
        case userID = "user_id"
    }
}

struct AddEvent: Codable {
    let id,userID : Int?
    let schoolID : String?
    
    enum CodingKeys : String, CodingKey {
        case id
        case userID = "user_id"
        case schoolID = "school_id"
    }
}

struct events: Codable {
    
    let id: Int?
    let userID, schoolID, eventName, eventTime: String?
    let eventLocation: String?
    let eventPicture, eventVideo: String?
    let message: String?
    let latitude, longitude: String?
    let createdAt, updatedAt, status, schoolEventName: String?
    let userEventPhotos, userEventVideos: [UserPost]?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case schoolID = "school_id"
        case eventName = "event_name"
        case eventTime = "event_time"
        case eventLocation = "event_location"
        case eventPicture = "event_picture"
        case eventVideo = "event_video"
        case message, latitude, longitude
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status
        case schoolEventName = "school_event_name"
        case userEventPhotos = "user_event_photos"
        case userEventVideos = "user_event_videos"
    }
}


struct PostLike: Codable {
    let userID: Int?
    let postID: Int?
    let like: Int?
    let updatedAt, createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case postID = "post_id"
        case like
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
