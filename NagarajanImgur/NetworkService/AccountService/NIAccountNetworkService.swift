//
//  NIAccountNetworkService.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 18/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import Foundation

class NIAccountNetworkService: NIBaseURLRequest {
    static func fetchAccessToken(usingUrlString urlString: String, parameters: [String: Any], completionHandler: @escaping(NIWebReponseCompletionBlock)) {
        guard let request = self.constructRequest(withURLString: urlString, parameters: parameters, methodType: .post, addClientIDHeader: false, addAuthorizationHeader: false) else {
            completionHandler("", "Something went wrong")
            return
        }
        NINetworkService.makeRequest(request) { (data, error) in
            self.parseResponse(data: data, error: error, completionHandler: completionHandler)
        }
    }
    
    static func fetchAccountInfo(usingUrlString urlString: String, completionHandler: @escaping(NIWebReponseCompletionBlock)) {
        guard let request = self.constructRequest(withURLString: urlString, parameters: [String: Any](), methodType: .get, addClientIDHeader: false, addAuthorizationHeader: true) else {
            completionHandler("", "Something went wrong")
            return
        }
        NINetworkService.makeRequest(request) { (data, error) in
            self.parseResponse(data: data, error: error, completionHandler: completionHandler)
        }
    }
    
    static func fetchAccountSettings(usingUrlString urlString: String, parameters: [String: Any], completionHandler: @escaping(NIWebReponseCompletionBlock)) {
        guard let request = self.constructRequest(withURLString: urlString, parameters: parameters, methodType: .get, addClientIDHeader: false, addAuthorizationHeader: true) else {
            completionHandler("", "Something went wrong")
            return
        }
        NINetworkService.makeRequest(request) { (data, error) in
            self.parseResponse(data: data, error: error, completionHandler: completionHandler)
        }
    }
}
