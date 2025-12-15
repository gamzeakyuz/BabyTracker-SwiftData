//
//  ToothLog.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 12.12.2025.
//

import Foundation
import SwiftData

@Model
class ToothLog {
    
    var id: Int
    var name: String
    var eruptionDate: Date?
    var isErupted: Bool
    
    init(id: Int, name: String, isErupted: Bool = false, eruptionDate: Date? = nil) {
        self.id = id
        self.name = name
        self.isErupted = isErupted
        self.eruptionDate = eruptionDate
    }
    
}
