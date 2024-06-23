//
//  MainCoordinator.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import SwiftUI

import ComposableArchitecture

struct MainCoordinator: View {
    @Perception.Bindable var store: StoreOf<MainCoordinatorReducer>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationView {
                NavigationLink(
                    item: $store.scope(state: \.destination, action: \.destination),
                    destination: { store in
                        switch store.state {
                        case .login:
                            if let store = store.scope(state: \.login, action: \.login) {
                                LoginView(store: store)
                            }
                        case .menuList:
                            if let store = store.scope(state: \.menuList, action: \.menuList) {
                                MenuListView(store: store)
                            }
                        }
                    }
                ) {
                    EmptyView()
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

