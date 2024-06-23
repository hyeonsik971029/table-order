//
//  AsyncimageView.swift
//  table-order
//
//  Created by 오현식 on 6/2/24.
//

import SwiftUI

struct AsyncimageView<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    
    init(
        url: URL,
        @ViewBuilder placeholder: () -> Placeholder
    ) {
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    private var content: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                placeholder
            }
        }
    }
                              
    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
}
