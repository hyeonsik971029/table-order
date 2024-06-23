//
//  Menu.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import Foundation

struct MenuResponse: Codable {
    let header: Header
    let body: [Menu]
}

// 공용 헤더
struct Header: Codable {
    let result: String
    let message: String?
}

struct Menu: Codable, Equatable {
    let image: Img
    let foodMenuNm: String
    let foodMenuNo: Int
    let restaurantId: String
    let menuCategory: Category
    let foodMenuTitle: String
    let foodMenuPrice: String
    let popularAt: String
    let orderCnt: Int?
}

struct Img: Codable, Equatable {
    let path: String
    let name: String
    let storeName: String
}

extension Menu {
    enum Category: String, CaseIterable, Codable {
        case main = "메인메뉴"
        case stew = "찌개류"
        case stirFired = "볶음류"
        case noodle = "면류"
        case fried = "튀김류"
        case side = "사이드"
        case drink = "주류/음료"
        /// Decoding
        init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            
            switch rawValue {
            case "MAIN":
                self = .main
            case "STEW":
                self = .stew
            case "STIR_FRIED":
                self = .stirFired
            case "NOODLE":
                self = .noodle
            case "FRIED":
                self = .fried
            case "SIDE":
                self = .side
            case "DRINK":
                self = .drink
            default:
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Invalid category value"
                )
            }
        }
        /// Encoding
        func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
            case .main:
                try container.encode("MAIN")
            case .stew:
                try container.encode("STEW")
            case .stirFired:
                try container.encode("STIR_FRIED")
            case .noodle:
                try container.encode("NOODLE")
            case .fried:
                try container.encode("FRIED")
            case .side:
                try container.encode("SIDE")
            case .drink:
                try container.encode("DRINK")
            }
        }
    }
}

extension Menu {
    init() {
        self.image = .init(path: "", name: "", storeName: "")
        self.foodMenuNm = ""
        self.foodMenuNo = 0
        self.restaurantId = ""
        self.menuCategory = .main
        self.foodMenuTitle = ""
        self.foodMenuPrice = ""
        self.popularAt = ""
        self.orderCnt = nil
    }
}
