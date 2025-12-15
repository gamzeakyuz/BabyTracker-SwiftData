//
//  NotificationSettingsView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//
import SwiftUI

struct NotificationSettingsView: View {
    
    @AppStorage("vitaminD_Enabled") private var vitaminDEnabled = false
    @AppStorage("vitaminD_Time") private var vitaminDTime: Double = Date().timeIntervalSince1970
    
    @AppStorage("sleep_Enabled") private var sleepEnabled = false
    @AppStorage("sleep_Time") private var sleepTime: Double = Date().timeIntervalSince1970

    @AppStorage("iron_Enabled") private var ironEnabled = false
    @AppStorage("iron_Time") private var ironTime: Double = Date().timeIntervalSince1970
    
    @AppStorage("tummy_Enabled") private var tummyEnabled = false
    @AppStorage("tummy_Time") private var tummyTime: Double = Date().timeIntervalSince1970
    
    @AppStorage("teeth_Enabled") private var teethEnabled = false
    @AppStorage("teeth_Time") private var teethTime: Double = Date().timeIntervalSince1970
    
    @AppStorage("bath_Enabled") private var bathEnabled = false
    @AppStorage("bath_Time") private var bathTime: Double = Date().timeIntervalSince1970
    
    var body: some View {
        ZStack {
            Color.themeBackground
                .ignoresSafeArea()
            
            Form {
                Section {
                    ReminderRow(
                        title: "Vitamin D",
                        icon: "sun.max.fill",
                        color: .orange,
                        isEnabled: $vitaminDEnabled,
                        timeValue: $vitaminDTime,
                        attachmentImageName: "icon",
                        notificationID: "vitamin_d_alert",
                        notificationBody: "It's time for your baby's Vitamin D! ☀️"
                    )
                    
                    ReminderRow(
                        title: "Iron Supplement / Blood Drop",
                        icon: "drop.triangle.fill",
                        color: .red,
                        isEnabled: $ironEnabled,
                        timeValue: $ironTime,
                        attachmentImageName: "icon",
                        notificationID: "iron_alert",
                        notificationBody: "Don't forget to give your baby's iron supplement. 💪"
                    )
                } header: {
                    Text("Medicine and Supplements")
                        .font(.caption.bold())
                        .foregroundStyle(Color.themeText.opacity(0.6))
                } footer: {
                    Text("Notifications repeat daily at the time you set.")
                        .foregroundStyle(Color.themeText.opacity(0.5))
                }
                .listRowBackground(Color.themeCardBackground)
                
                Section {
                    ReminderRow(
                        title: "Tummy Time (Exercise)",
                        icon: "figure.play",
                        color: .green,
                        isEnabled: $tummyEnabled,
                        timeValue: $tummyTime,
                        attachmentImageName: "icon",
                        notificationID: "tummy_alert",
                        notificationBody: "It's tummy time for your baby's muscle development! 🐢"
                    )

                    ReminderRow(
                        title: "Tooth Brushing",
                        icon: "sparkles",
                        color: .cyan,
                        isEnabled: $teethEnabled,
                        timeValue: $teethTime,
                        attachmentImageName: "icon",
                        notificationID: "teeth_alert",
                        notificationBody: "Time to brush for pearly white teeth! ✨"
                    )

                    ReminderRow(
                        title: "Bath Time",
                        icon: "bathtub.fill",
                        color: .blue,
                        isEnabled: $bathEnabled,
                        timeValue: $bathTime,
                        attachmentImageName: "icon",
                        notificationID: "bath_alert",
                        notificationBody: "It's bath time for your little water bird! 🛁"
                    )

                    ReminderRow(
                        title: "Bedtime Preparation",
                        icon: "moon.stars.fill",
                        color: .indigo,
                        isEnabled: $sleepEnabled,
                        timeValue: $sleepTime,
                        attachmentImageName: "icon",
                        notificationID: "sleep_alert",
                        notificationBody: "Let the bedtime routine begin! Bath and massage time. 🌙"
                    )
                } header: {
                    Text("Daily Routines")
                        .font(.caption.bold())
                        .foregroundStyle(Color.themeText.opacity(0.6))
                } footer: {
                    Text("Notifications will be repeated daily at the time you specify.")
                        .foregroundStyle(Color.themeText.opacity(0.5))
                }
                .listRowBackground(Color.themeCardBackground)
                
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Reminders")
        .toolbarBackground(Color.themeBackground, for: .navigationBar)
        .onAppear {
            NotificationManager.shared.requestAuthorization()
        }
    }
}

struct ReminderRow: View {
    let title: String
    let icon: String
    let color: Color
    
    @Binding var isEnabled: Bool
    @Binding var timeValue: Double
    
    var attachmentImageName: String? = nil
    
    let notificationID: String
    let notificationBody: String
    
    var dateBinding: Binding<Date> {
        Binding(
            get: { Date(timeIntervalSince1970: timeValue) },
            set: { newDate in
                timeValue = newDate.timeIntervalSince1970
                if isEnabled {
                    schedule()
                }
            }
        )
    }
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.system(size: 20, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Toggle(isOn: $isEnabled) {
                    Text(title)
                        .foregroundStyle(Color.themeText)
                        .font(.body.weight(.medium))
                }
                .tint(color)
                .onChange(of: isEnabled) { _, newValue in
                    if newValue {
                        schedule()
                    } else {
                        cancel()
                    }
                }
                if isEnabled {
                    Rectangle()
                        .fill(Color.themeText.opacity(0.1))
                        .frame(height: 1)
                        .padding(.vertical, 10)
                    
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "alarm")
                                .font(.caption2)
                            Text("Reminder Time")
                                .font(.caption)
                        }
                        .foregroundStyle(Color.gray)
                        
                        Spacer()
                        
                        DatePicker("", selection: dateBinding, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(.compact)
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .padding(.vertical, 8)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isEnabled)
    }
    
    private func schedule() {
        NotificationManager.shared.scheduleDailyNotification(
            identifier: notificationID,
            title: title,
            body: notificationBody,
            time: Date(timeIntervalSince1970: timeValue),
            imageName: attachmentImageName
        )
    }
    
    private func cancel() {
        NotificationManager.shared.cancelNotification(identifier: notificationID)
    }
}
