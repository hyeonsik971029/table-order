//
//  ButtonStyle.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    
    var width: CGFloat
    var height: CGFloat
    
    var foregroundColor: Color
    var backgroundColor: Color
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    init(
        width: CGFloat,
        height: CGFloat = 60,
        foregroundColor: Color = .white,
        backgroundColor: Color = .init(uiColor: .systemBlue)
    ) {
        self.width = width
        self.height = height
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.system(size: 24))
            .foregroundColor(self.foregroundColor)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(self.isEnabled ? self.backgroundColor: .init(uiColor: .systemGray))
                    .frame(width: self.width, height: self.height)
            }
    }
}
