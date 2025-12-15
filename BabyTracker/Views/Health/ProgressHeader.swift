//
//  ProgressHeader.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 12.12.2025.
//
import SwiftUI
import SwiftData

struct ProgressHeader: View {
    let teeth: [ToothLog]
    
    var eruptedCount: Int { teeth.filter { $0.isErupted }.count }
    var percentage: Double { Double(eruptedCount) / 20.0 }
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.themeCardBackground, lineWidth: 10)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: percentage)
                    .stroke(
                        LinearGradient(colors: [Color.themeAccent, .cyan], startPoint: .top, endPoint: .bottom),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: percentage)
                
                VStack(spacing: 0) {
                    Text("\(Int(percentage * 100))%")
                        .font(.caption.bold())
                        .foregroundStyle(Color.themeText)
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Tooth Development")
                    .font(.headline)
                    .foregroundStyle(Color.themeText)
                
                Text("\(eruptedCount) teeth have erupted.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                if eruptedCount < 20 {
                    Text("\(20 - eruptedCount) more expected.")
                        .font(.caption)
                        .foregroundStyle(Color.themeAccent)
                } else {
                    Text("Congratulations! All teeth are complete.")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    let sampleTeeth: [ToothLog] = [
        ToothLog(id: 1, name: "Upper Tooth 1", isErupted: true, eruptionDate: Date()),
        ToothLog(id: 2, name: "Upper Tooth 2", isErupted: false, eruptionDate: nil),
        ToothLog(id: 11, name: "Lower Tooth 1", isErupted: true, eruptionDate: Date().addingTimeInterval(-86400))
    ]
    ProgressHeader(teeth: sampleTeeth)
        .modelContainer(for: ToothLog.self, inMemory: true)
}

