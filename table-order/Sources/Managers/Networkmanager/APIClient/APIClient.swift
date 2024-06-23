//
//  APIClient.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import Foundation

import Alamofire

class APIClient {
    
    typealias onSuccess<T> = ((T) -> Void)
    typealias onFailure = ((_ error: Error) -> Void)
    
    static func request<T>(
        _ object: T.Type,
       router: APIRouter,
       success: @escaping onSuccess<T>,
       failure: @escaping onFailure
    ) where T: Decodable {
        AF.request(router)
         .validate(statusCode: 200..<500)
         .responseDecodable(of: object) { response in
             switch response.result {
             case let .success(data):
                 success(data)
             case let .failure(error):
                 failure(error)
             }
         }
    }
}
