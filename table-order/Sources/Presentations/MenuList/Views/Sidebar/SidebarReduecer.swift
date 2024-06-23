//
//  SidebarReduecer.swift
//  table-order
//
//  Created by 오현식 on 6/4/24.
//

import SwiftUI

import ComposableArchitecture

@Reducer
struct SidebarReduecer {
    @ObservableState
    struct State: Equatable {
        var selectedCategory: Menu.Category?
        var commons: [Common] = [
            .init(type: .orderHistory, image: "note.text"),
            .init(type: .calling, image: "person.fill"),
            .init(type: .setting, image: "gearshape.fill")
        ]
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case selectCategory(Menu.Category)
        case selectCommon(Common.Types)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
            .onChange(of: \.selectedCategory) { old, new in
                Reduce { state, action in
                        .run { send in
                            guard let old = old, let new = new, old != new else { return }
                            await send(.selectCategory(new))
                        }
                }
            }
    }
}
