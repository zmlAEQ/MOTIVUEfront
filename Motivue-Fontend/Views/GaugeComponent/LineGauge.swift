//
//  LineGauge.swift
//  SwiftUIstudy
//
//  Created by JangeJason on 2025/9/15.
//

import SwiftUI

import SwiftUI

struct LineGauge: View {
    var dataPoints: [Double] = [0.1, 0.12, 0.15, 0.2, 0.28, 0.4, 0.55, 0.63]
    var gridLineCount: Int = 4
    var endpointRadius: CGFloat = 6
    var gradientColors: [Color] = [Color(hex: "#F55555"), .orange, .green]
    var body: some View {
        GeometryReader{geo in
            let chartHorizontalMargin: CGFloat = geo.size.width*0.06
            let chartVerticalMargin: CGFloat = geo.size.height*0.06
            Canvas { context, size in
                // --- 我们的“翻译官”函数 ---
                // 输入：数据点的索引 (第几个点)
                // 输出：该点在画布上的 (x, y) 坐标
                func point(for index: Int) -> CGPoint {
                    // 1. 计算 X 坐标
                    let drawableWidth = size.width - (chartHorizontalMargin*2)
                    // b) 将数据点的索引均匀地映射到这个宽度上
                    let x = chartHorizontalMargin + drawableWidth * (Double(index) / Double(dataPoints.count - 1))
                    
                    // 2. 计算 Y 坐标
                    let y = size.height * (1 - dataPoints[index])
                    
                    return CGPoint(x: x, y: y)
                }
                guard !dataPoints.isEmpty else { return } // 确保有数据
                // --- 绘制网格 ---
                let gridPath = Path { path in
                    // 水平虚线基线 (在画布底部)
                    path.move(to: CGPoint(x: chartHorizontalMargin, y: size.height-chartVerticalMargin))
                    path.addLine(to: CGPoint(x: size.width-chartHorizontalMargin, y: size.height-chartVerticalMargin))
                    // 垂直实线
                    for i in 0..<gridLineCount {
                        let x = chartHorizontalMargin + (size.width - chartHorizontalMargin * 2) * (Double(i) / Double(gridLineCount - 1))
                        path.move(to: CGPoint(x: x, y: chartVerticalMargin))
                        path.addLine(to: CGPoint(x: x, y: size.height-chartVerticalMargin))
                    }
                }
                // 使用 context 工具，用半透明白色来“描边”我们刚刚规划好的路径
                context.stroke(gridPath, with: .color(.white.opacity(0.4)), style: StrokeStyle(
                    lineWidth: 4,
                    lineCap: .round // ✅ 将线帽样式设置为圆角
                ))
                // --- 构建折线路径 ---
                let linePath = Path { path in
                    // 1. 获取第一个和最后一个数据点的Y坐标
                    let firstDataPointY = point(for: 0).y
                    let lastDataPointY = point(for: dataPoints.count - 1).y
                    
                    // 2. 画起始的水平线
                    // a) 将“画笔”移动到画布的最左侧，与第一个点同高
                    path.move(to: CGPoint(x: chartHorizontalMargin, y: firstDataPointY))
                    // b) 从该点画一条线到第一个数据点的实际位置
                    path.addLine(to: point(for: 0))
                    
                    // 3. 画中间的数据折线
                    // addLines 会自动将所有坐标点依次连接起来
                    path.addLines(dataPoints.indices.map(point))
                    
                    // 4. 画末尾的水平线
                    // 从最后一个数据点的位置，画一条线到画布的最右侧
                    path.addLine(to: CGPoint(x: size.width-chartHorizontalMargin, y: lastDataPointY))
                }
                let shading = GraphicsContext.Shading.linearGradient(
                    Gradient(colors: gradientColors),
                    startPoint: .zero, // 左上角 (0, 0)
                    endPoint: CGPoint(x: size.width, y: 0) // 右上角
                )
                // 先用一种简单的颜色把路径画出来看看效果
                context.stroke(
                    linePath,
                    with: shading, // 暂时用绿色
                    style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [2, 4])
                )
                // 1. 计算出指示器应该在的精确位置
                let lastDataPointY = point(for: dataPoints.count - 1).y
                let finalIndicatorPoint = CGPoint(x: size.width-chartHorizontalMargin, y: lastDataPointY)
                //实心圆
                let endpointPath = Path(ellipseIn: CGRect(origin: .zero, size: CGSize(width: endpointRadius * 2, height: endpointRadius * 2))).offsetBy(dx: finalIndicatorPoint.x - endpointRadius, dy: finalIndicatorPoint.y - endpointRadius)
                    context.fill(endpointPath, with: .color(gradientColors.last ?? .white))
                // 2. 绘制辉光 (一个模糊的、大的径向渐变圆)
                let glowPath = Path(ellipseIn: CGRect(origin: .zero, size: CGSize(width: endpointRadius * 4, height: endpointRadius * 4))).offsetBy(dx: finalIndicatorPoint.x - endpointRadius * 2, dy: finalIndicatorPoint.y - endpointRadius * 2)
                context.fill(glowPath, with: .radialGradient(
                    Gradient(colors: [gradientColors.last ?? .white, .clear]),
                    center: finalIndicatorPoint,
                    startRadius: 0,
                    endRadius: endpointRadius * 2
                ))
            }
        }
    }
}

#Preview {
    ZStack{
        AppBackGround(colors: [.gray])
        ScrollView{
            GlassCard(cornerRadius: 15, aspectRatio: 5/4)
                .overlay(
                    LineGauge(dataPoints: [0.1,0.3,0.4,0.7])
                        .frame(height: 50)
                )
    //            .frame(width: 250)
                .padding()
            GlassCard(cornerRadius: 15, aspectRatio: 5/4)
                .overlay(
                    ArcGauge(value: 0.3)
                )
    //            .frame(width: 250)
                .padding()
        }
    }
}
