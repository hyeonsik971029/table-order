//
//  MainCoordinatorReducer.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import ComposableArchitecture

@Reducer
struct MainCoordinatorReducer {
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        
        var provider: RestaurantManager
    }
    
    enum Action {
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .destination(.presented(.login(.push(provider, isLogin)))):
                state.provider = provider
                state.destination = isLogin ? .menuList(.init(provider: provider)): nil
                return .send(.destination(.presented(.menuList(.refresh))))
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

extension MainCoordinatorReducer {
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case login(LoginReducer.State)
            case menuList(MenuListReducer.State)
        }
        
        enum Action {
            case login(LoginReducer.Action)
            case menuList(MenuListReducer.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.login, action: \.login) {
                LoginReducer()
            }
            Scope(state: \.menuList, action: \.menuList) {
                MenuListReducer()
            }
        }
    }
}

