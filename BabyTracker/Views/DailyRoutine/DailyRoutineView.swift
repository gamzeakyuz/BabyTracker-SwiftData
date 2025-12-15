//
//  ContentView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 10.12.2025.
//

import SwiftUI
import SwiftData

struct LogSection: Identifiable {
    var id: Date { date }
    let date: Date
    let logs: [DailyLog]
}

struct DailyRoutineView: View {
    
    @Query(sort: \DailyLog.date, order: .reverse) private var logs: [DailyLog]
    @Query private var profiles: [BabyLog]
    @Environment(\.modelContext) private var modelContext
    
    @State private var showAddSheet = false
    
    private var groupedLogs: [LogSection] {
        let grouped = Dictionary(grouping: logs) { log in
            Calendar.current.startOfDay(for: log.date)
        }
        return grouped.keys.sorted(by: >).map { date in
            LogSection(
                date: date,
                logs: grouped[date]!.sorted { $0.date > $1.date }
            )
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.themeBackground
                    .ignoresSafeArea()
                
                if profiles.isEmpty {
                    ContentUnavailableView {
                        Label("Profile Not Found", systemImage: "person.crop.circle.badge.questionmark")
                    } description: {
                        Text("Please set up your baby's profile before adding daily records.")
                    }
                    .foregroundStyle(Color.themeText)
                    
                } else if logs.isEmpty {
                    ContentUnavailableView {
                        Label("No Records Yet", systemImage: "note.text.badge.plus")
                            .foregroundStyle(Color.themeAccent)
                    } description: {
                        Text("Press the + button to add your baby's routines.")
                            .foregroundStyle(Color.themeText.opacity(0.6))
                    }
                    
                } else {
                    ScrollView {
                        LazyVStack(spacing: 25) {
                            ForEach(groupedLogs) { section in
                                VStack(alignment: .leading, spacing: 15) {
                                    
                                    HStack {
                                        Text(formatHeaderDate(section.date))
                                            .font(.title3.bold())
                                            .foregroundStyle(Color.themeText)
                                        
                                        Spacer()
                                        
                                        Text("\(section.logs.count) Entry")
                                            .font(.caption)
                                            .padding(6)
                                            .background(Color.themeAccent.opacity(0.1))
                                            .clipShape(Capsule())
                                            .foregroundStyle(Color.themeAccent)
                                    }
                                    .padding(.horizontal)
                                    
                                    ForEach(section.logs) { log in
                                        LogRowView(log: log)
                                            .padding(.horizontal)
                                            .contextMenu {
                                                Button(role: .destructive) {
                                                    modelContext.delete(log)
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            }
                                    }
                                }
                            }
                        }
                        .padding(.top)
                        .padding(.bottom, 80)
                    }
                }
            }
            .navigationTitle(profiles.isEmpty ? "Daily Routine" : "\(profiles.first?.name ?? "Baby")' Diary")
            .toolbarBackground(Color.themeBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.themeAccent)
                            .shadow(color: Color.themeAccent.opacity(0.3), radius: 5)
                    }
                    .disabled(profiles.isEmpty)
                    .accessibilityIdentifier(K.Identifiers.addLogButton)
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddLogSheet()
                    .presentationDetents([.medium, .large])
            }
        }
    }
}


extension DailyRoutineView {
    
    private func formatHeaderDate(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM yyyy"
            return formatter.string(from: date)
        }
    }
    
    private func deleteItems(at offsets: IndexSet, in sectionLogs: [DailyLog]) {
        withAnimation {
            for index in offsets {
                let logToDelete = sectionLogs[index]
                modelContext.delete(logToDelete)
            }
        }
    }
}

struct LogRowView: View {
    
    let log: DailyLog
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 15) {
            
            Text(log.date.formatted(date: .omitted, time: .shortened))
                .font(.caption.bold())
                .foregroundStyle(Color.themeText.opacity(0.6))
                .frame(width: 45, alignment: .trailing)
                .padding(.top, 12)
            
            ZStack {
                Circle()
                    .fill(Color.themeCardBackground)
                    .frame(width: 50, height: 50)
                    .shadow(color: Color.black.opacity(0.05), radius: 3)
                
                Image(systemName: log.type.iconName)
                    .font(.title2)
                    .foregroundStyle(Color.themeAccent)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(log.type.rawValue)
                        .font(.headline)
                        .foregroundStyle(Color.themeText)
                    
                    if let sub = log.subType, !sub.isEmpty {
                        Text("• \(sub)")
                            .font(.subheadline)
                            .foregroundStyle(Color.themeAccent)
                    }
                }
                .padding(.top, 4)
                
                HStack {
                    if let val = log.value, val > 0 {
                        Text("\(String(format: "%.0f", val)) \(log.type == .feeding ? "ml" : "min")")
                            .modifier(LogRowViewHStackModifier())
                            .background(Color.themeText.opacity(0.05))
                            
                    }
                    
                    if let reaction = log.reaction {
                        Text(reaction.rawValue)
                            .modifier(LogRowViewHStackModifier())
                            .background(reaction.color.opacity(0.1))
                    }
                }
                
                if let note = log.note, !note.isEmpty {
                    Text(note)
                        .font(.caption)
                        .foregroundStyle(Color.themeText.opacity(0.8))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.themeBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.themeText.opacity(0.05), lineWidth: 1)
                        )
                }
            }
            .padding(.bottom, 5)
            
            Spacer()
        }
        .padding()
        .background(Color.themeCardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.themeText.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}

    
#Preview {
    DailyRoutineView()
}

