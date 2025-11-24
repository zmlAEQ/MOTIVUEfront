//
//  ContentView.swift
//  Motivue
//
//  Created by JangeJason on 2025/9/20.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject private var appData: AppData
    @State private var selectedTab: Tab = .home
    @State private var showCalendarOverlay = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.08, green: 0.08, blue: 0.1), Color.black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer(minLength: 12)

                DeviceFrame {
                    ZStack(alignment: .bottom) {
                        Group {
                            switch selectedTab {
                            case .home:
                                HomeTabView(
                                    readiness: appData.readiness,
                                    consumption: appData.consumption,
                                    onShowCalendar: { showCalendarOverlay = true }
                                )
                                    .padding(.bottom, 88)
                            case .training:
                                TrainingTabView(consumption: appData.consumption)
                                    .padding(.bottom, 88)
                            case .journal:
                                JournalTabView()
                                    .padding(.bottom, 88)
                            case .sleep:
                                SleepTabView(readiness: appData.readiness)
                                    .padding(.bottom, 88)
                            case .me:
                                MeTabView(
                                    physioAge: appData.physioAge,
                                    baseline: appData.baseline,
                                    weeklyReport: appData.weeklyReport
                                )
                                    .padding(.bottom, 88)
                            }
                        }
                        TabBarView(selectedTab: $selectedTab)
                            .padding(.bottom, 4)

                        // Overlays
                        if showCalendarOverlay {
                            CalendarPickerOverlay(onClose: { showCalendarOverlay = false })
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                }
                .frame(width: 393, height: 852)
            }
        }
    }
}

// MARK: - Calendar Picker Overlay

private struct CalendarPickerOverlay: View {
    var onClose: () -> Void
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("October 2025")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 8)

                    HStack(spacing: 10) {
                        ForEach(["S","M","T","W","T","F","S"], id: \.self) { d in
                            Text(d)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                        }
                    }

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 14) {
                        ForEach(sampleDays, id: \.self) { day in
                            VStack(spacing: 6) {
                                Text(day.label)
                                    .font(.system(size: 13, weight: day.isSelected ? .bold : .medium))
                                    .foregroundColor(day.isDimmed ? .gray.opacity(0.6) : .white)
                                    .frame(width: 32, height: 32)
                                    .background(
                                        day.isSelected ? Color.white : Color.clear
                                    )
                                    .foregroundColor(day.isSelected ? .black : (day.isDimmed ? .gray : .white))
                                    .clipShape(Circle())

                                if let dot = day.dotColor {
                                    Circle()
                                        .fill(dot)
                                        .frame(width: 6, height: 6)
                                } else {
                                    Color.clear.frame(width: 6, height: 6)
                                }
                            }
                        }
                    }
                }
                .padding(18)
                .background(Color(red: 0.11, green: 0.11, blue: 0.12).opacity(0.95))
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )

                Button(action: onClose) {
                    Text("Close")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 18)
        }
    }

    private var sampleDays: [CalendarDay] {
        [
            .init(label: "29", isDimmed: true, dotColor: nil, isSelected: false),
            .init(label: "30", isDimmed: true, dotColor: nil, isSelected: false),
            .init(label: "1", isDimmed: false, dotColor: nil, isSelected: false),
            .init(label: "2", isDimmed: false, dotColor: nil, isSelected: false),
            .init(label: "3", isDimmed: false, dotColor: .green, isSelected: false),
            .init(label: "4", isDimmed: false, dotColor: .green, isSelected: false),
            .init(label: "5", isDimmed: false, dotColor: .yellow, isSelected: false),
            .init(label: "6", isDimmed: false, dotColor: .red, isSelected: false),
            .init(label: "7", isDimmed: false, dotColor: .green, isSelected: false),
            .init(label: "8", isDimmed: false, dotColor: .green, isSelected: false),
            .init(label: "9", isDimmed: false, dotColor: .green, isSelected: false),
            .init(label: "10", isDimmed: false, dotColor: .green, isSelected: false),
            .init(label: "11", isDimmed: false, dotColor: .green, isSelected: false),
            .init(label: "12", isDimmed: false, dotColor: .yellow, isSelected: false),
            .init(label: "13", isDimmed: false, dotColor: .green, isSelected: false),
            .init(label: "14", isDimmed: false, dotColor: .yellow, isSelected: false),
            .init(label: "15", isDimmed: false, dotColor: .red, isSelected: false),
            .init(label: "16", isDimmed: false, dotColor: .yellow, isSelected: false),
            .init(label: "17", isDimmed: false, dotColor: .green, isSelected: false),
            .init(label: "18", isDimmed: false, dotColor: .green, isSelected: true)
        ]
    }
}

private struct CalendarDay: Hashable {
    let label: String
    let isDimmed: Bool
    let dotColor: Color?
    let isSelected: Bool
}

// MARK: - Readiness Factors Overlay

private struct InlineReadinessFactorsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Readiness Factors")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            Text("Why your score is 85 today")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray)

            VStack(spacing: 10) {
                factorRow(title: "HRV Balance", status: "Boosting", statusColor: .green, detail: "Within optimal range (82ms)", progress: 0.85, icon: "heart")
                factorRow(title: "Sleep Perf.", status: "Optimal", statusColor: .blue, detail: "Exceeded baseline (+0.6h)", progress: 0.75, icon: "moon.fill")
                factorRow(title: "Recovery Index", status: "Strain", statusColor: .orange, detail: "High load last 3 days", progress: 0.6, icon: "bolt.fill")
            }
        }
    }

    private func factorRow(title: String, status: String, statusColor: Color, detail: String, progress: CGFloat, icon: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(statusColor.opacity(0.12))
                    .frame(width: 42, height: 42)
                Image(systemName: icon)
                    .foregroundColor(statusColor)
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Text(status)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(statusColor)
                }
                Text(detail)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.gray)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 8)
                        RoundedRectangle(cornerRadius: 6)
                            .fill(statusColor)
                            .frame(width: geo.size.width * progress, height: 8)
                    }
                }
                .frame(height: 8)
            }
        }
        .padding(12)
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

// MARK: - Report Tab (Weekly AI Report)

private struct ReportTabView: View {
    var report: WeeklyReportResponse?
    var onDismiss: (() -> Void)? = nil

    private let loadBars: [CGFloat] = [0.6, 0.7, 1.0, 0.4, 0.3, 0.8, 0.2]
    private let readinessPoints: [CGFloat] = [0.9, 0.85, 0.7, 0.6, 0.65, 0.8, 0.88]
    private var titleText: String {
        // Try to derive from markdown heading if present
        if let md = report?.finalReport?.markdownReport,
           let line = md.split(separator: "\n").first,
           line.starts(with: "#") {
            return line.replacingOccurrences(of: "#", with: "").trimmingCharacters(in: .whitespaces)
        }
        return "Weekly Overview"
    }
    private var phaseLabel: String {
        report?.finalReport?.persisted == true ? "Phase 5 Report" : "Phase 5 Preview"
    }
    private var ctaText: [String] {
        report?.finalReport?.callToAction ?? ["控制高强度日 2 天以内", "保持睡眠 >7.6h"]
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 0.05, green: 0.05, blue: 0.06)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    StatusBarView(timeText: "9:41")
                        .padding(.top, 6)
                        .padding(.horizontal, 24)

                    ReportNavHeader(onDismiss: onDismiss)
                        .padding(.horizontal, 20)
                        .padding(.top, -8)

                    ReportTitleHero(title: titleText, phase: phaseLabel)
                        .padding(.horizontal, 20)

                    // Export PDF placeholder; wire to actual PDF export when backend ready
                    Button(action: {
                        // TODO: hook up to PDF export endpoint / file renderer
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "doc.richtext")
                                .font(.system(size: 14, weight: .bold))
                            Text("Export Full Report (PDF)")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 20)

                    ReportHeroScoreCard()
                        .padding(.horizontal, 20)

                    ReportSummaryCard()
                        .padding(.horizontal, 20)

                    ReportTrendSection(loadBars: loadBars, readinessPoints: readinessPoints)
                        .padding(.horizontal, 20)

                    ReportMetricsHighlights()
                        .padding(.horizontal, 20)

                    ReportDailyBreakdown()

                    ReportKeyDaysSection()
                        .padding(.horizontal, 20)

                    ReportRadarSection()
                        .padding(.horizontal, 20)

                    ReportPlanSection()
                        .padding(.horizontal, 20)

                    ReportFooterNote()
                        .padding(.horizontal, 32)

                    Spacer(minLength: 24)
                }
                .padding(.top, 12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.green.opacity(0.08), Color.clear]),
                        startPoint: .top,
                        endPoint: .center
                    )
                    .ignoresSafeArea(edges: .top)
                )
            }
        }
    }
}

private struct ReportNavHeader: View {
    var onDismiss: (() -> Void)? = nil
    var body: some View {
        HStack {
            Button(action: { onDismiss?() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Oct 12 - Oct 18")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white.opacity(0.9))
            Spacer()
            Button(action: {}) {
                Image(systemName: "arrow.down.to.line.alt")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
        }
    }
}

private struct ReportTitleHero: View {
    var title: String = "Weekly Overview"
    var phase: String = "Phase 5 Report"
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(phase)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.blue)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.15))
                .cornerRadius(8)
            Text(title)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            Text("Generated by Motivue AI Coach")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(.top, 8)
    }
}

private struct ReportSummaryCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 16, weight: .bold))
                Text("Executive Summary")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 10) {
                summaryRow(bulletColor: .blue, text: "本周训练 7 天，负荷峰值 500 AU，周末成功安排了恢复日。")
                summaryRow(bulletColor: .blue, text: "平均准备度 80.3，呈现“周中下降、周末回升”的健康趋势。")
                summaryRow(bulletColor: .blue, text: "ACWR 维持在 0.83 (最佳区间)，风控良好。")
            }
        }
        .padding(16)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
        .cornerRadius(22)
    }

    private func summaryRow(bulletColor: Color, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(bulletColor)
                .frame(width: 6, height: 6)
                .padding(.top, 6)
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct ReportTrendSection: View {
    let loadBars: [CGFloat]
    let readinessPoints: [CGFloat]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Readiness Trend")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.gray.opacity(0.9))
                    .tracking(1)
                Spacer()
                HStack(spacing: 12) {
                    legend(color: .green, title: "Score")
                    legend(color: .orange, title: "Load")
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.white.opacity(0.06), lineWidth: 1)
                        )

                    // Bars
                    HStack(alignment: .bottom, spacing: 6) {
                        ForEach(loadBars.indices, id: \.self) { idx in
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(idx == 3 ? Color.orange : Color.orange.opacity(0.6))
                                .frame(width: (geo.size.width - 48) / CGFloat(loadBars.count), height: 120 * loadBars[idx])
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)

                    // Line
                    Path { path in
                        let count = readinessPoints.count
                        guard count > 1 else { return }
                        let spacing = (geo.size.width - 40) / CGFloat(max(count - 1, 1))
                        for (idx, p) in readinessPoints.enumerated() {
                            let x = 20 + CGFloat(idx) * spacing
                            let y = geo.size.height - 40 - (120 * p)
                            if idx == 0 { path.move(to: CGPoint(x: x, y: y)) }
                            else { path.addLine(to: CGPoint(x: x, y: y)) }
                        }
                    }
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .shadow(color: Color.green.opacity(0.5), radius: 6)
                    .padding(.horizontal, 0)
                    .padding(.bottom, 0)
                }
            }
            .frame(height: 220)

            Text("* 图表显示：高负荷日导致准备度下滑，周末恢复明显。")
                .font(.system(size: 11, weight: .medium))
                .italic()
                .foregroundColor(.gray)
        }
    }

    private func legend(color: Color, title: String) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
        }
    }
}

private struct ReportKeyDaysSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Key Training Days")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            VStack(spacing: 10) {
                keyDayCard(date: "Oct 15", tag: "Acute Fatigue", tagColor: .red, title: "Strength: Legs", load: "500 AU", score: "72", scoreColor: .red)
                keyDayCard(date: "Oct 18", tag: "Peak", tagColor: .green, title: "Recovery Day", load: "120 AU", score: "85", scoreColor: .green)
                Button(action: {}) {
                    Text("View Full Table")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                }
            }
        }
    }

    private func keyDayCard(date: String, tag: String, tagColor: Color, title: String, load: String, score: String, scoreColor: Color) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(date)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                    Text(tag.uppercased())
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(tagColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(tagColor.opacity(0.15))
                        .cornerRadius(8)
                }
                HStack(spacing: 6) {
                    Text(title)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gray)
                    Circle().fill(Color.gray.opacity(0.6)).frame(width: 4, height: 4)
                    Text(load)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(score)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(scoreColor)
                Text("Score")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .padding(14)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(tagColor.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

private struct ReportRadarSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Hooper Subjective")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text("Oct 15 Peak")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(8)
            }

            ZStack {
                ForEach(1..<4) { i in
                    PolygonShape(sides: 4)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 0.8)
                        .scaleEffect(CGFloat(i) * 0.25 + 0.25)
                }
                PolygonShape(sides: 4)
                    .fill(Color.red.opacity(0.25))
                    .overlay(
                        PolygonShape(sides: 4)
                            .stroke(Color.red, lineWidth: 1.5)
                    )
                    .scaleEffect(0.7)
            }
            .frame(height: 200)

            Text("主观疲劳、酸痛和压力评分在 Oct 15 达到峰值，与客观数据高度吻合。")
                .font(.system(size: 12, weight: .medium))
                .italic()
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .cornerRadius(18)
    }
}

private struct PolygonShape: Shape {
    let sides: Int
    func path(in rect: CGRect) -> Path {
        guard sides >= 3 else { return Path() }
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        var path = Path()
        for i in 0..<sides {
            let angle = (Double(i) / Double(sides)) * (2 * Double.pi) - Double.pi / 2
            let pt = CGPoint(x: center.x + CGFloat(cos(angle)) * radius, y: center.y + CGFloat(sin(angle)) * radius)
            if i == 0 { path.move(to: pt) } else { path.addLine(to: pt) }
        }
        path.closeSubpath()
        return path
    }
}

private struct ReportPlanSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Next Week Plan")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(Color.green.opacity(0.15))
                        .frame(width: 30, height: 30)
                        .overlay(
                            Image(systemName: "bolt.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 14, weight: .bold))
                        )
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Strategy: Impact Week")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.green)
                        Text("本周 ACWR 良好，下周适合负荷冲击，但需注意恢复。")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    checklistRow(text: "负荷管理：高强度日控制在 2 天以内，间隔 48 小时。")
                    checklistRow(text: "部位均衡：下周注意全身均衡，避免过度侧重腿部。")
                    checklistRow(text: "阈值提醒：准备度 < 65 分时立即降阶训练。")
                }
            }
            .padding(16)
            .background(Color.green.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.green.opacity(0.2), lineWidth: 1)
            )
            .cornerRadius(20)

            Button(action: {}) {
                Text("Accept Plan")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .cornerRadius(16)
            }
        }
    }

    private func checklistRow(text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(Color.green.opacity(0.2))
                .frame(width: 18, height: 18)
                .overlay(
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                )
                .padding(.top, 2)
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray.opacity(0.95))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct ReportFooterNote: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("\"本周你展现了出色的恢复能力，尤其是在周中高负荷后能迅速调整。期待你下周的精彩表现！\"")
                .font(.system(size: 12, weight: .medium))
                .italic()
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Rectangle()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 4)
                .cornerRadius(4)
        }
    }
}

// MARK: - Sleep Tab

private struct SleepTabView: View {
    var readiness: ReadinessResponse

    private var sleepScore: Int {
        // Placeholder derived score; could replace with backend sleep score if provided
        if let eff = readiness.metrics?.sleepEfficiency {
            return Int((eff * 100).rounded())
        }
        return 78
    }
    private var timeAsleep: String {
        if let h = readiness.sleepDurationHours {
            return String(format: "%.1f h", h)
        }
        return "6h 42m"
    }
    private var restorative: String {
        if let r = readiness.metrics?.restorativeRatio {
            return String(format: "%.0f%%", r * 100)
        }
        return "42%"
    }
    private var sleepEfficiency: String {
        if let eff = readiness.metrics?.sleepEfficiency {
            return String(format: "%.0f%%", eff * 100)
        }
        return "86%"
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.15), Color.black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    StatusBarView(timeText: "9:41")
                        .padding(.top, 6)
                        .padding(.horizontal, 24)

                    SleepHeaderView()
                        .padding(.horizontal, 24)

                    SleepScoreHero(score: sleepScore, timeAsleep: timeAsleep)
                        .padding(.horizontal, 20)

                    SleepHypnogramCard()
                        .padding(.horizontal, 20)

                    SleepMetricsGrid(
                        efficiencyText: sleepEfficiency,
                        restorativeText: restorative
                    )
                        .padding(.horizontal, 16)

                    SleepInsightCard()
                        .padding(.horizontal, 20)

                    SleepConsistencyCard()
                        .padding(.horizontal, 20)

                    Spacer(minLength: 24)
                }
                .padding(.top, 6)
            }
        }
    }
}

private struct SleepHeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Last Night")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.blue)
                    .tracking(1.2)
                Text("Sleep")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(-0.5)
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "pencil")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.gray)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.06))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }
}

private struct SleepScoreHero: View {
    let score: Int
    let timeAsleep: String
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(score)")
                        .font(.system(size: 64, weight: .black))
                        .foregroundColor(.white)
                        .tracking(-2)
                    Text("/100")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.gray)
                }
                Text("Fair Quality")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.12))
                    .cornerRadius(8)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text("Time Asleep")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.gray)
                    .tracking(1)
                Text(timeAsleep)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 4)
        }
    }
}

private struct SleepHypnogramCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Stages")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.gray.opacity(0.9))
                    .tracking(1)
                Spacer()
                HStack(spacing: 8) {
                    legend(color: .red, title: "Awake")
                    legend(color: Color.blue.opacity(0.6), title: "REM")
                    legend(color: Color.blue, title: "Light")
                    legend(color: Color.indigo, title: "Deep")
                }
            }

            HStack(alignment: .bottom, spacing: 3) {
                stageBar(height: 1.0, color: .red.opacity(0.3))
                stageBar(height: 0.4, color: .blue)
                stageBar(height: 0.2, color: .indigo)
                stageBar(height: 0.4, color: .blue)
                stageBar(height: 0.7, color: Color.blue.opacity(0.6))
                stageBar(height: 1.0, color: .red.opacity(0.3))
                stageBar(height: 0.4, color: .blue)
                stageBar(height: 0.2, color: .indigo)
                stageBar(height: 0.7, color: Color.blue.opacity(0.6))
                stageBar(height: 0.4, color: .blue)
                stageBar(height: 1.0, color: .red.opacity(0.3))
            }
            .frame(height: 130)
            .background(Color.black.opacity(0.2))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )

            HStack {
                Text("10:30 PM")
                Spacer()
                Text("2:00 AM")
                Spacer()
                Text("6:15 AM")
            }
            .font(.system(size: 9, weight: .medium))
            .foregroundColor(.gray)
        }
        .padding(14)
        .background(Color(red: 0.09, green: 0.09, blue: 0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .cornerRadius(16)
    }

    private func legend(color: Color, title: String) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(title)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.gray)
        }
    }

    private func stageBar(height: CGFloat, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(color)
            .frame(width: 14, height: 120 * height)
    }
}

private struct SleepMetricsGrid: View {
    let efficiencyText: String
    let restorativeText: String
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
            metricCard(title: "Efficiency", value: efficiencyText, subtitle: "Time in bed: 7h 48m", statusColor: .yellow)
            metricCard(title: "Restorative", value: restorativeText, subtitle: "Target: > 35%", statusColor: .green)
            metricCard(title: "Resp. Rate", value: "14.2", subtitle: "rpm (Stable)", statusColor: .green)
            metricCard(title: "Latency", value: "45m", subtitle: "Took too long", statusColor: .red)
        }
    }

    private func metricCard(title: String, value: String, subtitle: String, statusColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title.uppercased())
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.gray)
                Spacer()
                Circle()
                    .fill(statusColor)
                    .frame(width: 8, height: 8)
            }
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            Text(subtitle)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .topLeading)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

private struct SleepInsightCard: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Impact of Late Meal")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.blue)
                Text("You logged a Late Meal yesterday. This likely caused your higher latency (45m) and slightly elevated heart rate during the first 2 hours of sleep.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .background(Color(red: 0.07, green: 0.1, blue: 0.15))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

private struct SleepConsistencyCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bedtime Consistency")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.gray.opacity(0.9))
                .tracking(1)

            HStack(alignment: .bottom, spacing: 8) {
                consistencyBar(top: 8, bottom: 2)
                consistencyBar(top: 9, bottom: 2)
                consistencyBar(top: 6, bottom: 3)
                consistencyBar(top: 8, bottom: 2)
                consistencyBar(top: 10, bottom: 1)
                consistencyBar(top: 12, bottom: 2, highlight: true)
                consistencyBar(top: 11, bottom: 2, fade: true)
            }
            .frame(height: 120)

            HStack {
                Text("M"); Spacer(); Text("T"); Spacer(); Text("W"); Spacer(); Text("T"); Spacer(); Text("F"); Spacer(); Text("S"); Spacer(); Text("S")
            }
            .font(.system(size: 9, weight: .semibold, design: .monospaced))
            .foregroundColor(.gray)
        }
        .padding(14)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .cornerRadius(18)
    }

    private func consistencyBar(top: CGFloat, bottom: CGFloat, highlight: Bool = false, fade: Bool = false) -> some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(highlight ? Color.blue : Color.blue.opacity(fade ? 0.2 : 0.5))
            .frame(width: 12, height: max(20, 120 - top * 5))
            .overlay(
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 6)
                        .fill(highlight ? Color.blue.opacity(0.5) : Color.blue.opacity(0.25))
                        .frame(height: max(10, 20 + bottom * 2))
                }
            )
    }
}

// MARK: - Additional standalone screens (AI Sync + Physio Age Detail)

// Placeholder loading/sync page
private struct AISyncView: View {
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color.green.opacity(0.25), Color.black]), center: .center, startRadius: 50, endRadius: 400)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                ZStack {
                    Circle().stroke(Color.white.opacity(0.1), lineWidth: 1).frame(width: 180, height: 180).rotationEffect(.degrees(-10))
                    Circle().trim(from: 0, to: 0.9).stroke(Color.green.opacity(0.4), style: StrokeStyle(lineWidth: 3, lineCap: .round)).frame(width: 160, height: 160).rotationEffect(.degrees(-90)).animation(.linear(duration: 3).repeatForever(autoreverses: false), value: 1)
                    Circle().trim(from: 0, to: 0.8).stroke(Color.blue.opacity(0.4), style: StrokeStyle(lineWidth: 3, lineCap: .round)).frame(width: 140, height: 140).rotationEffect(.degrees(90)).animation(.linear(duration: 2.5).repeatForever(autoreverses: false), value: 1)
                    Circle().fill(Color.white.opacity(0.06)).frame(width: 110, height: 110).shadow(color: Color.green.opacity(0.3), radius: 14)
                    Image(systemName: "bolt.fill").foregroundColor(.white).font(.system(size: 30, weight: .bold))
                }
                Text("Good Morning")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Text("Preparing your daily insights...")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                VStack(alignment: .leading, spacing: 14) {
                    stepRow(title: "Syncing Biometrics", state: .done)
                    stepRow(title: "Running Readiness Engine", state: .processing, hint: "Analyzing HRV & Sleep impact...")
                    stepRow(title: "Updating Personal Baselines", state: .pending)
                }
                .frame(maxWidth: 280)
                Spacer()
                VStack(spacing: 8) {
                    Capsule().fill(Color.gray.opacity(0.4)).frame(width: 32, height: 4)
                    Text("Motivue AI").font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundColor(.gray)
                }
            }
            .padding(.vertical, 60)
        }
    }

    private enum StepState { case done, processing, pending }
    private func stepRow(title: String, state: StepState, hint: String? = nil) -> some View {
        HStack(alignment: .top, spacing: 10) {
            switch state {
            case .done:
                Circle().fill(Color.green).frame(width: 10, height: 10).shadow(color: Color.green.opacity(0.6), radius: 6)
            case .processing:
                Circle().stroke(Color.green, lineWidth: 2).frame(width: 12, height: 12).overlay(Circle().trim(from: 0, to: 0.6).stroke(Color.green, lineWidth: 2).rotationEffect(.degrees(90)).animation(.linear(duration: 1).repeatForever(autoreverses: false), value: 1))
            case .pending:
                Circle().stroke(Color.gray, lineWidth: 2).frame(width: 12, height: 12)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: state == .processing ? .bold : .medium))
                    .foregroundColor(state == .pending ? .gray : .white)
                if let hint = hint, state == .processing {
                    Text(hint)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.green)
                        .opacity(0.9)
                }
            }
        }
    }
}

// Physio age detail screen
private struct PhysioAgeDetailView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.07, green: 0.07, blue: 0.08)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                StatusBarView(timeText: "9:41")
                    .padding(.top, 6)
                    .padding(.horizontal, 24)

                HStack {
                    Button(action: {}) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("Analysis")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 40)
                }
                .padding(.horizontal, 20)

                VStack(spacing: 12) {
                    Text("Physiological Age")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    Text("Based on 30-day HRV & RHR trends.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.top, 8)

                PhysioAgeScale(realAge: 28, physioAge: 24)
                    .padding(.horizontal, 24)

                VStack(spacing: 8) {
                    Text("You are performing 4 years younger than your actual age.")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(14)
                }

                Divider().background(Color.white.opacity(0.1)).padding(.horizontal, 24)

                VStack(alignment: .leading, spacing: 14) {
                    Text("Contributing Factors")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.gray)
                        .tracking(1.2)
                    physioFactor(title: "High HRV", detail: "58ms (Avg) • Top 10%", delta: "- 2.5 yrs", color: .green, icon: "heart")
                    physioFactor(title: "Low RHR", detail: "52bpm (Avg) • Athletic", delta: "- 1.2 yrs", color: .green, icon: "bolt.fill")
                    physioFactor(title: "Sleep Duration", detail: "7h 15m (Avg) • Normal", delta: "- 0.3 yrs", color: .gray, icon: "moon.fill")
                }
                .padding(.horizontal, 20)

                Spacer()

                Text("Insight: Improving average sleep to 8h+ may lower physio age by another 0.5 years.")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.blue.opacity(0.8))
                    .padding()
                    .background(Color.blue.opacity(0.12))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)

                Spacer(minLength: 24)
            }
        }
    }

    private func physioFactor(title: String, detail: String, delta: String, color: Color, icon: String) -> some View {
        HStack {
            HStack(spacing: 10) {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 38, height: 38)
                    .overlay(Image(systemName: icon).foregroundColor(color))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    Text(detail)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Text(delta)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(color.opacity(color == .gray ? 0.6 : 1))
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(color.opacity(0.12))
                .cornerRadius(10)
        }
    }
}

private struct PhysioAgeScale: View {
    let realAge: Int
    let physioAge: Int
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.black.opacity(0.3))
                .frame(height: 10)
                .cornerRadius(5)
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.6), Color.black]), startPoint: .leading, endPoint: .trailing))
                .frame(width: 200, height: 10)
                .cornerRadius(5)
                .offset(x: -20)
            VStack {
                marker(ageText: "Real \(realAge)", color: .gray, offsetX: 80)
                marker(ageText: "\(physioAge)", color: .green, offsetX: -20, highlight: true)
            }
        }
        .frame(height: 90)
    }

    private func marker(ageText: String, color: Color, offsetX: CGFloat, highlight: Bool = false) -> some View {
        VStack(spacing: 6) {
            if highlight {
                Text(ageText)
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(color)
                    .cornerRadius(12)
                    .shadow(color: color.opacity(0.4), radius: 8)
            } else {
                Text(ageText)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(color)
            }
            Circle()
                .fill(color)
                .frame(width: highlight ? 16 : 10, height: highlight ? 16 : 10)
                .overlay(Circle().stroke(Color.black, lineWidth: 3))
        }
        .offset(x: offsetX)
    }
}

// MARK: - Report Hero + Highlights + Daily Breakdown

private struct ReportHeroScoreCard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 6)
                    .frame(width: 130, height: 130)
                Circle()
                    .trim(from: 0, to: 0.85)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 130, height: 130)
                    .rotationEffect(.degrees(-45))
                    .shadow(color: Color.green.opacity(0.3), radius: 10)
                VStack(spacing: 4) {
                    Text("80")
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(.white)
                    Text("Avg Score")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.gray)
                        .tracking(1)
                }
            }
            Text("Well-adapted")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            Text("Peak adaptation achieved. You handled the heavy mid-week load perfectly.")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ReportMetricsHighlights: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Highlights")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.gray.opacity(0.9))
                .tracking(1)
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                highlightCard(title: "Recovery Effect", value: "+14", unit: "ms HRV", note: "Rebound after rest day (Oct 18).", color: .green)
                highlightCard(title: "Sleep Debt", value: "6.6", unit: "hrs", note: "Lowest on heavy leg day (Oct 15).", color: .red)
            }
        }
    }

    private func highlightCard(title: String, value: String, unit: String, note: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(color)
                Text(unit)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.gray)
            }
            Text(note)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .topLeading)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

private struct ReportDailyBreakdown: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Daily Breakdown")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
                .tracking(1)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    dayCard(day: "Mon 14", tag: "Tennis", score: "79", scoreColor: .yellow, load: "420 AU", bg: Color(red: 0.11, green: 0.11, blue: 0.12), border: Color.white.opacity(0.05))
                    dayCard(day: "Tue 15", tag: "Leg Day", score: "72", scoreColor: .red, load: "500 AU", bg: Color(red: 0.17, green: 0.08, blue: 0.08), border: Color.red.opacity(0.3))
                    dayCard(day: "Fri 18", tag: "Rest", score: "85", scoreColor: .green, load: "120 AU", bg: Color(red: 0.11, green: 0.11, blue: 0.12), border: Color.green.opacity(0.3))
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(.horizontal, 16)
    }

    private func dayCard(day: String, tag: String, score: String, scoreColor: Color, load: String, bg: Color, border: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(day)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(scoreColor == .red ? Color.red.opacity(0.8) : .gray)
                Text(tag)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(scoreColor.opacity(0.25))
                    .cornerRadius(8)
            }
            HStack {
                Spacer()
                ZStack {
                    Circle()
                        .stroke(scoreColor.opacity(0.5), lineWidth: 2)
                        .frame(width: 46, height: 46)
                    Text(score)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(scoreColor)
                }
                Spacer()
            }
            Text(load)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(scoreColor == .red ? Color.red.opacity(0.9) : .gray)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(12)
        .frame(width: 120, height: 150)
        .background(bg)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(border, lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

private enum Tab {
    case home, training, journal, sleep, me
}

// MARK: - Home Tab (Readiness Dashboard)

private struct HomeTabView: View {
    var readiness: ReadinessResponse
    var consumption: TrainingConsumptionResponse
    var onShowCalendar: () -> Void = {}

    private var readinessScore: Int { readiness.finalReadinessScore ?? 0 }
    private var sleepValue: String {
        if let hours = readiness.sleepDurationHours {
            return String(format: "%.1f", hours)
        }
        return "75"
    }
    private var strainValue: String {
        if let score = consumption.consumptionScore {
            return String(format: "%.0f", score)
        }
        return "300"
    }
    private var hrvValue: String {
        if let hrv = readiness.hrvRmssdToday {
            return String(format: "%.0f", hrv)
        }
        return "42"
    }
    private var acwrValue: String {
        if let a = readiness.acwr {
            return String(format: "%.2f", a)
        }
        return "1.05"
    }
    private var insightText: String {
        readiness.insights?.first?.summary ?? "你的恢复状况良好，HRV 回升明显。建议今日保持中等强度。"
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 18) {
                StatusBarView(timeText: "14:20")
                    .padding(.top, 6)
                    .padding(.horizontal, 24)

                HStack {
                    DateHeaderView()
                    Spacer()
                    Button(action: onShowCalendar) {
                        Image(systemName: "calendar")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding(8)
                            .background(Color.white.opacity(0.05))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                    .padding(.horizontal, 24)

                HeroRingView(score: readinessScore)

                MetricsRowView(sleepValue: sleepValue, strainValue: strainValue)

                VStack(spacing: 12) {
                    MetricsGridView(hrvValue: hrvValue, acwrValue: acwrValue)
                    InsightCardView(text: insightText)
                }
                .padding(.horizontal, 24)

                DailyJournalCardView()
                    .padding(.horizontal, 20)
                
                // Inline readiness factors breakdown
                InlineReadinessFactorsView()
                    .padding(.horizontal, 20)

                Spacer(minLength: 32)
            }
            .padding(.bottom, 32)
        }
    }
}

// MARK: - Training Tab

private struct TrainingTabView: View {
    var consumption: TrainingConsumptionResponse
    @State private var showLogSheet = false
    @State private var selectedType: TrainingType = .strength
    @State private var rpeValue: Double = 7
    @State private var durationMinutes: Double = 45

    private var readinessAfterConsumption: Int? {
        if let display = consumption.displayReadiness {
            return Int(display.rounded())
        }
        return nil
    }
    private var consumptionScoreText: String {
        if let c = consumption.consumptionScore {
            return String(format: "%.0f AU", c)
        }
        return "--"
    }

    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    StatusBarView(timeText: "9:41")
                        .padding(.top, 6)
                        .padding(.horizontal, 24)

                    TrainingHeaderView(onAdd: { showLogSheet = true })
                        .padding(.horizontal, 24)

                    WeeklyLoadStripView()
                        .padding(.horizontal, 20)

                    ACWRGaugeCard(acwrValue: 1.1)
                        .padding(.horizontal, 20)

                    if let ready = readinessAfterConsumption {
                        ConsumptionSummaryView(readiness: ready, consumptionText: consumptionScoreText)
                            .padding(.horizontal, 20)
                    }

                    TrainingGridView()
                        .padding(.horizontal, 20)

                    StrengthBenchmarksView()
                        .padding(.horizontal, 16)

                    Spacer(minLength: 40)
                }
            }

            if showLogSheet {
                TrainingLogSheet(
                    selectedType: $selectedType,
                    rpeValue: $rpeValue,
                    durationMinutes: $durationMinutes,
                    onClose: { showLogSheet = false },
                    onSave: { showLogSheet = false }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.25), value: showLogSheet)
            }
        }
    }
}

private enum TrainingType: String, CaseIterable {
    case strength = "Strength"
    case cardio = "Cardio"
    case sport = "Sport"
}

private struct TrainingHeaderView: View {
    var onAdd: () -> Void
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Motivue")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color.orange)
                    .kerning(1.2)
                Text("Training")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(-0.5)
            }
            Spacer()
            Button(action: onAdd) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.1))
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 10)
    }
}

private struct WeeklyLoadStripView: View {
    struct DayLoad: Identifiable {
        let id = UUID()
        let label: String
        let height: CGFloat
        let color: Color
        let active: Bool
    }

    let loads: [DayLoad] = [
        .init(label: "M", height: 24, color: Color.gray.opacity(0.6), active: false),
        .init(label: "T", height: 40, color: Color.orange.opacity(0.5), active: false),
        .init(label: "W", height: 56, color: Color.orange, active: true),
        .init(label: "T", height: 32, color: Color.orange.opacity(0.3), active: false),
        .init(label: "F", height: 24, color: Color.gray.opacity(0.6), active: false),
        .init(label: "S", height: 24, color: Color.gray.opacity(0.6), active: false),
        .init(label: "S", height: 24, color: Color.gray.opacity(0.6), active: false)
    ]

    var body: some View {
        HStack(spacing: 16) {
            ForEach(loads) { day in
                VStack(spacing: 8) {
                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(day.color)
                            .frame(width: day.active ? 12 : 10, height: day.height)
                            .shadow(color: day.active ? Color.orange.opacity(0.6) : Color.clear, radius: 8, x: 0, y: 0)
                        if day.active {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 4, height: 4)
                                .offset(y: -6)
                        }
                    }
                    Text(day.label)
                        .font(.system(size: 10, weight: day.active ? .bold : .medium))
                        .foregroundColor(day.active ? .white : .gray)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ACWRGaugeCard: View {
    let acwrValue: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("ACWR")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Text("Acute:Chronic Workload Ratio")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(String(format: "%.1f", acwrValue))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.green)
                    Text("OPTIMAL ZONE")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(Color.green.opacity(0.8))
                        .kerning(1)
                }
            }

            VStack(spacing: 6) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 14)
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.green.opacity(0.2))
                        .frame(width: nil, height: 14)
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.18)
                        .overlay(
                            HStack {
                                Spacer()
                            }
                        )
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray, Color.green]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: min(max(CGFloat(acwrValue / 2.0) * UIScreen.main.bounds.width * 0.72, 10), UIScreen.main.bounds.width * 0.72), height: 14)
                        .mask(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                        )
                }
                HStack {
                    Text("0.0")
                    Spacer()
                    Text("0.8").foregroundColor(.green)
                    Spacer()
                    Text("1.3").foregroundColor(.green)
                    Spacer()
                    Text("2.0+")
                }
                .font(.system(size: 9, weight: .semibold, design: .monospaced))
                .foregroundColor(.gray)
            }

            Text("Your 7-day load (Acute) is balanced with your 28-day load (Chronic). Low injury risk.")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.gray)
                .lineSpacing(3)
        }
        .padding(18)
        .background(Color.black.opacity(0.4))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .cornerRadius(28)
    }
}

private struct TrainingGridView: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
            BodyHeatmapCard()
            RecentSessionsCard()
        }
        .frame(maxHeight: 260)
    }
}

private struct BodyHeatmapCard: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.black.opacity(0.45))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
            VStack(spacing: 10) {
                Text("FOCUS AREA")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray)
                    .padding(.top, 12)
                    .padding(.leading, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ZStack {
                    BodySilhouetteShape()
                        .fill(Color.gray.opacity(0.35))
                        .frame(width: 100, height: 170)
                        .opacity(0.8)
                    Circle()
                        .fill(Color.orange.opacity(0.8))
                        .frame(width: 60, height: 36)
                        .offset(y: -30)
                        .blur(radius: 14)
                        .opacity(0.8)
                    Circle()
                        .fill(Color.orange.opacity(0.4))
                        .frame(width: 70, height: 50)
                        .offset(y: 30)
                        .blur(radius: 12)
                }
                .frame(height: 180)

                HStack(spacing: 8) {
                    ChipView(title: "Chest", value: "")
                        .foregroundColor(.orange)
                        .modifier(ChipColorModifier(bg: Color.orange.opacity(0.2), border: Color.orange.opacity(0.3), text: Color.orange))
                    ChipView(title: "Legs", value: "")
                        .foregroundColor(.gray)
                        .modifier(ChipColorModifier(bg: Color.gray.opacity(0.3), border: Color.gray.opacity(0.2), text: Color.gray))
                }
                .padding(.bottom, 12)
            }
        }
    }
}

private struct BodySilhouetteShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Simplified abstract silhouette path inspired by provided SVG
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addCurve(to: CGPoint(x: rect.midX - rect.width * 0.15, y: rect.height * 0.15),
                      control1: CGPoint(x: rect.midX - rect.width * 0.1, y: rect.minY),
                      control2: CGPoint(x: rect.midX - rect.width * 0.18, y: rect.height * 0.08))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.height * 0.2),
                      control1: CGPoint(x: rect.midX - rect.width * 0.12, y: rect.height * 0.2),
                      control2: CGPoint(x: rect.midX - rect.width * 0.05, y: rect.height * 0.2))
        path.addCurve(to: CGPoint(x: rect.midX + rect.width * 0.15, y: rect.height * 0.15),
                      control1: CGPoint(x: rect.midX + rect.width * 0.05, y: rect.height * 0.2),
                      control2: CGPoint(x: rect.midX + rect.width * 0.12, y: rect.height * 0.2))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.minY),
                      control1: CGPoint(x: rect.midX + rect.width * 0.18, y: rect.height * 0.08),
                      control2: CGPoint(x: rect.midX + rect.width * 0.1, y: rect.minY))

        let shoulderY = rect.height * 0.18
        let torsoBottomY = rect.height * 0.55
        let hipWidth: CGFloat = rect.width * 0.22
        let shoulderWidth: CGFloat = rect.width * 0.35

        path.move(to: CGPoint(x: rect.midX - shoulderWidth, y: shoulderY))
        path.addLine(to: CGPoint(x: rect.midX - shoulderWidth, y: torsoBottomY))
        path.addLine(to: CGPoint(x: rect.midX - hipWidth, y: torsoBottomY + rect.height * 0.1))
        path.addLine(to: CGPoint(x: rect.midX - hipWidth, y: rect.height))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.height * 0.75))
        path.addLine(to: CGPoint(x: rect.midX + hipWidth, y: rect.height))
        path.addLine(to: CGPoint(x: rect.midX + hipWidth, y: torsoBottomY + rect.height * 0.1))
        path.addLine(to: CGPoint(x: rect.midX + shoulderWidth, y: torsoBottomY))
        path.addLine(to: CGPoint(x: rect.midX + shoulderWidth, y: shoulderY))
        path.closeSubpath()
        return path
    }
}

private struct ChipColorModifier: ViewModifier {
    let bg: Color
    let border: Color
    let text: Color
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(bg)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(border, lineWidth: 1)
            )
            .cornerRadius(12)
    }
}

private struct RecentSessionsCard: View {
    var body: some View {
        VStack(spacing: 6) {
            SessionRow(title: "Chest Day", subtitle: "Today", au: "300 AU", duration: "45m", rpe: "RPE 8", highlight: true)
            SessionRow(title: "Tennis", subtitle: "Yesterday", au: "700 AU", duration: "1h 30m", rpe: "RPE 6", highlight: false)
            Text("View History")
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.gray)
                .padding(.top, 6)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(8)
        .background(Color.black.opacity(0.45))
        .cornerRadius(28)
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

private struct SessionRow: View {
    let title: String
    let subtitle: String
    let au: String
    let duration: String
    let rpe: String
    let highlight: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(au)
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .foregroundColor(Color.orange)
            }
            HStack(spacing: 10) {
                Text(duration)
                Text(rpe)
            }
            .font(.system(size: 9, weight: .medium))
            .foregroundColor(.gray)
        }
        .padding(10)
        .background(highlight ? Color.white.opacity(0.06) : Color.clear)
        .cornerRadius(18)
    }
}

private struct StrengthBenchmarksView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Strength Benchmarks")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading, 4)

            VStack(spacing: 12) {
                StrengthCard(
                    title: "Bench Press",
                    value: "100",
                    unit: "kg",
                    change: "+5%",
                    color: Color.purple,
                    bars: [0.4, 0.5, 0.45, 0.8]
                )
                StrengthCard(
                    title: "Squat",
                    value: "140",
                    unit: "kg",
                    change: "+2%",
                    color: Color.blue,
                    bars: [0.6, 0.65, 0.7, 0.75]
                )
            }
        }
    }
}

private struct StrengthCard: View {
    let title: String
    let value: String
    let unit: String
    let change: String
    let color: Color
    let bars: [CGFloat]

    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "dumbbell")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(color)
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                    Text("Est. 1RM")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            HStack(spacing: 10) {
                HStack(alignment: .bottom, spacing: 2) {
                    ForEach(bars, id: \.self) { bar in
                        RoundedRectangle(cornerRadius: 1.5, style: .continuous)
                            .fill(color.opacity(0.5))
                            .frame(width: 6, height: max(bar * 80, 6))
                    }
                }
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text(value)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Text(unit)
                            .font(.system(size: 10, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.green)
                        Text(change)
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding(12)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

// MARK: - Training Log Sheet (overlay)

private struct TrainingLogSheet: View {
    @Binding var selectedType: TrainingType
    @Binding var rpeValue: Double
    @Binding var durationMinutes: Double
    var onClose: () -> Void
    var onSave: () -> Void

    private var estimatedLoad: Int {
        Int(rpeValue * durationMinutes * 0.7)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            BottomSheetContent(
                selectedType: $selectedType,
                rpeValue: $rpeValue,
                durationMinutes: $durationMinutes,
                onClose: onClose,
                onSave: onSave,
                estimatedLoad: estimatedLoad
            )
        }
    }
}

private struct BottomSheetContent: View {
    @Binding var selectedType: TrainingType
    @Binding var rpeValue: Double
    @Binding var durationMinutes: Double
    var onClose: () -> Void
    var onSave: () -> Void
    var estimatedLoad: Int

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.gray)
                .frame(width: 40, height: 6)
                .padding(.top, 12)
                .padding(.bottom, 4)

            HStack {
                Button("Cancel", action: onClose)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
                Text("Log Workout")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Button("Add", action: onSave)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.orange)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Rectangle()
                    .fill(Color.black.opacity(0.1))
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.white.opacity(0.05)),
                        alignment: .bottom
                    )
            )

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    SegmentedTypeSelector(selected: $selectedType)
                        .padding(.top, 8)

                    RPESlider(value: $rpeValue)
                    DurationRuler(value: $durationMinutes)

                    SessionDetailsSection(selectedType: selectedType)

                    NotesSection()
                        .padding(.bottom, 80)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }

            VStack(spacing: 10) {
                HStack {
                    Text("Estimated Load")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("~\(estimatedLoad) AU")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.orange)
                }
                Button(action: onSave) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                        Text("Save Workout")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(16)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
            .background(
                Color(red: 0.17, green: 0.17, blue: 0.18)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.white.opacity(0.08)),
                        alignment: .top
                    )
            )
        }
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .cornerRadius(32, corners: [.topLeft, .topRight])
        .ignoresSafeArea(edges: .bottom)
    }
}

private struct SegmentedTypeSelector: View {
    @Binding var selected: TrainingType

    var body: some View {
        HStack(spacing: 4) {
            ForEach(TrainingType.allCases, id: \.self) { t in
                Text(t.rawValue)
                    .font(.system(size: 13, weight: t == selected ? .bold : .medium))
                    .foregroundColor(t == selected ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(t == selected ? Color.gray.opacity(0.4) : Color.clear)
                    .cornerRadius(10)
                    .onTapGesture { selected = t }
            }
        }
        .padding(6)
        .background(Color(red: 0.17, green: 0.17, blue: 0.18))
        .cornerRadius(14)
    }
}

private struct RPESlider: View {
    @Binding var value: Double
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Intensity (RPE)", systemImage: "bolt.fill")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
                Text("\(Int(value)) /10")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.orange)
            }
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.green, .yellow, .red]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 10)
                    .opacity(0.85)
                GeometryReader { geo in
                    let width = geo.size.width
                    Circle()
                        .fill(Color.white)
                        .frame(width: 28, height: 28)
                        .shadow(radius: 4)
                        .offset(x: CGFloat(value / 10.0) * width - 14)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    let newVal = max(0, min(1, (gesture.location.x) / width))
                                    value = Double(newVal) * 10
                                }
                        )
                }
            }
            .frame(height: 28)
            HStack {
                Text("Easy")
                Spacer()
                Text("Moderate")
                Spacer()
                Text("Max")
            }
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color(red: 0.17, green: 0.17, blue: 0.18))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

private struct DurationRuler: View {
    @Binding var value: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Duration", systemImage: "clock")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
                Text("\(Int(value)) min")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.17, green: 0.17, blue: 0.18))
                    .frame(height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.05), lineWidth: 1)
                    )
                GeometryReader { geo in
                    let maxMinutes: Double = 120
                    let usableWidth = geo.size.width
                    let spacing = usableWidth / 12.0
                    let clampedValue = min(max(0, value), maxMinutes)
                    let position = CGFloat(clampedValue / maxMinutes) * usableWidth
                    ZStack(alignment: .topLeading) {
                        ForEach(0...12, id: \.self) { idx in
                            let x = CGFloat(idx) * spacing
                            VStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 1)
                                    .fill(idx % 3 == 0 ? Color.white.opacity(0.8) : Color.gray.opacity(0.6))
                                    .frame(width: 2, height: idx % 3 == 0 ? 24 : 14)
                                if idx % 3 == 0 {
                                    Text("\(idx * 10)")
                                        .font(.system(size: 9, weight: .semibold))
                                        .foregroundColor(.gray)
                                }
                            }
                            .position(x: x, y: 22)
                        }
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: 2, height: 34)
                            .position(x: position, y: 24)
                            .shadow(color: Color.orange.opacity(0.7), radius: 4)
                    }
                }
                .padding(.horizontal, 12)
                .frame(height: 48)
                .gesture(
                    DragGesture()
                        .onChanged { g in
                            let maxMinutes: Double = 120
                            let clampedX = max(0, min(g.location.x, g.startLocation.x == 0 ? g.location.x : g.location.x))
                            let geoWidth = max(1, geo.size.width)
                            let newVal = max(0, min(maxMinutes, Double(clampedX / geoWidth) * maxMinutes))
                            value = newVal
                        }
                )
            }
        }
        .padding()
        .background(Color(red: 0.17, green: 0.17, blue: 0.18))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

private struct SessionDetailsSection: View {
    var selectedType: TrainingType
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Session Details")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.gray)
                    .tracking(1)
                Spacer()
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.system(size: 10, weight: .bold))
                        Text("Add Exercise")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.15))
                    .foregroundColor(.orange)
                    .cornerRadius(12)
                }
            }
            switch selectedType {
            case .strength:
                ExerciseCard(
                    title: "Bench Press",
                    muscle: "Chest",
                    sets: [
                        ("100", "kg", "8"),
                        ("100", "kg", "7")
                    ],
                    highlightColor: .purple
                )
                ExercisePlaceholderCard(
                    title: "Barbell Squat",
                    muscle: "Legs",
                    color: .blue
                )
            case .cardio:
                CardioSessionCard()
            case .sport:
                SportSessionCard()
            }
        }
    }
}

private struct ExerciseCard: View {
    let title: String
    let muscle: String
    let sets: [(String, String, String)]
    let highlightColor: Color

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(highlightColor)
                        .frame(width: 3, height: 16)
                    Text(title)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                Text(muscle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(10)
            .background(Color.white.opacity(0.05))

            VStack(spacing: 10) {
                ForEach(sets.indices, id: \.self) { idx in
                    let item = sets[idx]
                    HStack(spacing: 10) {
                        Text("\(idx + 1)")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundColor(.gray)
                            .frame(width: 16)
                        HStack {
                            Text("\(item.0)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                            Text(item.1)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.gray)
                            Spacer()
                            Text("x")
                                .foregroundColor(.gray)
                            Text(item.2)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                            Text("reps")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.white.opacity(0.05), lineWidth: 1)
                        )
                        .cornerRadius(10)
                    }
                }

                Button(action: {}) {
                    Text("+ Add Set")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [6]))
                                .foregroundColor(Color.gray.opacity(0.6))
                        )
                }
            }
            .padding(10)
        }
        .background(Color(red: 0.17, green: 0.17, blue: 0.18))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

private struct ExercisePlaceholderCard: View {
    let title: String
    let muscle: String
    let color: Color

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color)
                        .frame(width: 3, height: 16)
                    Text(title)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                Text(muscle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(10)
            .background(Color.white.opacity(0.05))

            Text("Tap to add sets")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, minHeight: 60)
                .background(Color(red: 0.17, green: 0.17, blue: 0.18))
        }
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .opacity(0.75)
    }
}

private struct CardioSessionCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "figure.run")
                                .foregroundColor(.blue)
                                .font(.system(size: 16, weight: .semibold))
                        )
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Outdoor Run")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                        Text("Cardio Session")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Text("Today")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.gray)
            }

            HStack(spacing: 10) {
                StatPill(title: "Distance", value: "6.5 km", color: .blue)
                StatPill(title: "Pace", value: "5'10\"/km", color: .orange)
            }

            HStack(spacing: 10) {
                StatPill(title: "Duration", value: "42 min", color: .green)
                StatPill(title: "HR Avg", value: "148 bpm", color: .red)
            }

            HStack(spacing: 10) {
                StatPill(title: "Calories", value: "520 kcal", color: .pink)
                StatPill(title: "Surface", value: "Road", color: .gray)
            }
        }
        .padding(14)
        .background(Color(red: 0.17, green: 0.17, blue: 0.18))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

private struct SportSessionCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "sportscourt")
                                .foregroundColor(.orange)
                                .font(.system(size: 16, weight: .semibold))
                        )
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tennis Session")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                        Text("Skill + Cardio")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Text("Yesterday")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.gray)
            }

            HStack(spacing: 10) {
                StatPill(title: "Duration", value: "90 min", color: .orange)
                StatPill(title: "RPE", value: "6 /10", color: .pink)
            }

            HStack(spacing: 10) {
                StatPill(title: "Focus", value: "Agility", color: .blue)
                StatPill(title: "Partner", value: "Doubles", color: .gray)
            }

            Text("Notes: windy, serve practice heavy. Next time add mobility cooldown.")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(14)
        .background(Color(red: 0.17, green: 0.17, blue: 0.18))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

private struct StatPill: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(color == .gray ? .white : color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

private struct NotesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.gray)
                .tracking(1)
            Text("Feeling strong today. Right shoulder a bit tight during warmup.")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color(red: 0.17, green: 0.17, blue: 0.18))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                )
                .cornerRadius(16)
                .frame(height: 90, alignment: .topLeading)
        }
    }
}

// MARK: - Journal Tab

private struct JournalTabView: View {
    @State private var alcohol = false
    @State private var lateCaffeine = false
    @State private var lateMeal = true
    @State private var hydrated = true
    @State private var sex = false
    @State private var meditation = false
    @State private var travel = true
    @State private var sick = false

    var body: some View {
        VStack(spacing: 0) {
            StatusBarView(timeText: "20:45")
                .padding(.top, 6)
                .padding(.horizontal, 24)

            JournalHeaderView()
                .padding(.horizontal, 24)
                .padding(.top, 6)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    JournalDateStrip()
                        .padding(.horizontal, 20)
                        .padding(.top, 6)

                    JournalSection(
                        title: "Nutrition & Intake",
                        items: [
                            .init(iconColor: .purple, icon: "display", title: "Alcohol", isOn: $alcohol),
                            .init(iconColor: .orange, icon: "xmark", title: "Late Caffeine", isOn: $lateCaffeine),
                            .init(iconColor: .yellow, icon: "plus", title: "Late Meal", isOn: $lateMeal),
                            .init(iconColor: .blue, icon: "drop", title: "Hydrated", isOn: $hydrated)
                        ]
                    )
                    .padding(.horizontal, 16)

                    JournalSection(
                        title: "Lifestyle",
                        items: [
                            .init(iconColor: .pink, icon: "heart", title: "Sexual Activity", isOn: $sex),
                            .init(iconColor: .teal, icon: "sparkles", title: "Meditation", isOn: $meditation),
                            .init(iconColor: .blue, icon: "globe", title: "Travel", isOn: $travel)
                        ]
                    )
                    .padding(.horizontal, 16)

                    JournalSection(
                        title: "Status",
                        items: [
                            .init(iconColor: .red, icon: "exclamationmark.triangle", title: "Feeling Sick", isOn: $sick)
                        ]
                    )
                    .padding(.horizontal, 16)

                    Button(action: {}) {
                        HStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 28, height: 28)
                                Image(systemName: "plus")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                            }
                            Text("Customize / Add New")
                                .foregroundColor(.gray)
                                .font(.system(size: 14, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [6]))
                                .foregroundColor(Color.white.opacity(0.2))
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
                .padding(.bottom, 32)
            }
        }
    }
}

// MARK: - Journal Subviews

private struct JournalHeaderView: View {
    var body: some View {
        HStack {
            Text("Journal")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            Button(action: {}) {
                Text("Save")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(16)
            }
        }
    }
}

private struct JournalDateStrip: View {
    var body: some View {
        HStack(spacing: 12) {
            dateItem(day: "M", date: "20", active: false)
            dateItem(day: "T", date: "21", active: false)
            dateItem(day: "W", date: "22", active: false)
            dateItem(day: "T", date: "23", active: false)
            dateItem(day: "F", date: "24", active: true)
            dateItem(day: "S", date: "25", active: false)
            dateItem(day: "S", date: "26", active: false)
        }
    }

    private func dateItem(day: String, date: String, active: Bool) -> some View {
        VStack(spacing: 6) {
            Text(day)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(active ? Color.green : Color.gray)
            ZStack {
                if active {
                    Circle()
                        .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Circle()
                                .stroke(Color.green, lineWidth: 1)
                        )
                        .shadow(color: Color.green.opacity(0.2), radius: 8)
                }
                Text(date)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            if active {
                Circle()
                    .fill(Color.green)
                    .frame(width: 6, height: 6)
            }
        }
        .opacity(active ? 1 : 0.5)
    }
}

private struct JournalSection: View {
    struct Item {
        let iconColor: Color
        let icon: String
        let title: String
        let isOn: Binding<Bool>
    }

    let title: String
    let items: [Item]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.gray)
                .tracking(1.4)
                .padding(.leading, 6)

            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    JournalRow(item: item)
                    if index != items.count - 1 {
                        Divider()
                            .background(Color.white.opacity(0.05))
                    }
                }
            }
            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
        }
    }
}

private struct JournalRow: View {
    let item: JournalSection.Item

    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Circle()
                    .fill(item.iconColor.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: item.icon)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(item.iconColor)
                    )
                Text(item.title)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .medium))
            }
            Spacer()
            ToggleSwitch(isOn: item.isOn)
        }
        .padding(16)
        .background(Color.clear)
    }
}

private struct ToggleSwitch: View {
    @Binding var isOn: Bool

    var body: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(isOn ? Color.green : Color(red: 0.22, green: 0.22, blue: 0.24))
                .frame(width: 48, height: 28)
                .shadow(color: isOn ? Color.green.opacity(0.3) : Color.clear, radius: 6)

            Circle()
                .fill(Color.white)
                .frame(width: 24, height: 24)
                .padding(2)
        }
        .animation(.easeInOut(duration: 0.15), value: isOn)
        .onTapGesture {
            isOn.toggle()
        }
    }
}

// MARK: - Shared Components

private struct PlaceholderTabView: View {
    let title: String
    var body: some View {
        VStack {
            Spacer()
            Text("\(title) Page")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white.opacity(0.8))
            Text("Content coming soon")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

// MARK: - Me Tab

private struct MeTabView: View {
    @State private var showReport = false
    @State private var showPhysio = false
    var physioAge: PhysioAgeResponse
    var baseline: BaselineResponse
    var weeklyReport: WeeklyReportResponse

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                StatusBarView(timeText: "9:41")
                    .padding(.top, 6)
                    .padding(.horizontal, 24)

                MeHeaderActions()
                    .padding(.horizontal, 24)

                MeHeroSection(onShowPhysio: { showPhysio = true })
                    .padding(.horizontal, 20)

                MeBaselineGrid(baseline: baseline)
                    .padding(.horizontal, 16)

                MeWeeklyReports(onOpenReport: { showReport = true })
                    .padding(.horizontal, 16)

                MeIntegrations()
                    .padding(.horizontal, 16)

                Spacer(minLength: 30)
            }
        }
        .fullScreenCover(isPresented: $showReport) {
            ReportTabView(report: weeklyReport, onDismiss: { showReport = false })
        }
        .fullScreenCover(isPresented: $showPhysio) {
            PhysioAgeDetailView()
        }
    }
}

private struct MeHeaderActions: View {
    var body: some View {
        HStack {
            Spacer()
            Button(action: {}) {
                Image(systemName: "gearshape")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.05))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 10)
    }
}

private struct MeHeroSection: View {
    var onShowPhysio: () -> Void = {}
    var physioAge: PhysioAgeResponse? = nil
    var realAge: Int = 28
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.6), Color.black]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 2))
                Image(systemName: "person.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white.opacity(0.8))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Alex Chen")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                Text("Motivue Member since 2023")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.gray)

                HStack(spacing: 8) {
                    Text("Real \(realAge)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(10)
                    HStack(spacing: 6) {
                        Text("Physio Age")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.green)
                        Text("\(physioAge?.physiologicalAge ?? 24)")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.green)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                    .cornerRadius(14)
                    .onTapGesture { onShowPhysio() }
                }
            }
            Spacer()
        }
    }
}

private struct MeBaselineGrid: View {
    var baseline: BaselineResponse
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Your Baselines")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.gray)
                    .tracking(1.1)
                Spacer()
                Text("Last updated: Today")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
            }
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                baselineCard(title: "Sleep Duration", value: baseline.sleepBaselineHours.map { String(format: "%.1f h", $0) } ?? "—", tag: "30d Avg", icon: "moon.fill", iconColor: .blue)
                baselineCard(title: "HRV μ", value: baseline.hrvBaselineMu.map { String(format: "%.0f", $0) } ?? "—", tag: "Range", icon: "waveform.path.ecg", iconColor: .purple)
                baselineCard(title: "Resting HR", value: "—", tag: "30d Avg", icon: "heart.fill", iconColor: .red)
                baselineCard(title: "Sleep Efficiency", value: baseline.sleepBaselineEff.map { String(format: "%.0f%%", $0 * 100) } ?? "—", tag: "Target", icon: "checkmark.seal.fill", iconColor: .green)
            }
        }
    }

    private func baselineCard(title: String, value: String, tag: String, icon: String, iconColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(iconColor)
                Spacer()
                Text(tag)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(8)
            }
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .topLeading)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12).opacity(0.9))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .cornerRadius(18)
    }
}

private struct MeWeeklyReports: View {
    var onOpenReport: () -> Void = {}
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Weekly Insights")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.gray)
                    .tracking(1)
                Spacer()
                Button(action: {}) {
                    Text("View All")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.blue)
                }
            }

            VStack(spacing: 0) {
                reportRow(title: "Oct 14 - Oct 20", subtitle: "Phase 5 • Ready to view", active: true)
                Divider().background(Color.white.opacity(0.05))
                reportRow(title: "Oct 07 - Oct 13", subtitle: "Completed", active: false)
                Divider().background(Color.white.opacity(0.05))
                reportRow(title: "Oct 21 - Present", subtitle: "Analysing Data...", active: true, pulsing: true)
            }
            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
            .cornerRadius(20)
        }
    }

    private func reportRow(title: String, subtitle: String, active: Bool, pulsing: Bool = false) -> some View {
        HStack {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(active ? Color.blue.opacity(0.15) : Color.gray.opacity(0.25))
                        .frame(width: 40, height: 40)
                    Image(systemName: "doc.text")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(active ? .blue : .gray)
                        .opacity(pulsing ? 0.8 : 1)
                        .scaleEffect(pulsing ? 1.05 : 1)
                        .animation(pulsing ? .easeInOut(duration: 1).repeatForever(autoreverses: true) : .default, value: pulsing)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(active ? .blue.opacity(0.7) : .gray)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture { onOpenReport() }
    }
}

private struct MeIntegrations: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Integrations")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.gray)
                .tracking(1)
            HStack {
                HStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.white)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        )
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Apple Health")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 6, height: 6)
                            Text("Syncing")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.green)
                        }
                    }
                }
                Spacer()
                Button(action: {}) {
                    Text("Manage")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                        )
                }
            }
            .padding(14)
            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
            .cornerRadius(16)
        }
    }
}

private struct DeviceFrame<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 55, style: .continuous)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.05, green: 0.05, blue: 0.06), Color.black]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 55, style: .continuous)
                        .stroke(Color(red: 0.1, green: 0.1, blue: 0.1), lineWidth: 8)
                )
                .shadow(color: Color.black.opacity(0.8), radius: 24, x: 0, y: 18)
            content
        }
        .clipShape(RoundedRectangle(cornerRadius: 55, style: .continuous))
    }
}

private struct StatusBarView: View {
    var timeText: String
    var body: some View {
        HStack {
            Text(timeText)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            ZStack {
                Capsule()
                    .fill(Color.black)
                    .frame(width: 120, height: 36)
            }
            .frame(maxWidth: .infinity)

            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white)
                    .frame(width: 18, height: 12)

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        .frame(width: 26, height: 12)
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.white)
                        .frame(width: 18, height: 7)
                        .padding(.leading, 2)
                        .padding(.vertical, 2.5)
                }
            }
        }
    }
}

private struct DateHeaderView: View {
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .foregroundColor(Color.gray)
                .font(.system(size: 16, weight: .semibold))

            Spacer()

            VStack(spacing: 2) {
                Text("TODAY")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color.green)
                    .kerning(1.4)
                Text("OCT 24")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(Color.gray)
                .font(.system(size: 16, weight: .semibold))
        }
        .padding(.top, 6)
    }
}

private struct HeroRingView: View {
    var score: Int
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.4), lineWidth: 8)
                .frame(width: 200, height: 200)
            Circle()
                .trim(from: 0.0, to: 0.82)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [Color.green, Color.green.opacity(0.6), Color.green]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-45))
                .frame(width: 200, height: 200)
                .shadow(color: Color.green.opacity(0.5), radius: 12)

            VStack(spacing: 8) {
                Text("\(score)")
                    .font(.system(size: 76, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                Text("READINESS")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color.green)
                    .kerning(2.0)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct MetricCircle: View {
    let title: String
    let value: String
    let subtitle: String?
    let ringColor: Color
    let ringTrim: CGFloat

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.6), lineWidth: 3)
                    .frame(width: 76, height: 76)
                Circle()
                    .trim(from: 0, to: ringTrim)
                    .stroke(
                        ringColor,
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-45))
                    .frame(width: 76, height: 76)
                VStack(spacing: 2) {
                    Text(value)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 8, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }
            }
            Text(title.uppercased())
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.gray)
                .tracking(0.6)
        }
    }
}

private struct MetricsRowView: View {
    let sleepValue: String
    let strainValue: String
    var body: some View {
        HStack(spacing: 36) {
            MetricCircle(title: "Sleep", value: sleepValue, subtitle: nil, ringColor: Color.blue, ringTrim: 0.78)
            MetricCircle(title: "Strain", value: strainValue, subtitle: "AU", ringColor: Color.orange, ringTrim: 0.75)
        }
        .padding(.horizontal, 24)
    }
}

private struct MetricsGridView: View {
    let hrvValue: String
    let acwrValue: String
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
            metricBox(title: "HRV", value: hrvValue, unit: "ms", accent: .white.opacity(0.1), border: .white.opacity(0.08), titleColor: .gray, valueColor: .white, unitColor: .gray)
            metricBox(title: "RHR", value: "58", unit: "bpm", accent: .white.opacity(0.1), border: .white.opacity(0.08), titleColor: .gray, valueColor: .white, unitColor: .gray)
            metricBox(title: "ACWR", value: acwrValue, unit: "Optimal", accent: Color.green.opacity(0.2), border: Color.green.opacity(0.3), titleColor: Color.green, valueColor: Color.green, unitColor: Color.green.opacity(0.7))
        }
    }

    private func metricBox(
        title: String,
        value: String,
        unit: String,
        accent: Color,
        border: Color,
        titleColor: Color,
        valueColor: Color,
        unitColor: Color
    ) -> some View {
        VStack(spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(titleColor)
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(valueColor)
            Text(unit)
                .font(.system(size: 8, weight: .semibold))
                .foregroundColor(unitColor)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(accent)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(border, lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

private struct InsightCardView: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Rectangle()
                .fill(Color.green)
                .frame(width: 3)
                .cornerRadius(2)
            Text(text)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color.gray.opacity(0.9))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .background(Color.white.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}

private struct DailyJournalCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle()
                                    .stroke(Color.green.opacity(0.3), lineWidth: 1)
                            )
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color.green)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Daily Journal")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                        Text("Synced with Engine")
                            .foregroundColor(Color.green)
                            .font(.system(size: 10, weight: .medium))
                    }
                }

                Spacer()

                HStack(spacing: 6) {
                    Text("Edit")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 10, weight: .medium))
                        .tracking(1)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.gray)
                }
            }

            HStack(spacing: 8) {
                ChipView(title: "Hooper", value: "Low Stress")
                ChipView(title: "Habits", value: "No Alcohol")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(red: 0.11, green: 0.11, blue: 0.12).opacity(0.8))
                .shadow(color: Color.black.opacity(0.7), radius: 22, x: 0, y: 14)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

private struct ChipView: View {
    let title: String
    let value: String
    var body: some View {
        HStack(spacing: 6) {
            Text(title)
                .foregroundColor(.gray)
                .font(.system(size: 10, weight: .medium))
            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 11, weight: .bold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.06))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

private struct TabBarView: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack(spacing: 0) {
            tabItem(icon: "house.fill", title: "Home", tab: .home)
            tabItem(icon: "bolt.fill", title: "Training", tab: .training)
            tabItem(icon: "book.closed.fill", title: "Journal", tab: .journal)
            tabItem(icon: "moon.stars.fill", title: "Sleep", tab: .sleep)
            tabItem(icon: "person.crop.circle", title: "Me", tab: .me)
        }
        .frame(height: 88)
        .padding(.horizontal, 12)
        .background(
            Color(red: 0.07, green: 0.07, blue: 0.07).opacity(0.8)
        )
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.white.opacity(0.06)),
            alignment: .top
        )
    }

    private func tabItem(icon: String, title: String, tab: Tab) -> some View {
        let active = (tab == selectedTab)
        return VStack(spacing: 6) {
            if active {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 36, height: 32)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    )
            } else {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .opacity(0.4)
            }
            Text(title)
                .font(.system(size: 9, weight: active ? .bold : .medium))
                .foregroundColor(.white.opacity(active ? 1 : 0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedTab = tab
        }
    }
}

// MARK: - Corner helper

private struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

private extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

#Preview {
    ContentView()
}
private struct ConsumptionSummaryView: View {
    let readiness: Int
    let consumptionText: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Readiness after consumption")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text("\(readiness)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(12)
            }
            Text("Today's training load: \(consumptionText)")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(14)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}
