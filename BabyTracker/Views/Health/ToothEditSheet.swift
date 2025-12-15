//
//  ToothEditSheet.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 12.12.2025.
//
import SwiftUI
import SwiftData

struct ToothEditSheet: View {
    @Bindable var tooth: ToothLog
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.themeBackground.ignoresSafeArea()
                
                VStack(spacing: 25) {
                    VStack(spacing: 10) {
                        Image(systemName: "mouth.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(tooth.isErupted ? Color.themeAccent : Color.gray)
                        
                        Text(tooth.name)
                            .font(.title2.bold())
                            .foregroundStyle(Color.themeText)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 0) {
                        Toggle("Has the tooth erupted?", isOn: $tooth.isErupted)
                            .tint(Color.themeAccent)
                            .padding()
                            .onChange(of: tooth.isErupted) { _, newValue in
                                if newValue && tooth.eruptionDate == nil {
                                    tooth.eruptionDate = Date()
                                } else if !newValue {
                                    tooth.eruptionDate = nil
                                }
                            }
                        
                        if tooth.isErupted {
                            Divider()
                            DatePicker(
                                "Eruption Date",
                                selection: Binding(
                                    get: { tooth.eruptionDate ?? Date() },
                                    set: { tooth.eruptionDate = $0 }
                                ),
                                displayedComponents: .date
                            )
                            .padding()
                        }
                    }
                    .background(Color.themeCardBackground)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button("Okay") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.themeAccent)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Tooth Information")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.themeBackground, for: .navigationBar)
        }
    }
}

#Preview {
    let sample = ToothLog(id: 1, name: "Upper Tooth 1", isErupted: true, eruptionDate: Date())
    ToothEditSheet(tooth: sample)
        .modelContainer(for: ToothLog.self, inMemory: true)
}
