//
//  LoginView.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import SwiftUI

import ComposableArchitecture


struct LoginView: View {
    enum Field: Hashable {
        case first
        case second
        case third
        case fourth
    }
    
    @Perception.Bindable var store: StoreOf<LoginReducer>
    
    @State private var isFocused: Bool = false
    
    @FocusState private var focusedField: Field?
    
    private let width = UIScreen.main.bounds.width * 0.8

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                if store.isLoading {
                    ProgressView()
                        .scaleEffect(2)
                        .zIndex(1)
                }
                
                VStack(alignment: .center, spacing: 20) {
                    TextField("매장 ID를 입력해주세요.", text: $store.restaurantId)
                        .roundedTextFieldModifier(width: width, height: 60)
                        .focused($focusedField, equals: .first)
                        .submitLabel(.next)
                    
                    TextField("테이블 번호를 입력해주세요.", text: $store.tableNo)
                        .roundedTextFieldModifier(width: width, height: 60)
                        .focused($focusedField, equals: .second)
                        .keyboardType(.phonePad)
                        .submitLabel(.next)
                    
                    TextField("유저 ID를 입력해주세요.", text: $store.memberId)
                        .roundedTextFieldModifier(width: width, height: 60)
                        .focused($focusedField, equals: .third)
                        .submitLabel(.next)
                    
                    TextField("비밀번호를 입력해주세요.", text: $store.password)
                        .roundedTextFieldModifier(width: width, height: 60)
                        .focused($focusedField, equals: .fourth)
                        .submitLabel(.done)
                    
                    Text("로그인")
                        .roundedTextWithTapModifier(width: width, action: {
                            focusedField = nil
                            
                            store.send(
                                .login(
                                    restaurantId: store.restaurantId,
                                    tableNo: store.tableNo,
                                    memberId: store.memberId,
                                    password: store.password
                                )
                            )
                        })
                        .alert($store.scope(state: \.alert, action: \.alert))
                }
                .zIndex(0)
                .navigationBarHidden(true)
                .onSubmit {
                    switch focusedField {
                    case .first:
                        focusedField = .second
                    case .second:
                        focusedField = .third
                    case .third:
                        focusedField = .fourth
                    default:
                        break
                    }
                }
            }
        }
    }
}
