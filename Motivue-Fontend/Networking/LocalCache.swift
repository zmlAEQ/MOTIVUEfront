//
//  LocalCache.swift
//  Motivue
//
//  Simple JSON cache to persist latest responses locally (fallback when backend is inactive).
//

import Foundation

final class LocalCache {
    static let shared = LocalCache()
    private let fm = FileManager.default

    private var baseURL: URL {
        fm.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("motivue-cache", isDirectory: true)
    }

    private init() {
        try? fm.createDirectory(at: baseURL, withIntermediateDirectories: true)
    }

    private func url(for key: String) -> URL {
        baseURL.appendingPathComponent("\(key).json")
    }

    func save<T: Encodable>(_ value: T, key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: url(for: key), options: .atomic)
        } catch {
            print("Cache save failed for \(key): \(error)")
        }
    }

    func load<T: Decodable>(_ type: T.Type, key: String) -> T? {
        let path = url(for: key)
        guard fm.fileExists(atPath: path.path) else { return nil }
        do {
            let data = try Data(contentsOf: path)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Cache load failed for \(key): \(error)")
            return nil
        }
    }
}

