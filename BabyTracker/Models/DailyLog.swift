//
//  DailyLog.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 10.12.2025.
//

import Foundation
import SwiftData
import UIKit
import SwiftUI

enum LogType: String, Codable, CaseIterable {
    
    case feeding = "Feeding"
    case solidFood = "Solid Food"
    case sleep = "Sleep"
    case diaper = "Diaper Change"
    case medicine = "Medicine/Vitamin"
    case activity = "Play/Bath"
    
    var iconName: String {
        switch self {
        case .feeding: return "waterbottle.fill"
        case .sleep: return "moon.zzz.fill"
        case .diaper: return "toilet.fill"
        case .medicine: return "pills.fill"
        case .activity: return "figure.play"
        case .solidFood: return "carrot.fill"
        }
    }
}

enum FoodReaction: String, Codable, CaseIterable {
    
    case loved = "Loverd"
    case neutral = "Neutral"
    case disliked = "Disliked"
    case allergy = "Allergy"
    
    var color: Color {
        switch self {
        case .loved: return .green
        case .neutral: return .gray
        case .disliked: return .orange
        case .allergy: return .red
        }
    }
}

@Model
class DailyLog {
    var id: UUID
    var date: Date
    var type: LogType
    var note: String?
    var subType: String?
    var value: Double?
    var unit: String?
    var reaction: FoodReaction?
    
    init(
        date: Date = Date(),
        type: LogType,
        subType: String? = nil,
        note: String? = nil,
        value: Double? = nil,
        unit: String? = nil,
        reaction: FoodReaction? = nil
    ) {
        self.id = UUID()
        self.date = date
        self.type = type
        self.subType = subType
        self.note = note
        self.value = value
        self.unit = unit
        self.reaction = reaction
    }
}
