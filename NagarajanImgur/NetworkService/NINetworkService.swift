//
//  NINetworkService.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 18/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import Foundation

typealias NIWebRequestCompletionBlock = (_ result: Data?, _ error: NSError?) -> Void
typealias NIWebReponseCompletionBlock = (_ responseString: String, _ errorMessage: String) -> Void

class NINetworkService {
    static let shared = NINetworkService()
    private var unsatisfiedRequests: [[String : Any]]
    private var urlSession: URLSession
    private init() {
        unsatisfiedRequests = [[String : Any]]()
        let completionQueue = OperationQueue.main
        let configuration = URLSessionConfiguration.default
        urlSession = URLSession.init(configuration: configuration, delegate: nil, delegateQueue: completionQueue)
    }
    
    static func makeRequest(_ request: URLRequest, completionHandler: @escaping(NIWebRequestCompletionBlock)) {
        DispatchQueue.global(qos: .background).async {
            let dataTask = NINetworkService.shared.urlSession.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    if 200 >= response.statusCode && response.statusCode <= 299 {
                        completionHandler(data, nil)
                    }else if 401 == response.statusCode {
                        /// fetch token using lock
                        /// on successful completion retry all unsatisfied request
                        /// on failure completion logout
                        ///storing the request details for future use.
                        NINetworkService.shared.addUnsatisfiedRequest(request, completionHandler: completionHandler)
                    }else {
                        ///Other errors are not related to session invalidation. So finish completionblock by calling back
                        var errorInfo: [String : Any] = [:]
                        if let data = data,
                            let responseString = String(data: data, encoding: .utf8) {
                            errorInfo[NSLocalizedDescriptionKey] = responseString
                        }
                        if let urlString = request.url?.absoluteString {
                            errorInfo[NSURLErrorFailingURLErrorKey] = urlString
                        }
                        let error = NSError(domain: NSURLErrorDomain, code: response.statusCode, userInfo: errorInfo)
                        completionHandler(nil, error)
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func addUnsatisfiedRequest(_ request: URLRequest, completionHandler: @escaping(NIWebRequestCompletionBlock)) {
        var requestInfo: [String : Any] = [:]
        requestInfo["request"] = request
        requestInfo["completionBlock"] = completionHandler
        unsatisfiedRequests.append(requestInfo)
    }
    
    func retryAllUnsatisfiedRequests() {
        for i in 0..<unsatisfiedRequests.count {
            let requestInfo = unsatisfiedRequests[i]
            if let oldRequest = requestInfo["request"] as? URLRequest,
                let newRequest = getRequestWithNewSessionInfo(fromOldRequest: oldRequest),
                let completionBlock = requestInfo["completionBlock"] as? NIWebRequestCompletionBlock
            {
                NINetworkService.makeRequest(newRequest, completionHandler: completionBlock)
            }
            
        }
        unsatisfiedRequests.removeAll()
    }
    
    func failAllUnsatisfiedRequests() {
        for i in 0..<unsatisfiedRequests.count {
            let requestInfo = unsatisfiedRequests[i]
            let request = requestInfo["request"] as? URLRequest
            let completionBlock = requestInfo["completionBlock"] as? NIWebRequestCompletionBlock
            var errorInfo: [String : Any] = [:]
            errorInfo[NSLocalizedDescriptionKey] = "Session creation failure"
            if let urlString = request?.url?.absoluteString {
                errorInfo[NSURLErrorFailingURLErrorKey] = urlString
            }
            let error = NSError(domain: NSURLErrorDomain, code: 403, userInfo: errorInfo)
            completionBlock?(nil, error)
        }
        unsatisfiedRequests.removeAll()
    }

    func getRequestWithNewSessionInfo(fromOldRequest oldRequest: URLRequest?) -> URLRequest? {
        var newRequest: URLRequest? = nil
        if let url = oldRequest?.url {
            newRequest = URLRequest.init(url: url)
        }
        if oldRequest?.httpBody != nil {
            newRequest?.httpBody = oldRequest?.httpBody
        }
        let allHeaderFields = oldRequest?.allHTTPHeaderFields
        if allHeaderFields?["Authorization"] != nil {
            //[newRequest setValue:newAuthValue forHTTPHeaderField:@"Authorization"];
        }

        let contentLength = allHeaderFields?["Content-Length"]
        if contentLength != nil {
            newRequest?.setValue(contentLength, forHTTPHeaderField: "Content-Length")
        }

        let contentType = allHeaderFields?["Content-Type"]
        if contentType != nil {
            newRequest?.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }


        newRequest?.httpMethod = oldRequest?.httpMethod ?? ""
        if let newRequest = newRequest {
            print("request renewed \(newRequest)")
        }
        return newRequest
    }
}

