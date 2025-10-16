//
//  HomePage.swift
//  SwiftUIstudy
//
//  Created by JangeJason on 2025/9/19.
//

import SwiftUI

struct HomePage: View {
    @StateObject private var healthKitManager = HealthKitManager()
    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                if healthKitManager.isAuthorized {

                } else {
                    ZStack{
                        GlassCard(cornerRadius: 30, aspectRatio: 5/1.5)
                        VStack(spacing: 15){
                            Text("连接到 Apple 健康以体验完整内容。")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                            // ✨ 3. 点击按钮，调用 manager 的请求函数
                            Button("连接到健康") {
                                healthKitManager.requestAuthorization()
                            }
                            .buttonStyle(.borderedProminent)
        //                    .glassEffect()
                        }
                    }
                    .padding(.horizontal,20)
                }
            }
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
}

#Preview {
    HomePage()
}
