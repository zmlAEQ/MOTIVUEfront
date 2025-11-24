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

    init() {
        // Default to mock; later can switch to real API calls
        self.readiness = MockData.readiness
        self.consumption = MockData.consumption
        self.weeklyReport = MockData.weeklyReport
        self.baseline = MockData.baseline
        self.physioAge = MockData.physioAge
    }
}
