//
//  CategoryView.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import Combine
import SwiftUI

struct CategoryView: View {
    
    @Binding private var isSelected: Bool
    
    private let title: String
    
    private let width: CGFloat
    private let height: CGFloat
    
    var body: some View {
        HStack {
            Text(self.title)
                .padding(.leading, 5)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(self.isSelected ? .white: .black)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .defaultImageModifier(22, foregroundColor: self.isSelected ? .white: .black)
                .padding(.trailing, 5)
        }
        .frame(width: self.width, height: self.height)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(self.isSelected ? Color.init(uiColor: .systemPurple): .white)
                .frame(width: self.width, height: self.height)
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    self.isSelected = true
                }
        )
    }
}

extension CategoryView {
    
    init<T: Hashable>(
        tag: T,
        selection: Binding<T?>,
        title: String,
        width: CGFloat,
        height: CGFloat
    ) {
        self._isSelected = Binding(
            get: { selection.wrappedValue == tag },
//            set: { _ in selection.wrappedValue = tag }
            set: { new in
                if new { selection.wrappedValue = tag }
            }
        )
        self.title = title
        self.width = width
        self.height = height
    }
}
