//
//  GrowthRecord.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//

import Foundation
import SwiftData

@Model
class GrowthRecord {
    
    var id: UUID
    var date: Date
    var weight: Double
    var height: Double
    var headCircumference: Double?
    
    init(date: Date, weight: Double, height: Double, headCircumference: Double? = nil) {
        self.id = UUID()
        self.date = date
        self.weight = weight
        self.height = height
        self.headCircumference = headCircumference
    }
    
}
