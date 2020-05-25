//
//  NIBaseURLRequest.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 18/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import Foundation

enum NIHTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class NIBaseURLRequest: NSObject {
    private static func constructRequestWithURLString(_ urlString: String, parameters: [String : Any]?, httpMethodType: NIHTTPMethod, addClientIDHeader: Bool, addAuthorizationHeader: Bool) -> URLRequest? {
        var request: URLRequest?
        
        switch httpMethodType {
            case .get:
                request = self.constructGETRequest(urlString, parameters: parameters)
            case .post:
                request = self.constructPOSTRequest(urlString, parameters: parameters)
            default:
                request = self.constructGETRequest(urlString, parameters: parameters)
        }
        request?.httpMethod = httpMethodType.rawValue
        if addClientIDHeader {
            request?.appendClientIDHeader()
        }
        if addAuthorizationHeader {
            request?.appendAuthorizationHeader()
        }
        return request
    }
    
    private static func constructGETRequest(_ urlString: String, parameters: [String : Any]?) -> URLRequest? {
        if let urlString = self.absoluteURLStringFrom(urlString: urlString, parameters: parameters ?? [String: Any]()), let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    private static func constructPOSTRequest(_ urlString: String, parameters: [String : Any]?) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        if let param = parameters {
            request.appendInfoInHttpBody(param)
        }
        return request
    }
    
    static func constructRequest(withURLString urlString: String, parameters: [String : Any], methodType httpMethodType: NIHTTPMethod, addClientIDHeader: Bool, addAuthorizationHeader: Bool) -> URLRequest? {
        return constructRequestWithURLString(urlString, parameters: parameters, httpMethodType: httpMethodType, addClientIDHeader: addClientIDHeader, addAuthorizationHeader: addAuthorizationHeader)
    }
    
    /// URL string with query parameter
    static func absoluteURLStringFrom(urlString: String, parameters: [String : Any]) -> String? {
        guard let param = parameters as? [String : String] else { return nil }
        var components = URLComponents(string: urlString)
           components?.queryItems = param.map { element in URLQueryItem(name: element.key, value: element.value) }
           return components?.url?.absoluteString
    }
    
    /// Reponse Data Parser
    static func parseResponse(data: Data?, error: Error?, completionHandler: @escaping(NIWebReponseCompletionBlock)) {
        if let data = data {
            let responseString = NIParseResponse.parseDataResponse(data)
            completionHandler(responseString, "")
            return
        }
        
        if let error = error {
            let errorMessage = NIParseResponse.parseErrorResponse(error)
            completionHandler("", errorMessage)
            return
        }
        
        completionHandler("", "Something went wrong")
    }
}
