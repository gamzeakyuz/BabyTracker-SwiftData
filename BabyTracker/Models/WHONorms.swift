//
//  WHONorms.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//

import Foundation

struct ReferencePoint: Identifiable {
    let id = UUID()
    let month: Int
    let value: Double
}

struct WHONorms {
    
    static let boyWeightP50: [ReferencePoint] = [
        .init(month: 0, value: 3.3), .init(month: 1, value: 4.5), .init(month: 2, value: 5.6),
        .init(month: 3, value: 6.4), .init(month: 4, value: 7.0), .init(month: 5, value: 7.5),
        .init(month: 6, value: 7.9), .init(month: 7, value: 8.3), .init(month: 8, value: 8.6),
        .init(month: 9, value: 8.9), .init(month: 10, value: 9.2), .init(month: 11, value: 9.4),
        .init(month: 12, value: 9.6)
    ]
    
    static let boyHeightP50: [ReferencePoint] = [
        .init(month: 0, value: 49.9), .init(month: 1, value: 54.7), .init(month: 2, value: 58.4),
        .init(month: 3, value: 61.4), .init(month: 4, value: 63.9), .init(month: 5, value: 65.9),
        .init(month: 6, value: 67.6), .init(month: 7, value: 69.2), .init(month: 8, value: 70.6),
        .init(month: 9, value: 72.0), .init(month: 10, value: 73.3), .init(month: 11, value: 74.5),
        .init(month: 12, value: 75.7)
    ]
    
    static let girlWeightP50: [ReferencePoint] = [
        .init(month: 0, value: 3.2), .init(month: 1, value: 4.2), .init(month: 2, value: 5.1),
        .init(month: 3, value: 5.8), .init(month: 4, value: 6.4), .init(month: 5, value: 6.9),
        .init(month: 6, value: 7.3), .init(month: 7, value: 7.6), .init(month: 8, value: 7.9),
        .init(month: 9, value: 8.2), .init(month: 10, value: 8.5), .init(month: 11, value: 8.7),
        .init(month: 12, value: 8.9)
    ]
    
    static let girlHeightP50: [ReferencePoint] = [
        .init(month: 0, value: 49.1), .init(month: 1, value: 53.7), .init(month: 2, value: 57.1),
        .init(month: 3, value: 59.8), .init(month: 4, value: 62.1), .init(month: 5, value: 64.0),
        .init(month: 6, value: 65.7), .init(month: 7, value: 67.3), .init(month: 8, value: 68.7),
        .init(month: 9, value: 70.1), .init(month: 10, value: 71.5), .init(month: 11, value: 72.8),
        .init(month: 12, value: 74.0)
    ]
    
}
