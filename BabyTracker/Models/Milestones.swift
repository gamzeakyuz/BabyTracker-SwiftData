//
//  Milestones.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//

import Foundation
import SwiftData

@Model
class Milestones {
    
    var id: UUID
    var title: String
    var date: Date?
    var note: String?
    @Attribute(.externalStorage) var photo: Data?
    var isCompleted: Bool
    
    
    init(title: String, date: Date? = nil, note: String? = nil, photo: Data? = nil, isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.date = date
        self.note = note
        self.photo = photo
        self.isCompleted = isCompleted
    }
    
}

struct MilestoneDefaults {
    static let list = [
        "First Smile",
        "First Tooth",
        "Sitting Alone",
        "Crawling",
        "First Step",
        "First Word",
        "First Solid Food",
        "First Haircut",
        "A Full Turn",
        "First Goodbye"
    ]
}
