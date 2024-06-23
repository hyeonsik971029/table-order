//
//  Text+Modifier.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import SwiftUI

struct RoundedTextWithTapModifier: ViewModifier {
    
    let width: CGFloat
    let height: CGFloat
    
    var foregroundColor: Color
    var backgroundColor: Color
    
    var action: (() -> Void)
    
    @State private var isPressed: Bool = false
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 24))
            .foregroundColor(self.foregroundColor)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(self.isEnabled ? self.backgroundColor: .init(uiColor: .systemGray))
                    .frame(width: self.width, height: self.height)
            }
            .opacity(self.isPressed ? 0.8: 1)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        self.isPressed = true
                        action()
                    }
                    .onEnded { _ in
                        self.isPressed = false
                    }
            )
    }
}

struct UnderlineTextWithTapModifier: ViewModifier {
    
    var foregroundColor: Color
    var backgroundColor: Color
    
    var action: (() -> Void)
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 24))
            .foregroundColor(self.foregroundColor)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(self.isEnabled ? self.backgroundColor: .init(uiColor: .systemGray))
                    .overlay(Divider(), alignment: .bottom)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        action()
                    }
            )
    }
}

extension Text {
    
    func roundedTextWithTapModifier(
        width: CGFloat,
        height: CGFloat = 60,
        foregroundColor: Color = .white,
        backgroundColor: Color = .init(uiColor: .systemBlue),
        action: @escaping (() -> Void)
    ) -> some View {
        modifier(
            RoundedTextWithTapModifier(
                width: width,
                height: height,
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                action: action
            )
        )
    }
    
    func underlineTextWithTapModifier(
        foregroundColor: Color = .init(uiColor: .systemBlue),
        backgroundColor: Color = .white,
        action: @escaping (() -> Void)
    ) -> some View {
        modifier(
            UnderlineTextWithTapModifier(
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                action: action
            )
        )
    }
}
