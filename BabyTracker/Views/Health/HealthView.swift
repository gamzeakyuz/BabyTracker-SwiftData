//
//  HealthView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//

import SwiftUI
import SwiftData

struct HealthView: View {
    
    @Query(sort: \Vaccine.dueMonth) private var vaccines: [Vaccine]
    @Environment(\.modelContext) private var modelContext
    
    var groupedVaccines: [Int: [Vaccine]] {
        Dictionary(grouping: vaccines, by: { $0.dueMonth })
    }
    
    var sortedMonth: [Int] {
        groupedVaccines.keys.sorted()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.themeBackground
                    .ignoresSafeArea()
                
                if vaccines.isEmpty {
                    ContentUnavailableView {
                        Label("Setting up Vaccination Schedule...", systemImage: "syringe.fill")
                    } description: {
                        Text("A standard vaccination schedule will be loaded the first time you use it.")
                    }
                    .foregroundStyle(Color.themeAccent)
                    
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            
                            NavigationLink(destination: TeethTrackerView()){
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color.themeAccent.opacity(0.15))
                                            .frame(width: 50, height: 50)
                                        Image(systemName: "mouth.fill")
                                            .font(.title2)
                                            .foregroundStyle(Color.themeAccent)
                                    }
                                    VStack(alignment: .leading) {
                                        Text("Tooth Timeline")
                                            .font(.headline)
                                            .foregroundStyle(Color.themeText)
                                        Text("Track the erupted teeth")
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(Color.gray)
                                }
                                .padding()
                                .background(Color.themeCardBackground)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.05), radius: 5)
                            }
                            .padding(.bottom, 10)
                            
                            ForEach(sortedMonth, id: \.self) { month in
                                VaccineSectionCard(
                                    monthTitle: monthTitle(for: month),
                                    vaccines: groupedVaccines[month] ?? []
                                )
                            }
                        }
                        .padding()
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Health & Vaccinations")
            .toolbarBackground(Color.themeBackground, for: .navigationBar)
            .onAppear {
                checkAndCreateVaccines()
            }
        }
    }
}

extension HealthView {
    
    private func monthTitle(for month: Int) -> String {
        if month == 0 { return "At Birth" }
        return "\(month). Month"
    }
    private func checkAndCreateVaccines() {
        if vaccines.isEmpty {
            for item in VaccineStandard.list {
                let newVaccine = Vaccine(name: item.name, dueMonth: item.month)
                modelContext.insert(newVaccine)
            }
        }
    }
}

struct VaccineSectionCard: View {
    let monthTitle: String
    let vaccines: [Vaccine]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "calendar.badge.exclamationmark")
                    .foregroundStyle(Color.themeAccent)
                Text(monthTitle)
                    .font(.headline.bold())
                    .foregroundStyle(Color.themeText)
                Spacer()
                
                let completedCount = vaccines.filter { $0.isCompleted }.count
                Text("\(completedCount)/\(vaccines.count)")
                    .font(.caption.bold())
                    .padding(6)
                    .background(completedCount == vaccines.count ? Color.green.opacity(0.15) : Color.themeAccent.opacity(0.1))
                    .foregroundStyle(completedCount == vaccines.count ? .green : Color.themeAccent)
                    .clipShape(Capsule())
            }
            .padding()
            .background(Color.themeCardBackground.opacity(0.8))
            
            Divider().background(Color.themeText.opacity(0.1))
            
            VStack(spacing: 0) {
                ForEach(vaccines) { vaccine in
                    VaccineRow(vaccine: vaccine)
                    
                    if vaccine.id != vaccines.last?.id {
                        Divider()
                            .padding(.leading, 50)
                            .background(Color.themeText.opacity(0.05))
                    }
                }
            }
            .padding(.vertical, 5)
        }
        .background(Color.themeCardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.themeText.opacity(0.05), lineWidth: 1)
        )
    }
}

struct VaccineRow: View {
    @Bindable var vaccine: Vaccine
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    vaccine.isCompleted.toggle()
                    if vaccine.isCompleted {
                        vaccine.completionDate = Date()
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                    } else {
                        vaccine.completionDate = nil
                    }
                }
            }) {
                ZStack {
                    if vaccine.isCompleted {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 28, height: 28)
                        Image(systemName: "checkmark")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                    } else {
                        Circle()
                            .stroke(Color.themeText.opacity(0.3), lineWidth: 2)
                            .frame(width: 28, height: 28)
                    }
                }
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(vaccine.name)
                    .font(.body)
                    .strikethrough(vaccine.isCompleted) // Tamamlandıysa üzerini çiz
                    .foregroundStyle(vaccine.isCompleted ? Color.themeText.opacity(0.5) : Color.themeText)
                
                if let date = vaccine.completionDate {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption2)
                        Text("Completed: \(date.formatted(date: .numeric, time: .omitted))")
                            .font(.caption2)
                    }
                    .foregroundStyle(.green)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring()) {
                vaccine.isCompleted.toggle()
                if vaccine.isCompleted {
                    vaccine.completionDate = Date()
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                } else {
                    vaccine.completionDate = nil
                }
            }
        }
    }
}

#Preview {
    HealthView()
}
