//
//  table_orderApp.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import SwiftUI

import ComposableArchitecture

@main
struct table_orderApp: App {
    static var provider: RestaurantManager {
        let provider = RestaurantManager()
        provider.update(.init(restaurantId: "", tableNo: "1", memberId: ""))
        return provider
    }
    
    var body: some Scene {
        WindowGroup {
            MainCoordinator(store:
                    .init(
                        initialState: MainCoordinatorReducer.State(
                            destination: .login(.init(provider: table_orderApp.provider)),
                            provider: table_orderApp.provider
                        ),
                        reducer: {
                            MainCoordinatorReducer()
                        }
                    )
            )
        }
    }
}
