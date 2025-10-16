//
//  CircleGlassImage.swift
//  SwiftUIstudy
//
//  Created by JangeJason on 2025/9/13.
//

import SwiftUI

struct CircleGlassImage: View {
    var image: Image
    let borderwidth: CGFloat
    
    var body: some View {
        ZStack {
            // 背景玻璃圆形
            Circle()
//                .glassEffect(in: .circle)
                .fill(.thinMaterial)
                .background(Circle().fill(.white.opacity(0.2)))
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(1), .white.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: borderwidth
                        )
                )

            // 图片
            image
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .padding(4) // 给图片留一点边距，避免贴边
        }
    }
}

#Preview("适用于图片底下加玻璃质感") {
    ZStack{
        AppBackGround()
        CircleGlassImage(image: Image("turtlerock"),borderwidth: 2)
            .frame(width: 200, height: 200)
    }
}
