//
//  Casted.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import Foundation

extension Optional {
    
    func casted<T>() -> T? {
        return self as? T
    }
}
