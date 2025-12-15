//
//  DentalToothView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 12.12.2025.
//
import SwiftUI
import SwiftData

struct DentalToothView: View {
    let tooth: ToothLog
    let isUpper: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(tooth.isErupted ? Color.white : Color.white.opacity(0.3))
                    .frame(height: 45)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                    .shadow(color: tooth.isErupted ? .white.opacity(0.5) : .clear, radius: 5)
                
                if tooth.isErupted {
                    Image(systemName: "checkmark")
                        .font(.caption2.bold())
                        .foregroundStyle(Color.themeAccent)
                } else {
                    Text("\(tooth.id > 10 ? tooth.id - 10 : tooth.id)")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            if tooth.isErupted, let date = tooth.eruptionDate {
                Text(date.formatted(.dateTime.month().year()))
                    .font(.system(size: 7))
                    .foregroundStyle(.white.opacity(0.9))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }
    }
}


#Preview {
    let sample = ToothLog(id: 3, name: "Upper Tooth 3", isErupted: false, eruptionDate: nil)
    DentalToothView(tooth: sample, isUpper: true)
        .modelContainer(for: ToothLog.self, inMemory: true)
}

