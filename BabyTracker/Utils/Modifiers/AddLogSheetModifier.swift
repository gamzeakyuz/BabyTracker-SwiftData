//
//  AddLogSheetModifier.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 15.12.2025.
//

import SwiftUI

struct AddLogTextField: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.trailing)
            .frame(width: 80)
            .foregroundStyle(Color.themeText)
    }
}

