//
//  NIKeyChain.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 18/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

protocol NIKeyChainProtocol {
    func saveValueInKeyChain(_ value: String, forKey key: String) -> Bool
    func readValueFromKeyChain(forKey key: String) -> String?
    func removeValueFromKeyChain(forKey key: String) -> Bool
    func removeAllValuesFromKeyChain()
    func getAccessToken() -> (String?, String?)
}

extension NIKeyChainProtocol {
    @discardableResult
    func saveValueInKeyChain(_ value: String, forKey key: String) -> Bool {
        return KeychainWrapper.standard.set(value, forKey: key)
    }
    
    func readValueFromKeyChain(forKey key: String) -> String? {
        return KeychainWrapper.standard.string(forKey: key)
    }
    
    @discardableResult
    func removeValueFromKeyChain(forKey key: String) -> Bool {
        return KeychainWrapper.standard.removeObject(forKey: key)
    }
    
    func removeAllValuesFromKeyChain() {
        KeychainWrapper.standard.removeAllKeys()
    }
    
    func getAccessToken() -> (String?, String?) {
        let accessToken = self.readValueFromKeyChain(forKey: ACCESS_TOKEN_KEY)
        let refreshToken = self.readValueFromKeyChain(forKey: REFRESH_TOKEN_KEY)
        return (accessToken, refreshToken)
    }
}
