//
//  APIRouter.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import Foundation

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case login(restaurantId: String, tableNo: Int, memberId: String, password: String)
    case menuList(id: String)
    case order(info: [String: Any], menuNos: [Int], MenuCnts: [Int])
    case orderHistory(orderId: String)
    
    var method: HTTPMethod {
        switch self {
        case .login, .order:
            return .post
        case .menuList, .orderHistory:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/loginApi"
        case .menuList:
            return "/foodMenuList"
        case .order, .orderHistory:
            return "/order-history"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .login(restaurantId, tableNo, memberId, password):
            return [
                "restaurantId": restaurantId,
                "tableNo": tableNo,
                "memberId": memberId,
                "password": password
            ]
        case let .menuList(id):
            return ["id": id]
        case let .order(info, menuNos, menuCnts):
            return info.merging(
                ["foodMenuNo": menuNos, "orderCnt": menuCnts]
            ) { $1 }
        case let .orderHistory(orderId):
            return ["orderId": orderId]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .order:
            return URLEncoding(destination: .queryString, arrayEncoding: .noBrackets)
        default:
            return URLEncoding.queryString
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        if let url = URL(string: APIConstants.endpoint)?.appendingPathComponent(self.path) {
            var request = URLRequest(url: url)
            request.method = self.method
            request.setValue(
                APIConstants.ContentType.json.rawValue,
                forHTTPHeaderField: APIConstants.HTTPHeader.contentType.rawValue
            )
            request.setValue(
                APIConstants.ContentType.json.rawValue,
                forHTTPHeaderField: APIConstants.HTTPHeader.acceptType.rawValue
            )
            
            let encoded = try encoding.encode(request, with: self.parameters)
            return encoded
        } else {
            return URLRequest(url: URL(string: "")!)
        }
    }
}
