//
//  RestaurantInfo.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import Foundation

final class RestaurantInfo {
    
    var restaurantId: String
    var tableNo: String
    var memberId: String
    
    init() {
        self.restaurantId = ""
        self.tableNo = "1"
        self.memberId = ""
    }
}

extension RestaurantInfo {
    
    func initialize() {
        SimpleDefaults.shared.deleteRestaurantInfo(key: "restaurantId")
        SimpleDefaults.shared.deleteRestaurantInfo(key: "tableNo")
        SimpleDefaults.shared.deleteRestaurantInfo(key: "memberId")
    }
    
    static func load(_ restaurant: RestaurantInfo) -> RestaurantInfo {
        restaurant.restaurantId = SimpleDefaults.shared.loadRestaurantInfo(key: "restaurantId").casted()!
        restaurant.tableNo = SimpleDefaults.shared.loadRestaurantInfo(key: "tableNo").casted()!
        restaurant.memberId = SimpleDefaults.shared.loadRestaurantInfo(key: "memberId").casted()!
        
        return restaurant
    }
    
    func update(_ restaurant: Restaurant) {
        SimpleDefaults.shared.saveRestaurantInfo(key: "restaurantId", data: restaurant.restaurantId)
        SimpleDefaults.shared.saveRestaurantInfo(key: "tableNo", data: restaurant.tableNo)
        SimpleDefaults.shared.saveRestaurantInfo(key: "memberId", data: restaurant.memberId)
    }
}

extension RestaurantInfo: Equatable {
    static func == (lhs: RestaurantInfo, rhs: RestaurantInfo) -> Bool {
        return lhs.restaurantId == rhs.restaurantId &&
            lhs.tableNo == rhs.tableNo &&
            lhs.memberId == rhs.memberId
    }
}
