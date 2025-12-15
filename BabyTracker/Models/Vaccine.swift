//
//  Vaccine.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//

import Foundation
import SwiftData

@Model
class Vaccine {
    
    var id: UUID
    var name: String
    var dueMonth: Int
    var isCompleted: Bool
    var completionDate: Date?
    var note: String?
    
    init(name: String, dueMonth: Int, isCompleted: Bool = false) {
        self.id = UUID()
        self.name = name
        self.dueMonth = dueMonth
        self.isCompleted = isCompleted
    }
    
}
struct VaccineStandard {
    static let list: [(month: Int, name: String)] = [
        (0, "Hepatitis B - 1st Dose"),
        (1, "Hepatitis B - 2nd Dose"),
        (2, "BCG (Tuberculosis)"),
        (2, "5-in-1 Combination (DTaP-IPV-Hib) - 1st Dose"),
        (2, "PCV (Pneumococcal) - 1st Dose"),
        (4, "5-in-1 Combination - 2nd Dose"),
        (4, "PCV (Pneumococcal) - 2nd Dose"),
        (6, "Hepatitis B - 3rd Dose"),
        (6, "5-in-1 Combination - 3rd Dose"),
        (6, "OPV (Polio) - 1st Dose"),
        (12, "MMR (Measles-Mumps-Rubella)"),
        (12, "PCV (Pneumococcal) - Booster"),
        (12, "Chickenpox"),
        (18, "5-in-1 Combination - Reinforcement"),
        (18, "OPA (Polio) - 2nd Dose"),
        (18, "Hepatitis A - 1st Dose"),
        (24, "Hepatitis A - 2nd Dose")
    ]
}
