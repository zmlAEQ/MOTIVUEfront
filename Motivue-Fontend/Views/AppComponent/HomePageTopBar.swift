//
//  HomePageTopBar.swift
//  SwiftUIstudy
//
//  Created by JangeJason on 2025/9/12.
//

import SwiftUI

struct HomePageTopBar: View {
    var image: Image = Image("turtlerock")
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 0, style: .continuous)
//                .glassEffect(in: .rect(cornerRadius: 0))// 玻璃质感
                .fill(.thinMaterial)
                .background(Color.white.opacity(0.2))
                .overlay( // 给边框一点高光
            RoundedRectangle(cornerRadius: 0, style: .continuous)
                .stroke(LinearGradient(colors:[.white.opacity(1),.white.opacity(1)], startPoint: .topLeading,endPoint: .bottomTrailing),
                        lineWidth: 1)
            )
            .frame(maxWidth: .infinity)      // 宽度填满父容器
            .padding(.horizontal,-10)        // 两边留间距
            .offset(y:-2)
            GeometryReader{ geo in
                let barHeight = geo.size.height
                let imageSize = barHeight * 0.4  // 图片直径为导航栏高度的 70%
                let dateFontSize = barHeight * 0.1 // 日期字体大小为高度的 15%
                let greetingFontSize = barHeight * 0.25 // 问候语字体大小为高度的 25%
                
                HStack{
                    VStack(alignment: .leading){
                        Text(getCurrentDate())
                            .font(.system(size: dateFontSize))
                            .foregroundColor(.white)
                        Text(getGreeting())
                            .font(.system(size: greetingFontSize))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                Spacer()
                CircleGlassImage(image: image,borderwidth: 1)
                        .frame(width: imageSize,height: imageSize)
                }
                .padding(.horizontal, 20) // 稍微增加一点左右边距
                .frame(width: geo.size.width, height: geo.size.height)
                .offset(y: dateFontSize * 1.5)
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(5/1.5, contentMode: .fit)
    }
    
    
    // 获取当前日期（格式化）
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: Date())
    }
    
    // 获取问候语
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour < 12 {
            return "Good Morning！"
        } else if hour < 18 {
            return "Good Noon！"
        } else {
            return "Good Night！"
        }
    }
}

//按如下方式使用
#Preview("使用示例"){
    ScrollView{
        HealthStatsCard(consumption: 0.7, recovery: 0.5, sleep: 0.9)
        HStack(spacing:10){
            GlassCard(cornerRadius: 30, aspectRatio: 5/4.5)
                .overlay(
                    ArcCardView()
                )
            GlassCard(cornerRadius: 30, aspectRatio: 5/4.5)
                .overlay(
                    LineCardView(value: [0.2,0.3,0.6],title: "Battery")
                )
        }
        .padding(.horizontal,20)
        HStack(spacing:10){
            GlassCard(cornerRadius: 30, aspectRatio: 5/3.5)
                .overlay(
                    HBarCardView()
                )
            GlassCard(cornerRadius: 30, aspectRatio: 5/3.5)
                .overlay(
                    TwoHBarCardView() // ✨ 在这里嵌入
                )
        }
        .padding(.horizontal,20)
            GlassCircle(width: 100)
            GlassCircle(width: 100)
            GlassCircle(width: 100)
            GlassCircle(width: 100)
            GlassCircle(width: 100)
            GlassCircle(width: 100)
            GlassCircle(width: 100)
            GlassCircle(width: 100)
        .frame(maxWidth: .infinity)
    }
    .background(
        AppBackGround(colors: [Color(hex: "97c3c9"),Color(hex: "c19e88"),Color(hex: "dfd7c5")])
    )
    .safeAreaInset(edge: .top){
        HomePageTopBar(image: Image("rainbowlake"))
    }
    .ignoresSafeArea(edges: .top)
}

//单独组件预览
#Preview("单独组件预览"){
    HomePageTopBar()
}
