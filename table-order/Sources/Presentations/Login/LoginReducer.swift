//
//  LoginReducer.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import Combine
import SwiftUI

import ComposableArchitecture


@Reducer
struct LoginReducer {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        
        var provider: RestaurantManager
        
        var restaurantId: String = "B202404292054200025"
        var tableNo: String = "2"
        var memberId: String = "lhs"
        var password: String = "1234"
        
        var isLoading: Bool = false
        var isLogin: Bool = false
        var errorMessage: String?
    }
    
    enum Action: BindableAction {
        case alert(PresentationAction<Alert>)
        enum Alert: Equatable { }

        case binding(BindingAction<State>)
        
        case refresh
        case login(restaurantId: String, tableNo: String, memberId: String, password: String)
        case updateIsLoading(Bool)
        case updateIsLogin(Bool)
        case updateProvider(Restaurant)
        case errorMessage(String?)
        
        case push(RestaurantManager, Bool)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .alert:
                return .none
                
            case .binding:
                return .none
                
            case .refresh:
                state.isLoading = false
                state.isLogin = false
                state.errorMessage = nil
                return .none
            case let .login(restaurantId, tableNo, memberId, password):
                return .concatenate([
                    .send(.refresh),
                    .send(.updateIsLoading(true)),
                    
                    self.loadRestaurantInfo(
                        restaurantId: restaurantId,
                        tableNo: tableNo,
                        memberId: memberId,
                        password: password
                    ),
                    
                    .send(.updateIsLoading(false))
                ])
            case let .updateIsLoading(isLoading):
                state.isLoading = isLoading
                return .none
            case let .updateIsLogin(isLogin):
                state.isLogin = isLogin
                let provider = state.provider
                return .send(.push(provider, isLogin))
            case let .updateProvider(restaurant):
                let provider = state.provider
                provider.update(restaurant)
                return .send(.updateIsLogin(true))
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
                
            case .push:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

extension LoginReducer {
    
    func loadRestaurantInfo(
        restaurantId: String,
        tableNo: String,
        memberId: String,
        password: String
    ) -> Effect<LoginReducer.Action> {
        
        return Effect.publisher {
            NetworkManager.shared.login(
                restaurantId: restaurantId,
                tableNo: tableNo,
                memberId: memberId,
                password: password
            )
            .map(LoginReducer.Action.updateProvider)
            .receive(on: DispatchQueue.main)
            .catch { error in Just(.errorMessage(error.localizedDescription)) }
        }
    }
}
