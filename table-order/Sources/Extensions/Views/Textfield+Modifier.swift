//
//  Textfield+Modifier.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import SwiftUI

struct RoundedTextFieldModifier: ViewModifier {
    
    let width: CGFloat
    let height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 24))
            .textInputAutocapitalization(.never)
            .frame(width: width, height: height)
            .background(
                Color(uiColor: .secondarySystemBackground),
                in: RoundedRectangle(cornerRadius: 10)
            )
    }
}

extension TextField {
    
    func roundedTextFieldModifier(width: CGFloat, height: CGFloat) -> some View {
        modifier(RoundedTextFieldModifier(width: width, height: height))
    }
}
