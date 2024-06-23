//
//  MenuListView.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import SwiftUI

import ComposableArchitecture


struct MenuListView: View {
    
    @State private var scrollToIndex = 0
    @State private var basket = 0
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let width = UIScreen.main.bounds.width
    
    @Perception.Bindable var store: StoreOf<MenuListReducer>
    
    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                if store.isLoading {
                    ProgressView()
                        .scaleEffect(2)
                        .zIndex(2)
                }
                
                if let sidebarAlertCommonType = store.sidebarAlertCommonType {
                    switch sidebarAlertCommonType {
                    case .orderHistory:
                        self.showOrderHistory()
                        .zIndex(1)
                    case .setting:
                        self.showSetting()
                        .zIndex(1)
                    case .calling:
                        self.showCalling()
                        .zIndex(1)
                    case .basket:
                        self.showBasket()
                        .zIndex(1)
                    }
                }
                
                if store.isSelectMenu {
                    self.showSelectMenu()
                        .zIndex(1)
                }
                
                HStack(spacing: 5) {
                    /// 사이드 바
                    SidebarView(
                        width: self.width * 0.2,
                        store: store.scope(state: \.sidebar, action: \.sidebar) ?? Store(
                            initialState: SidebarReduecer.State(selectedCategory: .main),
                            reducer: { SidebarReduecer() }
                        )
                    )
                    
                    /// 메뉴 리스트
                    VStack(spacing: 10) {

                        Text("테이블 번호 \(store.tableNo)")
                            .padding([.top, .trailing], 16)
                            .frame(width: self.width * 0.8, alignment: .trailing)
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.init(uiColor: .systemGray))
                        
                        ScrollView {
                            ForEach(Menu.Category.allCases, id: \.self) { category in
                                Section(
                                    header: Text(category.rawValue)
                                        .id(category)
                                        .padding(.leading, 50)
                                        .frame(width: self.width * 0.8, alignment: .leading)
                                        .font(.system(size: 24, weight: .bold)),
                                    content: {
                                        LazyVGrid(columns: self.columns, alignment: .leading) {
                                            ForEach(
                                                store.menuList.filter { $0.menuCategory == category },
                                                id: \.foodMenuNo
                                            ) { menu in
                                                MenuView(
                                                    image: "\(menu.image.path)\(menu.image.storeName)",
                                                    imageSize: self.width * 0.8 * 0.8 * 0.25 * 0.5,
                                                    title: menu.foodMenuNm,
                                                    price: menu.foodMenuPrice,
                                                    width: self.width * 0.8 * 0.8 * 0.25,
                                                    height: self.width * 0.8 * 0.8 * 0.25,
                                                    action: { store.send(.updateOrderMenu(menu)) }
                                                )
                                            }
                                        }
                                        .padding(.horizontal, 50)
                                    }
                                )
                            }
                        }
                    }
                }
                .zIndex(0)
                .navigationBarHidden(true)
            }
            .alert($store.scope(state: \.alert, action: \.alert))
        }
    }
}

extension MenuListView {
    
    // Menu
    func showSelectMenu() -> some View {
        let endpoint = Bundle.main.object(forInfoDictionaryKey: "ImageEndpoint") as! String
        let menu = store.selectedMenu
        let path = menu.image.path + menu.image.storeName
        
        var count = 1
        if let orderMenu = store.orderMenus.first(where: { $0.menu == menu }) {
            count = orderMenu.count
        }
        
        return WithPerceptionTracking {
            AlertView(
                title: menu.foodMenuNm,
                messageView: {
                    VStack(spacing: 24) {
                        AsyncimageView(
                            url: URL(string: endpoint + path)!,
                            placeholder: { ProgressView() }
                        )
                        .frame(width: self.width * 0.8 * 0.5 * 0.5, height: self.width * 0.8 * 0.5 * 0.5)
                        
                        HStack(spacing: 64) {
                            Image(systemName: "minus.square")
                                .defaultImageModifier(
                                    self.width * 0.8 * 0.5 * 0.1,
                                    weight: .light,
                                    foregroundColor: .black
                                )
                                .onTapGesture {
                                    store.send(.updateOrderCount(count-1))
                                }
                            
                            Text("\(count)")
                                .font(.system(size: 64, weight: .bold))
                                .foregroundColor(.black)
                            
                            Image(systemName: "plus.square")
                                .defaultImageModifier(
                                    self.width * 0.8 * 0.5 * 0.1,
                                    weight: .light,
                                    foregroundColor: .black
                                )
                                .onTapGesture {
                                    store.send(.updateOrderCount(count+1))
                                }
                        }
                    }
                },
                buttons: {
                    Text("확인")
                        .roundedTextWithTapModifier(
                            width: self.width * 0.8 * 0.5,
                            action: {
                                store.send(.updateIsSelectMenu(false))
                            }
                        )
                }
            )
        }
    }
    
    // Sidebar
    func showOrderHistory() -> some View {
        WithPerceptionTracking {
            AlertView(
                title: Common.Types.orderHistory.rawValue,
                messageView: {
                    VStack {
                        Text("주문 아이디 \(store.orderHistory.orderId)")
                            .frame(width:self.width * 0.8 * 0.5, alignment: .leading)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("테이블 번호 \(store.orderHistory.tableNo)")
                            .frame(width:self.width * 0.8 * 0.5, alignment: .leading)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                        
                        Spacer()
                            .frame(height: 32)
                        
                        Divider()
                            .foregroundColor(.black)
                        
                        ForEach(store.orderHistory.menus, id: \.foodMenuNo) { orderHistory in
                            HStack {
                                Text(orderHistory.foodMenuNm)
                                    .font(.system(size: 32, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                                VStack {
                                    Text("\(orderHistory.orderCnt) 개")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(.black)
                                    Text("\(orderHistory.foodMenuPrice) 원")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    .frame(width: self.width * 0.8 * 0.5)
                },
                buttons: {
                    Text("확인")
                        .roundedTextWithTapModifier(
                            width: self.width * 0.8 * 0.5,
                            action: { store.send(.sidebarAlertDismiss) }
                        )
                }
            )
        }
    }
    
    func showCalling() -> some View{
        WithPerceptionTracking {
            AlertView(
                title: Common.Types.calling.rawValue,
                message: "직원이 확인중입니다.\n잠시만 기다려주세요.",
                buttons: {
                    Text("확인")
                        .roundedTextWithTapModifier(
                            width: self.width * 0.8 * 0.5,
                            action: { store.send(.sidebarAlertDismiss) }
                        )
                }
            )
        }
    }
    
    func showSetting() -> some View {
        WithPerceptionTracking {
            AlertView(
                title: Common.Types.setting.rawValue,
                messageView: {
                    Spacer()
                    
                    VStack(spacing: 5) {
                        HStack {
                            Text("음식점 아이디")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.black)
                            Spacer()
                            Text(store.provider.restaurantDB.restaurantId)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        
                        HStack {
                            Text("유저 아이디")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.black)
                            Spacer()
                            Text(store.provider.restaurantDB.memberId)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        
                        HStack {
                            Text("테이블 번호")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.black)
                            Spacer()
                            Text(store.provider.restaurantDB.tableNo)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.black)
                        }
                    }
                },
                buttons: {
                    VStack(spacing: 5) {
                        Text("확인")
                            .roundedTextWithTapModifier(
                                width: self.width * 0.8 * 0.5,
                                action: { store.send(.sidebarAlertDismiss) }
                            )
                        Text("로그아웃")
                            .underlineTextWithTapModifier(
                                foregroundColor: .black,
                                action: { store.send(.sidebarAlertDismiss) }
                            )
                    }
                }
            )
        }
    }
    
    func showBasket() -> some View {
        WithPerceptionTracking {
            AlertView(
                title: Common.Types.basket.rawValue,
                messageView: {
                    ScrollView {
                        if store.orderMenus.isEmpty {
                            Spacer()
                            
                            Text("음식을 담아주세요.")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.black)
                        } else {
                            VStack(spacing: 5) {
                                ForEach(store.orderMenus, id: \.menu.foodMenuNo) { orderMenu in
                                    HStack {
                                        Text(orderMenu.menu.foodMenuNm)
                                            .font(.system(size: 32, weight: .semibold))
                                            .foregroundColor(.black)
                                        Spacer()
                                        VStack {
                                            Text("\(orderMenu.count) 개")
                                                .font(.system(size: 24, weight: .semibold))
                                                .foregroundColor(.black)
                                            Text("\(orderMenu.menu.foodMenuPrice) 원")
                                                .font(.system(size: 24, weight: .semibold))
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                            }
                        }
                    }
                },
                buttons: {
                    VStack(spacing: 10) {
                        Text("확인")
                            .roundedTextWithTapModifier(
                                width: self.width * 0.8 * 0.5,
                                action: { store.send(.sidebarAlertDismiss) }
                            )
                        
                        Text("주문하기")
                            .roundedTextWithTapModifier(
                                width: self.width * 0.8 * 0.5,
                                action: { store.send(.order) }
                            )
                    }
                }
            )
        }
    }
}
