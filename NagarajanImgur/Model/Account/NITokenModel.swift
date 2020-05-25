//
//  NITokenModel.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 18/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import Foundation

struct NITokenModel: Decodable {
    let account_id: Int
    let account_username: String
    let token_type: String
    let refresh_token: String
    let access_token: String
}

//MARK:- Key Chain Protocol Conform
extension NITokenModel: NIKeyChainProtocol {
    func saveInKeyChain() {
        self.saveValueInKeyChain(self.access_token, forKey: ACCESS_TOKEN_KEY)
        self.saveValueInKeyChain(self.refresh_token, forKey: REFRESH_TOKEN_KEY)
    }
}
