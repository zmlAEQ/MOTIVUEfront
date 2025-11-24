//
//  AppData.swift
//  Motivue
//
//  Simple observable store for mock/real data binding
//

import Foundation
import Combine

final class AppData: ObservableObject {
    @Published var readiness: ReadinessResponse
    @Published var consumption: TrainingConsumptionResponse
    @Published var weeklyReport: WeeklyReportResponse
    @Published var baseline: BaselineResponse
    @Published var physioAge: PhysioAgeResponse
    @Published var useRealAPI: Bool = false

    init() {
        // Try cache first; fallback to mock
        let cache = LocalCache.shared
        self.readiness = cache.load(ReadinessResponse.self, key: "readiness") ?? MockData.readiness
        self.consumption = cache.load(TrainingConsumptionResponse.self, key: "consumption") ?? MockData.consumption
        self.weeklyReport = cache.load(WeeklyReportResponse.self, key: "weeklyReport") ?? MockData.weeklyReport
        self.baseline = cache.load(BaselineResponse.self, key: "baseline") ?? MockData.baseline
        self.physioAge = cache.load(PhysioAgeResponse.self, key: "physioAge") ?? MockData.physioAge
    }

    // MARK: - Refresh helpers (mock/real)

    @MainActor
    func refreshAll(useReal: Bool? = nil) async {
        if let flag = useReal {
            useRealAPI = flag
        }
        ApiService.shared.useMock = !useRealAPI
        async let r = refreshReadiness()
        async let c = refreshConsumption()
        async let w = refreshWeeklyReport()
        async let b = refreshBaseline()
        async let p = refreshPhysioAge()
        _ = await (r, c, w, b, p)
    }

    @MainActor
    func refreshReadiness() async {
        do {
            readiness = try await ApiService.shared.fetchReadiness()
            LocalCache.shared.save(readiness, key: "readiness")
        } catch {
            print("Readiness fetch failed: \(error)")
        }
    }

    @MainActor
    func refreshConsumption() async {
        do {
            consumption = try await ApiService.shared.postConsumption(payload: MockPayloads.consumptionPayload)
            LocalCache.shared.save(consumption, key: "consumption")
        } catch {
            print("Consumption fetch failed: \(error)")
        }
    }

    @MainActor
    func refreshWeeklyReport() async {
        do {
            weeklyReport = try await ApiService.shared.runWeeklyReport(payload: MockPayloads.weeklyReportPayload)
            LocalCache.shared.save(weeklyReport, key: "weeklyReport")
        } catch {
            print("Weekly report fetch failed: \(error)")
        }
    }

    @MainActor
    func refreshBaseline() async {
        do {
            baseline = try await ApiService.shared.fetchBaseline(userId: "athlete_001")
            LocalCache.shared.save(baseline, key: "baseline")
        } catch {
            print("Baseline fetch failed: \(error)")
        }
    }

    @MainActor
    func refreshPhysioAge() async {
        do {
            physioAge = try await ApiService.shared.fetchPhysioAge(payload: MockPayloads.physioAgePayload)
            LocalCache.shared.save(physioAge, key: "physioAge")
        } catch {
            print("Physio age fetch failed: \(error)")
        }
    }
}
