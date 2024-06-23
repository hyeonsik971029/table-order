//
//  Image+Modifier.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import SwiftUI

extension Image {
    
    func defaultImageModifier(
        _ size: CGFloat,
        weight: Font.Weight = .regular,
        foregroundColor: Color
    ) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .font(.system(size: size, weight: weight))
            .foregroundColor(foregroundColor)
    }
}

