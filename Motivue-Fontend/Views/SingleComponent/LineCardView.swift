//
//  LineCardView.swift
//  SwiftUIstudy
//
//  Created by JangeJason on 2025/9/19.
//

import SwiftUI

struct LineCardView: View {
    // 示例数据，带默认值
    var value: [Double] = [0.2,0.35]
    var title: String = "Stress"
    var icon: Image = Image(systemName: "brain.head.profile")
    
    // 根据压力值返回状态和颜色
    private var status: (text: String, color: Color) {
        // 检查 value.last 是否有值，如果有，就把它赋给 lastValue 常量
        guard let lastValue = value.last else {
            // 如果数组为空 (value.last 是 nil)，则返回一个默认状态
            return ("N/A", .gray)
        }
        
        switch lastValue {
        case 0..<0.25:
            return ("Relaxed", .green)
        case 0.25..<0.5:
            return ("Normal", .blue)
        case 0.5..<0.75:
            return ("Elevated", .orange)
        default:
            return ("High", .red)
        }
    }

    var body: some View {
        GeometryReader{ geo in
            VStack(alignment: .leading,spacing: 0) {
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
                    Text("\(Int((value.last ?? 0.0) * 100))")
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
                
                Spacer() // 推送仪表盘到底部
                
                // 底行：仪表盘
                LineGauge(dataPoints: value)
                    .frame(height: geo.size.height * 0.45)
                    .padding(.bottom,geo.size.height * 0.05)// 给底部留一点空间
    //                    .offset(y:50)
            }
        }
        .padding() // 整个卡片的内边距
        .foregroundColor(.white)
        
    }
}

#Preview {
    ZStack{
        AppBackGround(colors: [.gray])
        HStack(spacing:15){
            GlassCard(cornerRadius: 30, aspectRatio: 5/4.5)
                .overlay(
                    LineCardView(value:[0.7,0.4,0.2],title: "Stress") // ✨ 在这里嵌入
                )
            GlassCard(cornerRadius: 30, aspectRatio: 5/4.5)
                .overlay(
                    ArcCardView()
                )
        }
        .padding()

    }
}
