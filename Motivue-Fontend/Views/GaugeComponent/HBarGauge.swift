//
//  BarGauge.swift
//  SwiftUIstudy
//
//  Created by JangeJason on 2025/9/16.
//

import SwiftUI

struct HBarGauge: View {
    let value: Double // 当前值 (0.0 - 1.0)
    
    // --- 可自定义的参数 ---
    var highlightColors: [Color] = [Color(hex: "#FEE440"), Color(hex: "#00B392")]
    var backgroundColor: Color = .white.opacity(0.2)
    var gapWidth: CGFloat = 4 // ✨ 新增：控制中间间隙的宽度
    
    var body: some View {
        GeometryReader { geo in
            // ✨ 核心逻辑：计算左、中、右三部分的宽度
            
            // 总宽度
            let totalWidth = geo.size.width
            
            // 间隙的中心点位置
            let gapCenterPosition = totalWidth * value
            
            // 左侧彩色条的宽度 (需要处理边界情况，不能小于0)
            let leftBarWidth = max(0, gapCenterPosition - (gapWidth / 2))
            
            // 右侧灰色条的宽度 (同样处理边界情况)
            let rightBarWidth = max(0, totalWidth - (gapCenterPosition + (gapWidth / 2)))
            
            HStack(spacing: 0) {
                // 1. 左侧彩色条
                Rectangle()
                    .fill(LinearGradient(colors: highlightColors, startPoint: .leading, endPoint: .trailing))
                    .frame(width: leftBarWidth)
                    .clipShape(Capsule())
                // 2. 中间的间隙
                Rectangle()
                    .fill(Color.clear) // 透明色
                    .frame(width: gapWidth)
                
                // 3. 右侧灰色条
                Capsule()
                    .fill(.thinMaterial)
                    .frame(width: rightBarWidth)
                    .background(Capsule().fill(.white.opacity(0.2)))
//                    .glassEffect().opacity(0.3)
                    .overlay(
                        Capsule() // 形状要和我们最终裁剪的形状一致
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.4), .white.opacity(0.2)], // 从半透明白到透明
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1 // 边框线宽
                            )
                        )
            }
            // ✨ 将三部分整体裁剪成胶囊形状
            .animation(.spring(), value: value)
        }
    }
}

#Preview {
    ZStack{
        AppBackGround()
        HBarGauge(value:0.3)
            .frame(height: 30)
    }
    
}
