//
//  NIAccountInfo.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 19/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import Foundation

struct NIAccountInfo: Decodable {
    let data: NIAccountData
    let success: Bool
    let status: Int
}

struct NIAccountData: Decodable {
    let id: Int
    let url: String
    let avatar: String
    let avatar_name: String
    let cover: String
    let cover_name: String
    let reputation: Int
    let reputation_name: String
    let created: Int
    let is_blocked: Bool
}
