//
//  BabyLog.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 10.12.2025.
//

import Foundation
import SwiftData

enum Gender: String, Codable,CaseIterable {
    case boy = "Boy"
    case girl = "Girl"
    case unknown = "Unknown"
}

@Model
class BabyLog {
    
    var name: String
    var birthDate: Date
    var gender: Gender
    @Attribute(.externalStorage) var photo: Data?
    var birthWeight: Double?
    var birthHeight: Double?
    
    @Relationship(deleteRule: .cascade) var logs: [DailyLog] = []
    
    init(name: String, birthDate: Date, gender: Gender, photo: Data? = nil, birthWeight: Double? = nil, birthHeight: Double? = nil) {
        self.name = name
        self.birthDate = birthDate
        self.gender = gender
        self.photo = photo
        self.birthWeight = birthWeight
        self.birthHeight = birthHeight
    }
    
}
