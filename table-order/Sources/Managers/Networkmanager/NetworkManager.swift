//
//  NetworkManager.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import Foundation

import Alamofire
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    
    func login(
        restaurantId: String,
        tableNo: String,
        memberId: String,
        password: String
    ) -> AnyPublisher<Restaurant, Error> {
        
        return Future<Restaurant, Error> { promise in
            let router: APIRouter = .login(
                restaurantId: restaurantId,
                tableNo: Int(tableNo) ?? 1,
                memberId: memberId,
                password: password
            )
            
            return APIClient.request(
                RestaurantResponse.self,
                router: router,
                success: { result in
                    if result.header.result == "success" {
                        let restaurant = result.body
                        promise(.success(restaurant))
                        return
                    } else {
                        let error: NSError = .init(
                            domain: "restaurant",
                            code: -99,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                result.header.message ?? "Request login error"
                            ]
                        )
                        promise(.failure(error))
                        return
                    }
                },
                failure: { error in
                    promise(.failure(error))
                    return
                }
            )
        }
        .eraseToAnyPublisher()
    }
    
    func menuListById(id: String) -> AnyPublisher<[Menu], Error> {
        
        return Future<[Menu], Error> { promise in
            let router: APIRouter = .menuList(id: id)
            
            return APIClient.request(
                MenuResponse.self,
                router: router,
                success: { result in
                    if result.header.result == "success" {
                        let menuList = result.body
                        promise(.success(menuList))
                        return
                    } else {
                        let error: NSError = .init(
                            domain: "menuList",
                            code: -99,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                result.header.message ?? "Get menu list error"
                            ]
                        )
                        promise(.failure(error))
                        return
                    }
                },
                failure: { error in
                    promise(.failure(error))
                    return
                }
            )
        }
        .eraseToAnyPublisher()
    }
    
    func order(
        info: [String: Any],
        menuNos: [Int],
        menuCnts: [Int]
    ) -> AnyPublisher<Bool, Error> {
        
        return Future<Bool, Error> { promise in
            let router: APIRouter = .order(info: info, menuNos: menuNos, MenuCnts: menuCnts)
            
            return APIClient.request(
                OrderResponse.self,
                router: router,
                success: { result in
                    if result.header.result == "success" {
                        promise(.success(true))
                        return
                    } else {
                        let error: NSError = .init(
                            domain: "order",
                            code: -99,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                    result.header.message ?? "Request order error"
                            ]
                        )
                        promise(.failure(error))
                        return
                    }
                },
                failure: { error in
                    promise(.failure(error))
                    return
                }
            )
        }
        .eraseToAnyPublisher()
    }
    
    func getOrderHistory(id: String) -> AnyPublisher<OrderHistory, Error> {
        
        return Future<OrderHistory, Error> { promise in
            let router: APIRouter = .orderHistory(orderId: id)
            
            return APIClient.request(
                OrderResponse.self,
                router: router,
                success: { result in
                    if result.header.result == "success" {
                        if let orderHistory = result.body {
                            promise(.success(orderHistory))
                        } else {
                            let error: NSError = .init(
                                domain: "order",
                                code: -99,
                                userInfo: [
                                    NSLocalizedDescriptionKey: "No response found"
                                ]
                            )
                            promise(.failure(error))
                        }
                        return
                    } else {
                        let error: NSError = .init(
                            domain: "order",
                            code: -99,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                    result.header.message ?? "Request order error"
                            ]
                        )
                        promise(.failure(error))
                        return
                    }
                },
                failure: { error in
                    promise(.failure(error))
                    return
                }
            )
        }
        .eraseToAnyPublisher()
    }
}
