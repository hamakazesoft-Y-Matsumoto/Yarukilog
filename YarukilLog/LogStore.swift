//
//  LogStore.swift
//  YarukilLog
//
//  Created by 松本康秀 on 2026/02/02.
//

import Foundation
import Combine
import SwiftUI

final class LogStore: ObservableObject {
    @Published private(set) var dates: [String] = []

    private let storageKey = "yarukilog.dates"
    private let defaults: UserDefaults
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let loaded = defaults.stringArray(forKey: storageKey) ?? []
        let normalized = Self.normalizedDates(loaded)
        self.dates = normalized
        if normalized != loaded {
            save()
        }
    }

    @discardableResult
    func addToday(now: Date = Date()) -> Bool {
        let key = Self.makeDateKey(for: now)
        if dates.contains(key) {
            return false
        }
        dates.append(key)
        dates = Self.normalizedDates(dates)
        save()
        return true
    }

    func delete(at offsets: IndexSet) {
        dates.remove(atOffsets: offsets)
        save()
    }

    private static let dayBoundaryHour = 3

    static func makeDateKey(for date: Date,
                            calendar: Calendar = .current,
                            timeZone: TimeZone = .current) -> String {
        var calendar = calendar
        calendar.timeZone = timeZone

        let formatter = Self.dateFormatter
        formatter.calendar = calendar
        formatter.timeZone = timeZone
        guard let shifted = calendar.date(byAdding: .hour, value: -dayBoundaryHour, to: date) else {
            return formatter.string(from: date)
        }
        return formatter.string(from: shifted)
    }

    static func normalizedDates(_ dates: [String]) -> [String] {
        Array(Set(dates)).sorted(by: >)
    }

    func currentMonthCount(now: Date = Date(),
                           calendar: Calendar = .current,
                           timeZone: TimeZone = .current) -> Int {
        var calendar = calendar
        calendar.timeZone = timeZone
        let formatter = Self.dateFormatter
        formatter.calendar = calendar
        formatter.timeZone = timeZone
        let components = calendar.dateComponents([.year, .month], from: now)
        guard let year = components.year, let month = components.month else {
            return 0
        }

        return dates.compactMap { dateKey in
            formatter.date(from: dateKey)
        }
        .filter { date in
            let parts = calendar.dateComponents([.year, .month], from: date)
            return parts.year == year && parts.month == month
        }
        .count
    }

    func currentStreak(now: Date = Date(),
                       calendar: Calendar = .current,
                       timeZone: TimeZone = .current) -> Int {
        var calendar = calendar
        calendar.timeZone = timeZone

        let keys = Set(dates)
        var streak = 0
        var current = calendar.startOfDay(for: now)
        while keys.contains(Self.makeDateKey(for: current, calendar: calendar, timeZone: timeZone)) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: current) else {
                break
            }
            current = previous
        }
        return streak
    }

    func csvText() -> String {
        let header = "date,status"
        let rows = dates.map { "\($0),出なかった" }
        return ([header] + rows).joined(separator: "\n")
    }

    private func save() {
        defaults.set(dates, forKey: storageKey)
    }
}
