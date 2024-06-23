//
//  AlertView.swift
//  table-order
//
//  Created by 오현식 on 6/15/24.
//

import SwiftUI

struct AlertView<Message, Buttons>: View where Message: View, Buttons: View {
    
    let width: CGFloat = UIScreen.main.bounds.width
    let height: CGFloat = UIScreen.main.bounds.height
    
    var title: String
    
    var messageView: (() -> Message)
    var message: String?
    
    var buttons: (() -> Buttons)
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                // title
                VStack {
                    Text(self.title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                    
                    Divider()
                        .foregroundColor(.black)
                }
                
                // message
                if let message = message {
                    Spacer()
                    
                    Text(message)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                }
                self.messageView()
                
                Spacer()
                
                // buttons
                self.buttons()
            }
            .padding(.all, 32)
            .frame(width: self.width * 0.5, height: self.height * 0.8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(width: self.width * 0.5, height: self.height * 0.8)
            )
        }
    }
}

extension AlertView {
    @discardableResult
    init(
        title: String,
        @ViewBuilder messageView: @escaping (() -> Message),
        @ViewBuilder buttons: @escaping (() -> Buttons)
    ) {
        self.title = title
        self.messageView = messageView
        self.buttons = buttons
    }
}

extension AlertView where Message == EmptyView {
    @discardableResult
    init(
        title: String,
        message: String?,
        @ViewBuilder buttons: @escaping (() -> Buttons)
    ) {
        self.init(title: title, messageView: { EmptyView() }, buttons: buttons)
        self.message = message
    }
}
