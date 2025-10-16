//
//  CardView.swift
//  SwiftUIstudy
//
//  Created by JangeJason on 2025/9/12.
//

import SwiftUI

struct GlassCard: View {
    var cornerRadius: CGFloat        // 圆角
    var aspectRatio: CGFloat         // 宽高比例 (比如 5/2)
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.thinMaterial)
            // 在材质下方叠加一个半透明的深色背景，增加深度
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.white.opacity(0.2))
            )
//            .glassEffect(in: .rect(cornerRadius: cornerRadius)).opacity(0.3) // 一步生成玻璃质感
            
            .overlay( // 给边框一点高光
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(LinearGradient(colors:[.white.opacity(0.6),.white.opacity(0.6)], startPoint: .topLeading,endPoint: .bottomTrailing),
                            lineWidth: 2)
                )
        
            .frame(maxWidth: .infinity)      // 宽度填满父容器
            .aspectRatio(aspectRatio, contentMode: .fit)
    }
}

struct GlassCircle: View{
    var width: CGFloat
    
    var body: some View{
        Circle()
            .fill(.thinMaterial)
            // 同样，在材质下方叠加一个半透明的深色圆形背景
            .background(
                Circle().fill(.white.opacity(0.3))
            )
//            .glassEffect(in: .rect(cornerRadius: 180)).opacity(0.3)
            .frame(width: width)
            .overlay(
                    Circle().stroke(
                        LinearGradient(colors: [.white.opacity(1), .white.opacity(1)],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing),
                        lineWidth: 2
                    )
                )
    }
}


#Preview {
    ZStack{
        AppBackGround()
        ScrollView{
            VStack {
                ZStack {
                    GlassCard(cornerRadius: 30, aspectRatio: 5/2)
                    GlassCircle(width: 300)
                }
                ZStack {
                    GlassCard(cornerRadius: 30, aspectRatio: 5/2)
                    GlassCircle(width: 100)
                }
                HStack(spacing:10){
                    GlassCard(cornerRadius: 30, aspectRatio: 5/3.5)
                    GlassCard(cornerRadius: 30, aspectRatio: 5/3.5)
                }
                .padding(.horizontal,20)
            }
        }
    }
}
