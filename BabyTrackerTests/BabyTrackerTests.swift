//
//  BabyTrackerTests.swift
//  BabyTrackerTests
//
//  Created by gamzeakyuz on 14.12.2025.
//

import Testing
import SwiftData
import Foundation
@testable import BabyTracker

@MainActor
struct BabyTrackerTests {

    func createInMemoryContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: DailyLog.self, configurations: config)
    }
    
    @Test("Daily Log Adding Test")
    func addDailyLog() throws {
        let container = try createInMemoryContainer()
        let context = container.mainContext
        
        let newLog = DailyLog(
            date: Date(),
            type: .feeding,
            subType: "Breast Milk",
            note: "Test note",
            value: 150.0,
            reaction: nil
        )
        context.insert(newLog)
        
        let descriptor = FetchDescriptor<DailyLog>()
        let logs = try context.fetch(descriptor)
        
        #expect(logs.count == 1)
        #expect(logs.first?.value == 150.0)
        #expect(logs.first?.type == .feeding)
    }
    @Test("Solid Food Reaction Saving Test")
    func addSolidFoodReaction() throws {
        let container = try createInMemoryContainer()
        let context = container.mainContext
        
        let solidLog = DailyLog(
            date: Date(),
            type: .solidFood,
            subType: "Carrot",
            note: "",
            value: 0,
            reaction: .loved
        )
        
        context.insert(solidLog)
        
        let fetchedLog = try context.fetch(FetchDescriptor<DailyLog>()).first
        
        #expect(fetchedLog?.type == .solidFood)
        #expect(fetchedLog?.reaction == .loved)
    }
    
    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    

}
