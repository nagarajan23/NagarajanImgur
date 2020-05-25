//
//  NIParseResponse.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 18/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import Foundation

class NIParseResponse {
    static func parseDataResponse(_ data: Data?) -> String {
        guard let data = data else {
            return ""
        }
        do {
            let responseDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8) ?? ""
        } catch let error {
            return error.localizedDescription
        }
    }
    
    static func parseErrorResponse(_ error: Error?) -> String {
        guard let error = error else {
            return "Something went wrong"
        }
        return error.localizedDescription
    }
}
