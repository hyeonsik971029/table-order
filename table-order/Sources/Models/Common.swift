//
//  Common.swift
//  table-order
//
//  Created by 오현식 on 6/13/24.
//

import Foundation

struct Common: Equatable, Hashable {
    let type: Types
    let image: String
}

extension Common {
    enum Types: String {
        case orderHistory = "주문내역"
        case setting = "설정"
        case calling = "직원호출"
        case basket = "장바구니"
    }
}
