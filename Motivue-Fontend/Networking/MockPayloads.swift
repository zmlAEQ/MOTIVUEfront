//
//  MockPayloads.swift
//  Motivue
//
//  Sample request payloads for POST endpoints; replace with real user data when available.
//

import Foundation

enum MockPayloads {
    static let weeklyReportPayload: Data = {
        let dict: [String: Any] = [
            "payload": [
                "user_id": "athlete_001",
                "date": "2025-09-18",
                "history": []
            ],
            "use_llm": false,
            "persist": false
        ]
        return (try? JSONSerialization.data(withJSONObject: dict)) ?? Data()
    }()

    static let consumptionPayload: Data = {
        let dict: [String: Any] = [
            "user_id": "athlete_001",
            "date": "2025-09-18",
            "sessions": [
                ["label": "Legs", "rpe": 8, "duration_minutes": 70],
                ["label": "Tennis", "au": 200]
            ]
        ]
        return (try? JSONSerialization.data(withJSONObject: dict)) ?? Data()
    }()

    static let physioAgePayload: Data = {
        let dict: [String: Any] = [
            "user_id": "athlete_001",
            "user_gender": "male",
            "sdnn_series": Array(repeating: 50, count: 30),
            "rhr_series": Array(repeating: 55, count: 30),
            "total_sleep_minutes": 420,
            "in_bed_minutes": 470,
            "deep_sleep_minutes": 90,
            "rem_sleep_minutes": 95
        ]
        return (try? JSONSerialization.data(withJSONObject: dict)) ?? Data()
    }()
}

