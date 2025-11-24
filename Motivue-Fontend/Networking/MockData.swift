//
//  MockData.swift
//  Motivue
//
//  Quick mock payloads to keep UI running before hooking real APIs.
//

import Foundation

enum MockData {
    static let readiness = ReadinessResponse(
        userId: "athlete_001",
        date: "2025-09-15",
        finalReadinessScore: 85,
        currentReadinessScore: 80,
        finalDiagnosis: "Well-adapted",
        finalPosteriorProbs: ["Peak": 0.1, "Well-adapted": 0.55, "FOR": 0.25, "Acute Fatigue": 0.08, "NFOR": 0.02, "OTS": 0.0],
        nextPreviousStateProbs: ["Peak": 0.12, "Well-adapted": 0.5, "FOR": 0.25, "Acute Fatigue": 0.1, "NFOR": 0.03, "OTS": 0.0],
        acwr: 1.05,
        hrvRmssdToday: 63,
        sleepDurationHours: 7.6,
        metrics: Metrics(hrvZScore: 0.2, sleepEfficiency: 0.9, restorativeRatio: 0.42, acwr7d: 1.0, acwr28d: 0.92, sleepBaselineHours: 7.6, hrvBaselineMu: 63),
        insights: [
            Insight(title: "HRV 回升明显", summary: "恢复状态良好，建议保持中等强度训练。", actions: ["保持睡眠一致性", "控制高负荷天数"])
        ],
        objective: nil,
        journal: nil,
        hooper: nil,
        updateHistory: nil
    )

    static let consumption = TrainingConsumptionResponse(
        consumptionScore: 18.5,
        displayReadiness: 66,
        breakdown: [
            ConsumptionBreakdown(sessionId: "s1", label: "Legs", au: 500, consumption: 15, notes: "RPE 8 x 70m"),
            ConsumptionBreakdown(sessionId: "s2", label: "Tennis", au: 200, consumption: 3.5, notes: nil)
        ],
        baseReadinessScore: 85
    )

    static let weeklyReport = WeeklyReportResponse(
        phase3State: Phase3State(metrics: Metrics(hrvZScore: 0.1, sleepEfficiency: 0.88, restorativeRatio: 0.4, acwr7d: 1.05, acwr28d: 0.95, sleepBaselineHours: 7.6, hrvBaselineMu: 63), insights: [], nextWeekPlan: NextWeekPlan(summary: "Deload & maintenance", goals: ["控制高负荷日 2 天内"], thresholds: nil, daily: nil)),
        package: WeeklyReportPackage(charts: [], analyst: nil, communicator: nil, critique: nil),
        finalReport: WeeklyFinalReport(
            markdownReport: "## Weekly Overview\n- 训练 7 天，负荷峰值 500 AU\n- 平均准备度 80.3，周末回升\n[[chart:readiness_trend]]",
            htmlReport: nil,
            chartIds: ["readiness_trend", "training_load"],
            callToAction: ["控制高强度日 2 天以内", "保持睡眠 >7.6h"],
            persisted: false
        )
    )

    static let baseline = BaselineResponse(
        userId: "athlete_001",
        sleepBaselineHours: 7.6,
        sleepBaselineEff: 0.87,
        restBaselineRatio: 0.37,
        hrvBaselineMu: 63,
        hrvBaselineSd: 5.8
    )

    static let physioAge = PhysioAgeResponse(
        physiologicalAge: 24,
        physiologicalAgeWeighted: 24.5,
        bestAgeZscores: ["sdnn": -0.6, "rhr": -0.4, "css": -0.3],
        cssDetails: CSSDetails(durationScore: 78, efficiencyScore: 82, restorativeScore: 75),
        status: "ok",
        windowDaysUsed: 30
    )
}
