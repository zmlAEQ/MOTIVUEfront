//
//  HomePage3Status.swift
//  SwiftUIstudy
//
//  Created by JangeJason on 2025/9/12.
//

import SwiftUI

// 单个圆环进度视图
struct CircularProgressView: View {
    let progress: Double
    let label: String
    let dimension: CGFloat
    let gradientColors:[Color]

    var body: some View {
        
        let gradient = AngularGradient(
                    gradient: Gradient(colors: gradientColors), // ✨ 使用传入的颜色
                    center: .center,
                    startAngle: .degrees(0),
                    endAngle: .degrees(360 * progress)
                )
        
        VStack(spacing: dimension * 0.1) {
            ZStack {
                // 背景圆环
                Circle()
                    .stroke(Color.black.opacity(0.1), lineWidth: dimension * 0.1)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2) // 给背景增加一点阴影

                // ✨ 辉光层
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(gradient, style: StrokeStyle(lineWidth: dimension * 0.1, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .blur(radius: dimension * 0.08) // 辉光的模糊半径
                    .opacity(0.8) // 辉光的强度

                // 进度圆环 (主层)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(gradient, style: StrokeStyle(lineWidth: dimension * 0.1, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                // 中间的百分比文字
                Text("\(Int(progress * 100))%")
                    .font(.system(size: dimension * 0.2, weight: .bold, design: .rounded)) // ✨ 使用圆体
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2)
            }
            .frame(width: dimension, height: dimension)
            // ✨ 当 progress 值变化时，以弹簧动画形式展现
            .animation(.interactiveSpring(response: 1, dampingFraction: 0.8, blendDuration: 1), value: progress)

            // 底部的标签文字
            Text(label)
                .font(.system(size: dimension * 0.2, weight: .medium, design: .rounded)) // ✨ 使用圆体
                .foregroundColor(.white.opacity(0.8))
                .shadow(color: .black.opacity(0.3), radius: 2)
        }
    }
}

// 主卡片视图
struct HealthStatsCard: View {
    
//---------可传入参数---------------------------------------------
    // 圆环进度（带默认值）
    var consumption: Double = 0.70
    var recovery: Double = 0.50
    var sleep: Double = 0.90
    // 标签（带默认值）
    var consumptionLabel: String = "消耗"
    var recoveryLabel: String = "恢复"
    var sleepLabel: String = "睡眠"
    //圆环颜色（带默认值）
    var consumptionColors: [Color] = [Color(hex: "#a8b775"), Color(hex: "#e0ba37"), Color(hex: "#f8ed98")]
    var recoveryColors: [Color]    = [Color(hex: "#6ea3c3"), Color(hex: "#0e96a1"), Color(hex: "#117177")]
    var sleepColors: [Color]       = [Color(hex: "#7998c3"), Color(hex: "#5480b5"), Color(hex: "#5280b3")]
//--------------------------------------------------------------
    var body: some View {
        ZStack {
            // 1. 底层：你的玻璃卡片背景
            GlassCard(cornerRadius: 30, aspectRatio: 5/2.1)
                .padding(.horizontal,20)
            // 2. 上层：使用 GeometryReader 获取内部可用空间
            GeometryReader { geo in
                
                let horizontalPadding: CGFloat = 90 // 左右各20
                
                // 2. 计算出卡片真正的“内容宽度”
                let cardContentWidth = geo.size.width - horizontalPadding
                
                // 3. 根据内容宽度来计算间距和圆环尺寸
                let spacing = cardContentWidth * 0.1
                let ringDimension = (cardContentWidth - spacing * 2) / 3

                HStack(spacing: spacing) {
                    CircularProgressView(
                        progress: consumption,
                        label: "消耗",
                        dimension: ringDimension,
                        gradientColors: consumptionColors
                    )

                    CircularProgressView(
                        progress: recovery,
                        label: "恢复",
                        dimension: ringDimension,
                        gradientColors: recoveryColors
                    )

                    CircularProgressView(
                        progress: sleep,
                        label: "睡眠",
                        dimension: ringDimension,
                        gradientColors: sleepColors
                    )
                }
                // 让 HStack 在 GeometryReader 提供的空间内居中
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

#Preview("调用方式") {
    ZStack{
        AppBackGround(colors: [Color(hex: "97c3c9"),Color(hex: "c19e88"),Color(hex: "dfd7c5")])
        HealthStatsCard(consumption: 0.7, recovery: 0.5, sleep: 0.9)
    }
}
