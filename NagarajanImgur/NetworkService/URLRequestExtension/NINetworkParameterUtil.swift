//
//  NINetworkParameterUtil.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 18/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import Foundation

extension URLRequest: NIKeyChainProtocol {
    mutating func appendInfoInHttpBody(_ info: [String : Any]?) {
        var data: Data?
        if let info = info {
            do {
                data = try JSONSerialization.data(withJSONObject: info, options: [])
                httpBody = data
            } catch {
            }
        }
        setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    mutating func appendClientIDHeader() {
        setValue("Client-ID \(CLIENT_ID)", forHTTPHeaderField: "Authorization")
    }
    
    mutating func appendAuthorizationHeader() {
        if let accessToken = self.readValueFromKeyChain(forKey: ACCESS_TOKEN_KEY) {
            setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
    }
}
