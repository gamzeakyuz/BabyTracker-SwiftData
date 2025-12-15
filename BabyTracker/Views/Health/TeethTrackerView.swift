//
//  TeethTrackerView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 12.12.2025.
//

import SwiftUI
import SwiftData

struct TeethTrackerView: View {
    @Query(sort: \ToothLog.id) private var teeth: [ToothLog]
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedTooth: ToothLog?
    
    var body: some View {
        ZStack {
            Color.themeBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    
                    ProgressHeader(teeth: teeth)
                        .padding(.top, 10)
                    
                    VStack(spacing: 15) {
                        
                        VStack {
                            Text("Upper Teeth")
                                .font(.caption.bold())
                                .tracking(2)
                                .foregroundStyle(.white.opacity(0.7))
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 12) {
                                ForEach(teeth.filter { $0.id <= 10 }) { tooth in
                                    DentalToothView(tooth: tooth, isUpper: true)
                                        .onTapGesture { selectedTooth = tooth }
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            LinearGradient(colors: [Color.themeAccent, Color.blue], startPoint: .top, endPoint: .bottom)
                        )
                        .clipShape(
                            .rect(
                                topLeadingRadius: 20,
                                bottomLeadingRadius: 50,
                                bottomTrailingRadius: 50,
                                topTrailingRadius: 20
                            )
                        )
                        .shadow(color: Color.themeAccent.opacity(0.4), radius: 10, x: 0, y: 5)
                        
                        VStack {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 12) {
                                ForEach(teeth.filter { $0.id > 10 }) { tooth in
                                    DentalToothView(tooth: tooth, isUpper: false)
                                        .onTapGesture { selectedTooth = tooth }
                                }
                            }
                            
                            Text("Lower Teeth")
                                .font(.caption.bold())
                                .tracking(2)
                                .foregroundStyle(.white.opacity(0.7))
                                .padding(.top, 10)
                        }
                        .padding(20)
                        .background(
                            LinearGradient(colors: [Color.blue, Color.themeAccent], startPoint: .top, endPoint: .bottom)
                        )
                        .clipShape(
                            .rect(
                                topLeadingRadius: 50,
                                bottomLeadingRadius: 20,
                                bottomTrailingRadius: 20,
                                topTrailingRadius: 50
                            )
                        )
                        .shadow(color: Color.themeAccent.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    
                    if let lastErupted = teeth.filter({ $0.isErupted }).sorted(by: { $0.eruptionDate ?? Date() > $1.eruptionDate ?? Date() }).first {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            Text("Last erupted tooth: \(lastErupted.name)")
                                .foregroundStyle(Color.themeText)
                                .fontWeight(.medium)
                            if let date = lastErupted.eruptionDate {
                                Text("(\(date.formatted(date: .numeric, time: .omitted)))")
                                    .foregroundStyle(.gray)
                                    .font(.caption)
                            }
                        }
                        .padding()
                        .background(Color.themeCardBackground)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                    }
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .navigationTitle("Teething Schedule")
        .toolbarBackground(Color.themeBackground, for: .navigationBar)
        .sheet(item: $selectedTooth) { tooth in
            ToothEditSheet(tooth: tooth)
                .presentationDetents([.fraction(0.50)])
                .presentationCornerRadius(30)
        }
        .onAppear {
            initializeTeeth()
        }
    }
    
    
}

extension TeethTrackerView {
    private func initializeTeeth() {
        if teeth.isEmpty {
            for i in 1...20 {
                let name = i <= 10 ? "Upper Tooth \(i)" : "Lower Tooth \(i-10)"
                let newTooth = ToothLog(id: i, name: name)
                modelContext.insert(newTooth)
            }
            try? modelContext.save()
        }
    }
}

#Preview {
    TeethTrackerView()
}
