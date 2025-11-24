//
//  Models.swift
//  Motivue
//
//  Lightweight Codable models for Motivue-Backend APIs (skeleton for wiring)
//

import Foundation

// MARK: - Readiness

struct ReadinessResponse: Codable {
    let userId: String?
    let date: String?
    let finalReadinessScore: Int?
    let currentReadinessScore: Int?
    let finalDiagnosis: String?
    let finalPosteriorProbs: [String: Double]?
    let nextPreviousStateProbs: [String: Double]?
    let acwr: Double?
    let hrvRmssdToday: Double?
    let sleepDurationHours: Double?
    let metrics: Metrics?
    let insights: [Insight]?
    let objective: JSONValue?
    let journal: JSONValue?
    let hooper: JSONValue?
    let updateHistory: JSONValue?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case date
        case finalReadinessScore = "final_readiness_score"
        case currentReadinessScore = "current_readiness_score"
        case finalDiagnosis = "final_diagnosis"
        case finalPosteriorProbs = "final_posterior_probs"
        case nextPreviousStateProbs = "next_previous_state_probs"
        case acwr
        case hrvRmssdToday = "hrv_rmssd_today"
        case sleepDurationHours = "sleep_duration_hours"
        case metrics
        case insights
        case objective
        case journal
        case hooper
        case updateHistory = "update_history"
    }
}

struct Metrics: Codable {
    let hrvZScore: Double?
    let sleepEfficiency: Double?
    let restorativeRatio: Double?
    let acwr7d: Double?
    let acwr28d: Double?
    let sleepBaselineHours: Double?
    let hrvBaselineMu: Double?

    enum CodingKeys: String, CodingKey {
        case hrvZScore = "hrv_z_score"
        case sleepEfficiency = "sleep_efficiency"
        case restorativeRatio = "restorative_ratio"
        case acwr7d = "acwr_7d"
        case acwr28d = "acwr_28d"
        case sleepBaselineHours = "sleep_baseline_hours"
        case hrvBaselineMu = "hrv_baseline_mu"
    }
}

struct Insight: Codable, Identifiable {
    var id: String { title ?? UUID().uuidString }
    let title: String?
    let summary: String?
    let actions: [String]?
}

// MARK: - Training Consumption

struct TrainingConsumptionResponse: Codable {
    let consumptionScore: Double?
    let displayReadiness: Double?
    let breakdown: [ConsumptionBreakdown]?
    let baseReadinessScore: Double?

    enum CodingKeys: String, CodingKey {
        case consumptionScore = "consumption_score"
        case displayReadiness = "display_readiness"
        case breakdown
        case baseReadinessScore = "base_readiness_score"
    }
}

struct ConsumptionBreakdown: Codable, Identifiable {
    var id: String { (sessionId ?? UUID().uuidString) }
    let sessionId: String?
    let label: String?
    let au: Double?
    let consumption: Double?
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case label
        case au
        case consumption
        case notes
    }
}

// MARK: - Weekly Report

struct WeeklyReportResponse: Codable {
    let phase3State: Phase3State?
    let package: WeeklyReportPackage?
    let finalReport: WeeklyFinalReport?

    enum CodingKeys: String, CodingKey {
        case phase3State = "phase3_state"
        case package
        case finalReport = "final_report"
    }
}

struct Phase3State: Codable {
    let metrics: Metrics?
    let insights: [Insight]?
    let nextWeekPlan: NextWeekPlan?
}

struct WeeklyReportPackage: Codable {
    let charts: [ChartSpec]?
    let analyst: JSONValue?
    let communicator: JSONValue?
    let critique: JSONValue?
}

struct WeeklyFinalReport: Codable {
    let markdownReport: String?
    let htmlReport: String?
    let chartIds: [String]?
    let callToAction: [String]?
    let persisted: Bool?

    enum CodingKeys: String, CodingKey {
        case markdownReport = "markdown_report"
        case htmlReport = "html_report"
        case chartIds = "chart_ids"
        case callToAction = "call_to_action"
        case persisted
    }
}

struct ChartSpec: Codable, Identifiable {
    var id: String { chartId ?? UUID().uuidString }
    let chartId: String?
    let title: String?
    let chartType: String?
    let data: JSONValue?

    enum CodingKeys: String, CodingKey {
        case chartId = "chart_id"
        case title
        case chartType = "chart_type"
        case data
    }
}

struct NextWeekPlan: Codable {
    let summary: String?
    let goals: [String]?
    let thresholds: JSONValue?
    let daily: JSONValue?
}

// MARK: - Baseline

struct BaselineResponse: Codable {
    let userId: String?
    let sleepBaselineHours: Double?
    let sleepBaselineEff: Double?
    let restBaselineRatio: Double?
    let hrvBaselineMu: Double?
    let hrvBaselineSd: Double?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case sleepBaselineHours = "sleep_baseline_hours"
        case sleepBaselineEff = "sleep_baseline_eff"
        case restBaselineRatio = "rest_baseline_ratio"
        case hrvBaselineMu = "hrv_baseline_mu"
        case hrvBaselineSd = "hrv_baseline_sd"
    }
}

// MARK: - Physio Age

struct PhysioAgeResponse: Codable {
    let physiologicalAge: Int?
    let physiologicalAgeWeighted: Double?
    let bestAgeZscores: [String: Double]?
    let cssDetails: CSSDetails?
    let status: String?
    let windowDaysUsed: Int?

    enum CodingKeys: String, CodingKey {
        case physiologicalAge = "physiological_age"
        case physiologicalAgeWeighted = "physiological_age_weighted"
        case bestAgeZscores = "best_age_zscores"
        case cssDetails = "css_details"
        case status
        case windowDaysUsed = "window_days_used"
    }
}

struct CSSDetails: Codable {
    let durationScore: Double?
    let efficiencyScore: Double?
    let restorativeScore: Double?

    enum CodingKeys: String, CodingKey {
        case durationScore = "duration_score"
        case efficiencyScore = "efficiency_score"
        case restorativeScore = "restorative_score"
    }
}

// MARK: - Generic JSON value

enum JSONValue: Codable {
    case string(String)
    case number(Double)
    case bool(Bool)
    case array([JSONValue])
    case object([String: JSONValue])
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let b = try? container.decode(Bool.self) {
            self = .bool(b)
        } else if let d = try? container.decode(Double.self) {
            self = .number(d)
        } else if let s = try? container.decode(String.self) {
            self = .string(s)
        } else if let arr = try? container.decode([JSONValue].self) {
            self = .array(arr)
        } else if let obj = try? container.decode([String: JSONValue].self) {
            self = .object(obj)
        } else {
            self = .null
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let s):
            try container.encode(s)
        case .number(let n):
            try container.encode(n)
        case .bool(let b):
            try container.encode(b)
        case .array(let a):
            try container.encode(a)
        case .object(let o):
            try container.encode(o)
        case .null:
            try container.encodeNil()
        }
    }
}
