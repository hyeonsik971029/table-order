//
//  Restaurant.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import Foundation

struct RestaurantResponse: Codable {
    let header: Header
    let body: Restaurant
}

struct Restaurant: Codable {
    let restaurantId: String
    let tableNo: String
    let memberId: String
}

extension Restaurant {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        restaurantId = try container.decode(String.self, forKey: .restaurantId)
        tableNo = String(try container.decode(Int.self, forKey: .tableNo))
        memberId = try container.decode(String.self, forKey: .memberId)
    }
}
