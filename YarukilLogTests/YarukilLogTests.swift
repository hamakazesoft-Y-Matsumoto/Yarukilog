//
//  YarukilLogTests.swift
//  YarukilLogTests
//
//  Created by 松本康秀 on 2026/02/02.
//

import Testing
@testable import YarukilLog

struct YarukilLogTests {

    @Test func makeDateKeyUsesLocalDate() async throws {
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "Asia/Tokyo")!
        calendar.timeZone = timeZone

        let date = Date(timeIntervalSince1970: 1_699_000_000) // 2023-10-05T20:26:40+09:00
        let key = LogStore.makeDateKey(for: date, calendar: calendar, timeZone: timeZone)
        #expect(key == "2023-10-05")
    }

    @Test func normalizedDatesRemovesDuplicatesAndSortsDesc() async throws {
        let input = ["2026-02-02", "2026-02-01", "2026-02-02", "2025-12-31"]
        let normalized = LogStore.normalizedDates(input)
        #expect(normalized == ["2026-02-02", "2026-02-01", "2025-12-31"])
    }

}
