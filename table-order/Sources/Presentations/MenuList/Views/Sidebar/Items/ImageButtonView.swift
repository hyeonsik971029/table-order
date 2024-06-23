//
//  ImageButtonView.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import SwiftUI

struct ImageButtonView: View {
    
    enum Arrangement {
        case vertical
        case horizontal
    }
    
    let arrangement: Arrangement
    
    let title: String
    let image: String
    
    let width: CGFloat
    let height: CGFloat
    
    let foregroundColor: Color
    let backgroundColor: Color
    
    let action: (() -> Void)
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        switch self.arrangement {
        case .vertical:
            VStack(spacing: 5) {
                Image(systemName: self.image)
                    .defaultImageModifier(
                        self.width * 0.5,
                        weight: .medium,
                        foregroundColor: self.foregroundColor
                    )
                
                Text(self.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.black)
            }
            .frame(width: self.width, height: self.height)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(self.backgroundColor)
                    .frame(width: self.width, height: self.height)
                    .shadow(color: .init(uiColor: .systemGray4), radius: 10, x: 3, y: 3)
            }
            .opacity(self.isPressed ? 0.8: 1)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        self.isPressed = true
                        self.action()
                    }
                    .onEnded { _ in
                        self.isPressed = false
                    }
            )
            
            
        case .horizontal:
            HStack(spacing: 10) {
                Image(systemName: self.image)
                    .defaultImageModifier(24, weight: .medium, foregroundColor: self.foregroundColor)
                
                Text(self.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(self.foregroundColor)
            }
            .frame(width: self.width, height: self.height)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: self.width, height: self.height)
                    .foregroundColor(self.backgroundColor)
                    .shadow(color: .init(uiColor: .systemGray4), radius: 10, x: 3, y: 3)
            )
            .opacity(self.isPressed ? 0.8: 1)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        self.isPressed = true
                        self.action()
                    }
                    .onEnded { _ in
                        self.isPressed = false
                    }
            )
        }
    }
}

extension ImageButtonView {
    
    init(
        _ arrangement: Arrangement,
        title: String,
        image: String,
        width: CGFloat,
        height: CGFloat,
        foregroundColor: Color,
        backgroundColor: Color,
        action: (@escaping () -> Void)
    ) {
        self.arrangement = arrangement
        self.title = title
        self.image = image
        self.width = width
        self.height = height
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.action = action
    }
}
