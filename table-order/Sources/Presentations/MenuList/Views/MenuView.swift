//
//  MenuView.swift
//  table-order
//
//  Created by 오현식 on 5/27/24.
//

import SwiftUI

struct MenuView: View {
    
    let endpoint: String = Bundle.main.object(forInfoDictionaryKey: "ImageEndpoint") as! String
    
    let image: String
    let imageSize: CGFloat
    
    let title: String
    
    let price: String
    
    let width: CGFloat
    let height: CGFloat
    
    let action: (() -> Void)
    
    var body: some View {
        Button(action: self.action, label: {
            VStack(spacing: 16) {
                AsyncimageView(
                    url: URL(string: "\(self.endpoint)\(self.image)")!,
                    placeholder: { ProgressView() }
                )
                .frame(width: self.imageSize, height: self.imageSize)
                
                VStack {
                    Text(self.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("\(self.price)원")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.black)
                }
            }
        })
        .frame(width: self.width, height: self.height)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .frame(width: self.width, height: self.height)
                .shadow(color: .init(uiColor: .systemGray4), radius: 10, x: 3, y: 3)
        )
    }
}
