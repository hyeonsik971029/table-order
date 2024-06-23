//
//  Order.swift
//  table-order
//
//  Created by 오현식 on 6/19/24.
//

import Foundation

struct OrderResponse: Codable {
    let header: Header
    let body: OrderHistory?
}

struct OrderHistory: Codable, Equatable {
    let orderId: String
    let restaurantId: String
    let tableNo: String
    let registDate: String
    let menus: [MenuHistory]
    
    enum CodingKeys: String, CodingKey {
        case orderId
        case restaurantId
        case tableNo
        case registDate
        case menus = "menu"
    }
}

struct MenuHistory: Codable, Equatable {
    let foodMenuNm: String
    let foodMenuPrice: String
    let foodMenuNo: Int
    let orderCnt: Int
}

extension OrderHistory {
    init() {
        self.orderId = ""
        self.restaurantId = ""
        self.tableNo = ""
        self.registDate = ""
        self.menus = []
    }
}
