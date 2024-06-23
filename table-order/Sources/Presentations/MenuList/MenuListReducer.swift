//
//  MenuListReducer.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import Combine
import SwiftUI

import ComposableArchitecture


@Reducer
struct MenuListReducer {
    struct OrderMenu: Equatable {
        let menu: Menu
        var count: Int
    }
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        
        var sidebar: SidebarReduecer.State?
        var sidebarAlertCommonType: Common.Types?
        
        var provider: RestaurantManager
        
        var tableNo: String = "1"
        
        var isLoading: Bool = false
        var isSelectMenu: Bool = false
        var isOrder: Bool = false
        
        var menuList: [Menu] = []
        var selectedMenu: Menu = .init()
        var orderMenus: [OrderMenu] = []
        var orderHistory: OrderHistory = .init()
        var errorMessage: String?
    }
    
    enum Action {
        case alert(PresentationAction<Alert>)
        enum Alert: Equatable { }
        
        case sidebar(SidebarReduecer.Action)
        case sidebarType(Common.Types)
        case sidebarAlertDismiss
        
        case updateIsLoading(Bool)
        case updateIsSelectMenu(Bool)
        case updateIsOrder(Bool)
        case updateMenuList([Menu])
        case updateOrderMenu(Menu)
        case updateOrderCount(Int)
        case updateOrderHistory(OrderHistory)
        
        case refresh
        case order
        
        case errorMessage(String?)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .alert:
                return .none
                
            case let .sidebar(.selectCategory(category)):
                state.sidebar = .init(selectedCategory: category)
                return .none
            case let .sidebar(.selectCommon(common)):
                switch common {
                case .orderHistory:
                    return .concatenate([
                        .send(.updateIsLoading(true)),
                        .send(.errorMessage(nil)),
                        self.getOrderHistory(),
                        .send(.updateIsLoading(false)),
                        .send(.sidebarType(common))
                    ])
                default:
                    return .send(.sidebarType(common))
                }
            case let .sidebarType(common):
                state.sidebarAlertCommonType = common
                return .none
            case .sidebar:
                return .none
            case .sidebarAlertDismiss:
                state.sidebarAlertCommonType = nil
                return .none
                
            case let .updateIsLoading(isLoading):
                state.isLoading = isLoading
                return .none
            case let .updateIsSelectMenu(isSelectMenu):
                state.isSelectMenu = isSelectMenu
                return .none
            case let .updateIsOrder(isOrder):
                state.isOrder = isOrder
                if isOrder {
                    return .send(.sidebarAlertDismiss)
                } else {
                    return .none
                }
                
            case let .updateMenuList(menuList):
                state.menuList = menuList
                return .none
            case let .updateOrderMenu(selectedMenu):
                state.selectedMenu = selectedMenu
                if state.orderMenus.first(where: { $0.menu == selectedMenu }) == nil {
                    let orderMenu = OrderMenu(menu: selectedMenu, count: 1)
                    state.orderMenus.append(orderMenu)
                }
                return .send(.updateIsSelectMenu(true))
            case let .updateOrderCount(orderCount):
                let selectedMenu = state.selectedMenu
                var orderMenus = state.orderMenus
                orderMenus
                    .firstIndex(where: { $0.menu == selectedMenu })
                    .map { orderMenus[$0].count = orderCount }
                state.orderMenus = orderMenus
                return .none
            case let .updateOrderHistory(orderHistory):
                state.orderHistory = orderHistory
                return .none
                
            case .refresh:
                let provider = state.provider
                state.sidebar = .init(selectedCategory: .main)
                state.tableNo = provider.restaurantDB.tableNo
                
                return .concatenate([
                    .send(.updateIsLoading(true)),
                    .send(.errorMessage(nil)),
                    self.menuListById(provider),
                    .send(.updateIsLoading(false))
                ])
            case .order:
                let provider = state.provider
                let orderMenus = state.orderMenus
                return .concatenate([
                    .send(.updateIsLoading(true)),
                    .send(.errorMessage(nil)),
                    self.order(provider, orderMenus: orderMenus),
                    .send(.updateIsLoading(false))
                ])
                
            case let .errorMessage(errorMessage):
                state.errorMessage = errorMessage
                if let errorMessage = errorMessage {
                    state.alert = AlertState {
                        TextState("에러 발생")
                    } actions: {
                        ButtonState(role: .cancel) {
                            TextState("확인")
                        }
                    } message: {
                        TextState(errorMessage)
                    }
                    return .none
                } else {
                    return .none
                }
            }
        }
        .ifLet(\.sidebar, action: \.sidebar) {
            SidebarReduecer()
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

extension MenuListReducer {
    
    func menuListById(_ provider: RestaurantManager) -> Effect<MenuListReducer.Action> {
        
        return Effect.publisher {
            NetworkManager.shared.menuListById(id: provider.restaurantDB.restaurantId)
                .map(MenuListReducer.Action.updateMenuList)
                .receive(on: DispatchQueue.main)
                .catch { error in Just(.errorMessage(error.localizedDescription)) }
        }
    }
    
    func order(
        _ provider: RestaurantManager,
        orderMenus: [OrderMenu]
    ) -> Effect<MenuListReducer.Action> {
        
        return Effect.publisher {
            let orderId = UUID().uuidString
            SimpleDefaults.shared.saveOrderId(key: "id", id: orderId)
            
            let info: [String: Any] = [
                "orderId": orderId,
                "restaurantId": provider.restaurantDB.restaurantId,
                "tableNo": provider.restaurantDB.tableNo
            ]
            
            let (menuNos, menuCnts) = orderMenus.reduce(into: ([Int](), [Int]())) { result, element in
                result.0.append(element.menu.foodMenuNo)
                result.1.append(element.count)
            }
            
            return NetworkManager.shared.order(info: info, menuNos: menuNos, menuCnts: menuCnts)
                .map(MenuListReducer.Action.updateIsOrder)
                .receive(on: DispatchQueue.main)
                .catch { error in Just(.errorMessage(error.localizedDescription)) }
        }
    }
    
    func getOrderHistory() -> Effect<MenuListReducer.Action> {
        
        return Effect.publisher {
            let orderId = SimpleDefaults.shared.loadOrderId(key: "id")?.last ?? ""
            
            return NetworkManager.shared.getOrderHistory(id: orderId)
                .map(MenuListReducer.Action.updateOrderHistory)
                .receive(on: DispatchQueue.main)
                .catch { error in Just(.errorMessage(error.localizedDescription)) }
        }
    }
}

