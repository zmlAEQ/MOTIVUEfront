//
//  ArcGauge.swift
//  SwiftUIstudy
//
//  Created by JangeJason on 2025/9/14.
//

import SwiftUI

// ✨ 1. 修改后的 ArcGauge
struct ArcGauge: View {
    var value: Double
    var segmentCount: Int = 4
    var highlightColors: [Color] = [.cyan, .blue]
    private let totalAngle: Double = 130
    
    var body: some View {
        GeometryReader { geo in
            // ✨ 动态计算半径和中心点
            let radius = min(geo.size.width, geo.size.height)
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height + radius * 0.2)
            
            ZStack {
                // 背景段落
                ForEach(0..<segmentCount, id: \.self) { i in
                    SegmentShape(center:center, radius: radius,segment: i, total: segmentCount, totalAngle: totalAngle)
                        .stroke(style: StrokeStyle(lineWidth: 8,lineCap: .round))
                        .opacity(0.4)
                }
                
                // 高亮段落
                let currentIndex = min(Int(value * Double(segmentCount)), segmentCount - 1)
                let gradient = LinearGradient(colors: highlightColors, startPoint: .leading, endPoint: .trailing)
                SegmentShape(center:center,radius: radius, segment: currentIndex, total: segmentCount, totalAngle: totalAngle)
                    .stroke(gradient, style: StrokeStyle(lineWidth: 8, lineCap: .round))

                // 指示器和辉光
                let thumbAngle = Angle.degrees(totalAngle * value + 25)
                
                Circle() // 辉光
                    .fill(RadialGradient(colors: [highlightColors.first ?? .blue, .clear], center: .center, startRadius: 5, endRadius: 15))
                    .frame(width: 30, height: 30)
                    .position(x: center.x - radius * cos(CGFloat(thumbAngle.radians)), y: center.y - radius * sin(CGFloat(thumbAngle.radians)))

                Circle() // 指示器
                    .fill(Color.white)
                    .frame(width: 12, height: 12)
                    .overlay(Circle().fill(highlightColors.first ?? .blue).frame(width: 8, height: 8))
                    .position(x: center.x - radius * cos(CGFloat(thumbAngle.radians)), y: center.y - radius * sin(CGFloat(thumbAngle.radians)))
            }
        }
    }
}

struct SegmentShape: Shape {
    var center: CGPoint
    var radius: CGFloat
    var segment: Int
    var total: Int
    var totalAngle: Double
    
    private var startAngle: Angle {
        .degrees(Double(segment) / Double(total) * totalAngle - totalAngle / 2 - 87)
    }
    
    private var endAngle: Angle {
        .degrees(Double(segment + 1) / Double(total) * totalAngle - totalAngle / 2 - 93)
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        // ✨ 关键修复：使用自己绘图区域 rect 的中心点
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return path
    }
}

#Preview {
    ZStack{
        AppBackGround()
        GlassCard(cornerRadius: 30, aspectRatio: 1)
            .overlay(
                ArcCardView(value: 0.6, title: "stress") // ✨ 在这里嵌入
            )
            .padding()
    }
}
