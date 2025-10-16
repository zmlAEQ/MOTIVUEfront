//
//  AppBackGround.swift
//  SwiftUIstudy
//
//  Created by JangeJason on 2025/9/12.
//

import SwiftUI

struct AppBackGround: View {
    var colors: [Color] = [.blue, .red, .yellow]
    var body: some View {
        LinearGradient(
            colors: colors,
            //colors: [.black],   // 黑色
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea() // 让渐变铺满整个屏幕
    }
}

#Preview {
    AppBackGround()
}
