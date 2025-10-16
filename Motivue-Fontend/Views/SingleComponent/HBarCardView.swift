//
//  HBarCardView.swift
//  SwiftUIstudy
//
//  Created by JangeJason on 2025/9/16.
//

import SwiftUI

struct HBarCardView: View {
    // 外部传入的参数
    var value: Double = 0.3
    var title: String = "Recovery"
    var icon: Image = Image(systemName: "moon.stars.fill")
    
    // 根据值返回状态和颜色 (针对 Recovery 的逻辑)
    private var status: (text: String, color: Color) {
        switch value {
        case 0..<0.33:
            return ("Low", .red)
        case 0.33..<0.66:
            return ("Ready", Color(hex: "#2DE8B2")) // 使用图片中的青色
        default:
            return ("Optimal", .green)
        }
    }

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                // 文字区域
                VStack(alignment: .leading) {
                    // 顶行：标题和图标
                    HStack {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        icon
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    // 中间行：数值和状态
                    HStack(alignment: .lastTextBaseline) {
                        Text("\(Int(value * 100))")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        Text("%")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                        Text(status.text)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(status.color)
                    }
                }
                
                Spacer(minLength: 10)
                
                // 底行：横向柱状图
                HBarGauge(value: value)
                    // 给它一个合适的高度
                    .frame(height: geo.size.height * 0.2)
            }
        }
        .padding(20)
        .foregroundColor(.white)
    }
}

#Preview {
    ZStack{
        AppBackGround()
        GlassCard(cornerRadius: 30, aspectRatio: 5/4.5)
            .overlay(
                HBarCardView() // ✨ 在这里嵌入
            )
            .padding()
    }
    
}
