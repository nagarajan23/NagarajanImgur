//
//  NIGallaryModel.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 19/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import Foundation

struct NIGallaryModel: Decodable {
    let data: [NIGallaryMemeModel]
    let success: Bool
    let status: Int
}

struct NIGallaryMemeModel: Decodable {
    let id: String
    let title: String
    let description: String?
    let cover: String?
    let cover_width: Int?
    let cover_height: Int?
    let account_url: String?
    let account_id: Int?
    let views: Int?
    let link: String?
    let ups: Int?
    let downs: Int?
    let points: Int?
    let score: Int?
    let comment_count: Int?
    let favorite_count: Int?
    let tags: [NIGallaryTagModel]?
    let images:[NIGallaryImageModel]?
}

struct NIGallaryTagModel: Decodable {
    let name: String?
    let display_name: String?
    let followers: Int?
    let total_items: Int?
    let background_hash: String?
    let accent: String?
    let description: String?
}

struct NIGallaryImageModel: Decodable {
    let id: String
    let title: String?
    let description: String?
    let type: String?
    let width: Int?
    let height: Int?
    let link: String?
}
