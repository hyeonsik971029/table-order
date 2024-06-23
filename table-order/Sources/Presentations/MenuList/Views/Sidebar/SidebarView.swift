//
//  SidebarView.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import Combine
import SwiftUI

import ComposableArchitecture


struct SidebarView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    let width: CGFloat
    
    @Perception.Bindable var store: StoreOf<SidebarReduecer>
    
    var body: some View {
        VStack {
            /// title
            Text("Table Order_효상s")
                .padding([.top, .leading], 16)
                .frame(width: self.width, alignment: .leading)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.init(uiColor: .systemPurple))
            
            Spacer().frame(height: 36)
            
            /// category
            VStack {
                ForEach(Menu.Category.allCases, id: \.self) { category in
                    CategoryView(
                        tag: category,
                        selection: $store.selectedCategory,
                        title: category.rawValue,
                        width: self.width * 0.8,
                        height: 44
                    )
                }
            }
            
            Spacer()
            
            VStack(spacing: 24) {
                /// setting
                /// 주문내역, 직원호출, 설정
                LazyVGrid(columns: self.columns, spacing: 24) {
                    ForEach(store.commons, id: \.self) { common in
                        ImageButtonView(
                            .vertical,
                            title: common.type.rawValue,
                            image: common.image,
                            width: self.width * 0.8 * 0.5 * 0.8,
                            height: self.width * 0.8 * 0.5 * 0.8,
                            foregroundColor: .init(uiColor: .systemPurple),
                            backgroundColor: .white,
                            action: { store.send(.selectCommon(common.type)) }
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                /// basket
                ImageButtonView(
                    .horizontal,
                    title: "장바구니",
                    image: "archivebox.fill",
                    width: self.width * 0.8,
                    height: 60,
                    foregroundColor: .white,
                    backgroundColor: .init(uiColor: .systemPurple),
                    action: { store.send(.selectCommon(.basket)) }
                )
            }
        }
        .frame(width: self.width)
    }
}
