//
//  NIGallaryNetworkService.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 19/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import Foundation

class NIGallaryNetworkService: NIBaseURLRequest {
    static func fetchGallary(usingUrlString urlString: String, parameters: [String: Any], completionHandler: @escaping(NIWebReponseCompletionBlock)) {
        guard let request = self.constructRequest(withURLString: urlString, parameters: parameters, methodType: .get, addClientIDHeader: true, addAuthorizationHeader: false) else {
            completionHandler("", "Something went wrong")
            return
        }
        NINetworkService.makeRequest(request) { (data, error) in
            self.parseResponse(data: data, error: error, completionHandler: completionHandler)
        }
    }
}
