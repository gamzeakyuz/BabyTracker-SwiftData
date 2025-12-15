//
//  Color+Extension.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 12.12.2025.
//

import UIKit
import SwiftUI

extension Color {
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    static let rawElectricBlue = Color(hex: "1F45FC")
    static let rawIceBlue      = Color(hex: "85D6F9")
    static let rawNightBlue    = Color(hex: "020514")
    static let rawPaleMagenta  = Color(hex: "EEDAE5")
    static let rawCream        = Color(hex: "FFF5E1")
    
    static let themeBackground = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor(rawNightBlue) : UIColor(rawCream)
    })
    
    static let themeText = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor(rawCream) : UIColor(rawNightBlue)
    })
    
    static let themeAccent = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor(rawIceBlue) : UIColor(rawElectricBlue)
    })
    
    static let themeCardBackground = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor(rawNightBlue.opacity(0.8)) : UIColor.white
    })
    
}
