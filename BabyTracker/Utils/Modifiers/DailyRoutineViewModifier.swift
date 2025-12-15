//
//  DailyRoutineViewModifier.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 15.12.2025.
//

import SwiftUI

struct LogRowViewHStackModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption.bold())
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .cornerRadius(6)
            .foregroundStyle(Color.themeText)
    }
}
