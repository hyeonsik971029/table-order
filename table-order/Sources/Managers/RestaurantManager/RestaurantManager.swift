//
//  RestaurantManager.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import Foundation

protocol RestaurantManageable: AnyObject {
    
    var restaurantDB: RestaurantInfo { get }
    
    func initialize()
    func update(_ restaurant: Restaurant)
}

class RestaurantManager: RestaurantManageable {
    
    var restaurantDB: RestaurantInfo {
        var object: RestaurantInfo = .init()
        object = RestaurantInfo.load(object)
        return object
    }
    
    func initialize() {
        self.restaurantDB.initialize()
    }
    
    func update(_ restaurant: Restaurant) {
        self.restaurantDB.update(restaurant)
    }
}

extension RestaurantManager: Equatable {
    static func == (lhs: RestaurantManager, rhs: RestaurantManager) -> Bool {
        return lhs.restaurantDB == rhs.restaurantDB
    }
}
