//
//  SimpleDefaults.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import Foundation

final class SimpleDefaults {
    
    static let shared = SimpleDefaults()
    
    private let restaurantInfoKey: String = "com.hyeonsik.table-order.restaurant"
    private let orderInfoKey: String = "com.hyeonsik.table-order.order"
    
    func save(key: String, data: Any?) {
        UserDefaults.standard.removeObject(forKey: key)
        guard let data = data else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func load(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    func delete(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

extension SimpleDefaults {
    
    func saveRestaurantInfo(key: String, data: Any?) {
        self.save(key: "\(self.restaurantInfoKey).\(key)", data: data)
    }
    
    func loadRestaurantInfo(key: String) -> Any? {
        self.load(key: "\(self.restaurantInfoKey).\(key)")
    }
    
    func deleteRestaurantInfo(key: String) {
        self.delete(key: "\(self.restaurantInfoKey).\(key)")
    }
}

extension SimpleDefaults {
    
    func saveOrderId(key: String, id: String) {
        if var new = self.loadOrderId(key: "\(self.orderInfoKey).\(key)") {
            new.append(id)
            self.save(key: "\(self.orderInfoKey).\(key)", data: new)
        } else {
            self.save(key: "\(self.orderInfoKey).\(key)", data: id)
        }
    }
    
    func loadOrderId(key: String) -> [String]? {
        guard let loaded = self.load(key: "\(self.orderInfoKey).\(key)") else { return nil }
        return loaded as? [String] == nil ? [loaded as! String]: loaded as! [String]
    }
    
    func deleteOrderId(key: String) {
        self.delete(key: "\(self.orderInfoKey).\(key)")
    }
}
