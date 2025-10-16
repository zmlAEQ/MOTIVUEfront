//
//  2HBarCardView.swift
//  SwiftUIstudy
//
//  Created by JangeJason on 2025/9/18.
//

import SwiftUI

struct TwoHBarCardView: View {
    var Firstvalue: Int = 1935
    var Secondvalue: Int = 1675
    var title: String = "Energy"
    var icon: Image = Image(systemName: "moon.stars.fill")
    
    // 根据值返回状态和颜色 (针对 Recovery 的逻辑)

    var body: some View {
        let totalvalue: Int = Secondvalue - Firstvalue
        let firstrate: Double = Double(Firstvalue) / Double(Secondvalue + Firstvalue)
        let secondrate: Double = 1 - firstrate
        
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
                        Text("\(Int(totalvalue))")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        Text("kcal")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                    }
                }
                Spacer(minLength: 10)
                
                // 底行：横向柱状图
                HBarGauge(value: firstrate,highlightColors:[Color(hex: "#a981f5"), Color(hex: "#5807f0")],gapWidth: 2)
                    .frame(height: geo.size.height * 0.1)
                    .padding(.bottom,geo.size.height * 0.05)
                HBarGauge(value: secondrate,gapWidth: 2)
                    // 给它一个合适的高度
                    .frame(height: geo.size.height * 0.1)
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
                TwoHBarCardView() // ✨ 在这里嵌入
            )
            .padding()
    }
    
}
