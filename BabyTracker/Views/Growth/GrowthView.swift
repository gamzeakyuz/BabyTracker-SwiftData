//
//  GrowthView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//

import SwiftUI
import SwiftData
import Charts

enum GrowthType: String, CaseIterable {
    case weight =  "Weight (kg)"
    case height =  "Height (cm)"
}

struct GrowthView: View {
    
    @Query(sort: \GrowthRecord.date, order: .forward) private var records: [GrowthRecord]
    @Query private var profiles: [BabyLog]
    @Environment(\.modelContext) var modelContext
    
    @State private var selectedType: GrowthType = .weight
    @State private var showAddSheet = false
    
    var babyBirthDate: Date {
        profiles.first?.birthDate ?? Date()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.themeBackground.ignoresSafeArea()
                
                if profiles.isEmpty {
                    ContentUnavailableView {
                        Label("Profile Missing", systemImage: "person.crop.circle.badge.exclamationmark")
                    } description: {
                        Text("Please create a profile to generate charts.")
                    }
                    .foregroundStyle(Color.themeText)
                } else {
                    
                    List {
                        Section {
                            VStack(spacing: 20) {
                                Picker("Chart Type", selection: $selectedType) {
                                    ForEach(GrowthType.allCases, id: \.self) { type in
                                        Text(type.rawValue).tag(type)
                                    }
                                }
                                .pickerStyle(.segmented)
                                
                                ChartView()
                                    .padding(.bottom, 10)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                        }
                        
                        Section(header: Text("Measurement History").foregroundStyle(Color.themeText.opacity(0.7))) {
                            if records.isEmpty {
                                Text("No data entered yet.")
                                    .foregroundStyle(.secondary)
                                    .listRowBackground(Color.clear)
                            } else {
                                ForEach(records.sorted(by: { $0.date > $1.date })) { record in
                                    GrowthHistoryRow(
                                        record: record,
                                        ageString: getAgeString(for: record),
                                        value: getValue(for: record),
                                        unit: selectedType == .weight ? "kg" : "cm",
                                        icon: selectedType == .weight ? "scalemass.fill" : "ruler.fill"
                                    )
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                                    .listRowBackground(Color.clear)
                                }
                                .onDelete(perform: deleteRecord)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Growth Chart")
            .toolbarBackground(Color.themeBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.themeAccent)
                    }
                    .disabled(profiles.isEmpty)
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddGrowthSheet()
                    .presentationDetents([.medium])
            }
        }
    }
    
    @ViewBuilder
    func ChartView() -> some View {
        VStack(alignment: .leading) {
            Text("\(selectedType.rawValue) Growth")
                .font(.headline)
                .foregroundStyle(Color.themeText)
                .padding(.leading, 5)
            
            Chart {
                ForEach(getReferenceData()) { point in
                    LineMark(
                        x: .value("Month", point.month),
                        y: .value("WHO Average", point.value)
                    )
                    .foregroundStyle(Color.gray.opacity(0.4))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 3, dash: [5, 5]))
                }
                .symbol(by: .value("Data", "WHO Standard"))
                
                ForEach(records) { record in
                    LineMark(
                        x: .value("Month", calculateMonthsOld(from: record.date)),
                        y: .value("My Baby", getValue(for: record))
                    )
                    .foregroundStyle(Color.themeAccent)
                    .symbol(Circle())
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                }
                .symbol(by: .value("Data", "My Baby"))
            }
            .chartForegroundStyleScale([
                "WHO Standard": Color.gray.opacity(0.5),
                "My Baby": Color.themeAccent
            ])
            .chartXAxisLabel("Age (Month)", position: .bottom)
            .chartYAxisLabel(selectedType == .weight ? "kg" : "cm", position: .leading)
            .chartXScale(domain: 0...12)
            .frame(height: 300)
        }
        .padding()
        .background(Color.themeCardBackground)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}

struct GrowthHistoryRow: View {
    let record: GrowthRecord
    let ageString: String
    let value: Double
    let unit: String
    let icon: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.body.weight(.medium))
                    .foregroundStyle(Color.themeText)
                
                Text(ageString)
                    .font(.caption)
                    .foregroundStyle(Color.themeAccent)
                    .padding(4)
                    .background(Color.themeAccent.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.themeAccent.opacity(0.1))
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundStyle(Color.themeAccent)
                }
                
                Text(String(format: "%.2f %@", value, unit))
                    .font(.headline)
                    .foregroundStyle(Color.themeText)
            }
        }
        .padding()
        .background(Color.themeCardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.themeText.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 2)
    }
}

extension GrowthView {
    
    private func getReferenceData() -> [ReferencePoint] {
        let isGirl = profiles.first?.gender == .girl
        switch selectedType {
        case .weight:
            return isGirl ? WHONorms.girlWeightP50 : WHONorms.boyWeightP50
        case .height:
            return isGirl ? WHONorms.girlHeightP50 : WHONorms.boyHeightP50
        }
    }
    
    private func getValue(for record: GrowthRecord) -> Double {
        switch selectedType {
        case .weight: return record.weight
        case .height: return record.height
        }
    }
   
    private func calculateMonthsOld(from date: Date) -> Double {
        let components = Calendar.current.dateComponents([.day], from: babyBirthDate, to: date)
        if let days = components.day {
            return Double(days) / 30.0
        }
        return 0.0
    }
    
    private func deleteRecord(offsets: IndexSet) {
        let sortedRecords = records.sorted(by: { $0.date > $1.date })
        withAnimation {
            for index in offsets {
                modelContext.delete(sortedRecords[index])
            }
        }
    }
    private func getAgeString(for record: GrowthRecord) -> String {
        let months = calculateMonthsOld(from: record.date)
        return String(format: "%.1f Monthly", months)
    }
}

#Preview {
    GrowthView()
}
