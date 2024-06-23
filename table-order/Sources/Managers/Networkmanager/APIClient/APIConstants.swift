//
//  APIConstants.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import Foundation

struct APIConstants {
    
    static var endpoint: String {
        let endpoint = Bundle.main.object(forInfoDictionaryKey: "Endpoint") as! String
        return endpoint
    }
    
    enum HTTPHeader: String {
        case contentType = "Content-Type"
        case acceptType = "Accept"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
}
