//
//  ApiService.swift
//  Motivue
//
//  Lightweight networking layer (mock/real switch) for Motivue-Backend
//

import Foundation

enum ApiError: Error {
    case invalidURL
    case network(Error)
    case decoding(Error)
    case http(Int)
}

final class ApiService {
    static let shared = ApiService()

    /// Base URL for backend services; adjust per environment.
    var baseURL: URL = URL(string: "http://127.0.0.1:8000")!
    /// Optional bearer token for auth-api protected routes.
    var bearerToken: String?
    /// Mock mode for offline UI; set to false to hit real APIs.
    var useMock: Bool = true

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Public endpoints (skeletons)

    func fetchReadiness() async throws -> ReadinessResponse {
        if useMock { return MockData.readiness }
        return try await request(path: "/readiness/from-healthkit", method: "GET")
    }

    func postConsumption(payload: Data? = nil) async throws -> TrainingConsumptionResponse {
        if useMock { return MockData.consumption }
        return try await request(path: "/readiness/consumption", method: "POST", body: payload)
    }

    func runWeeklyReport(payload: Data? = nil) async throws -> WeeklyReportResponse {
        if useMock { return MockData.weeklyReport }
        return try await request(path: "/weekly-report/run", method: "POST", body: payload)
    }

    func fetchBaseline(userId: String) async throws -> BaselineResponse {
        if useMock { return MockData.baseline }
        return try await request(path: "/baseline/\(userId)", method: "GET")
    }

    func fetchPhysioAge(payload: Data? = nil) async throws -> PhysioAgeResponse {
        if useMock { return MockData.physioAge }
        return try await request(path: "/physio-age", method: "POST", body: payload)
    }

    // MARK: - Core request helper

    private func request<T: Decodable>(path: String, method: String, body: Data? = nil) async throws -> T {
        guard let url = URL(string: path, relativeTo: baseURL) else { throw ApiError.invalidURL }
        var req = URLRequest(url: url)
        req.httpMethod = method
        if let token = bearerToken {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body = body {
            req.httpBody = body
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, resp): (Data, URLResponse)
        do {
            (data, resp) = try await session.data(for: req)
        } catch {
            throw ApiError.network(error)
        }
        guard let http = resp as? HTTPURLResponse else { throw ApiError.network(NSError(domain: "no_http", code: -1)) }
        guard 200..<300 ~= http.statusCode else { throw ApiError.http(http.statusCode) }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ApiError.decoding(error)
        }
    }
}
