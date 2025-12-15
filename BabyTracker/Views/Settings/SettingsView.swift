//
//  SettingsView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//

import SwiftUI
import SwiftData
import StoreKit

struct SettingsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("measurementUnit") private var measurementUnit = "Metric"
    
    @State private var showResetAlert = false
    @State private var showShareSheet = false
    
    @State private var showPermissionAlert = false
    @State private var permissionAlertTitle = ""
    @State private var permissionAlertMessage = ""
    @State private var showSettingsButton = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.themeBackground
                    .ignoresSafeArea()
                
                Form {
                    
                    Section {
                        Toggle(isOn: $notificationsEnabled) {
                            Label {
                                Text("Allow Notifications")
                                    .foregroundStyle(Color.themeText)
                            } icon: {
                                Image(systemName: "bell.badge.fill")
                                    .foregroundStyle(Color.themeAccent)
                            }
                        }
                        .tint(Color.themeAccent)
                        
                        if notificationsEnabled {
                            NavigationLink {
                                NotificationSettingsView()
                            } label: {
                                Text("Current Notifications")
                                    .foregroundStyle(Color.themeText)
                            }
                        }
                        Button {
                            checkNotificationStatus()
                        } label: {
                            Text("Test Permission Status")
                                .font(.caption)
                                .foregroundStyle(Color.themeAccent)
                        }
                        
                    } header: {
                        Text("NOTIFICATIONS")
                            .foregroundStyle(Color.themeText.opacity(0.6))
                    } footer: {
                        Text("Manages vaccine and routine reminders.")
                            .foregroundStyle(Color.themeText.opacity(0.5))
                    }
                    .listRowBackground(Color.themeCardBackground)
                    
                    Section("PREFERENCES") {
                        Toggle(isOn: $isDarkMode) {
                            Label {
                                Text("Dark Mode")
                                    .foregroundStyle(Color.themeText)
                            } icon: {
                                Image(systemName: "moon.stars.fill")
                                    .foregroundStyle(Color.themeAccent)
                            }
                        }
                        .tint(Color.themeAccent)
                    }
                    .listRowBackground(Color.themeCardBackground)
                    
                    
                    Section("DATA MANAGEMENT") {
                        Button {
                            showShareSheet = true
                        } label: {
                            Label {
                                Text("Share Doctor Report (PDF)")
                                    .foregroundStyle(Color.themeText)
                            } icon: {
                                Image(systemName: "doc.text.fill")
                                    .foregroundStyle(Color.themeAccent)
                            }
                        }
                    }
                    .listRowBackground(Color.themeCardBackground)
                    
                    Section {
                        Button(role: .destructive) {
                            showResetAlert = true
                        } label: {
                            Label("Reset All Data", systemImage: "trash")
                        }
                    } footer: {
                        Text("This action cannot be undone.")
                            .foregroundStyle(Color.red.opacity(0.7))
                    }
                    .listRowBackground(Color.themeCardBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .toolbarBackground(Color.themeBackground, for: .navigationBar)
            .toolbarColorScheme(isDarkMode ? .dark : .light, for: .navigationBar)
            .preferredColorScheme(isDarkMode ? .dark : .light)
            
            .alert("Delete All Data?", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    resetAllData()
                }
            } message: {
                Text("All routines, vaccines, and growth records for your baby will be permanently deleted.")
            }
            
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(items: ["My Baby's Growth Report: \nWeight: 6.5kg\nHeight: 62cm\nVaccines: Completed."])
            }
            .alert(permissionAlertTitle, isPresented: $showPermissionAlert) {
                if showSettingsButton {
                    Button("Go to Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    Button("Okay", role: .cancel) { }
                } else {
                    Button("Okay", role: .cancel) { }
                }
            } message: {
                Text(permissionAlertMessage)
            }
            
        }
    }
}

extension SettingsView {
    private func resetAllData() {
        do {
            try modelContext.delete(model: DailyLog.self)
            try modelContext.delete(model: GrowthRecord.self)
            try modelContext.delete(model: BabyLog.self)
            try modelContext.delete(model: Vaccine.self)
        } catch {
            print("Data Deletion Error: \(error)")
        }
    }
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    permissionAlertTitle = "✅ Permission Granted"
                    permissionAlertMessage = "Your app has notification access. All good!"
                    showSettingsButton = false
                    
                case .denied:
                    permissionAlertTitle = "🚫 Permission Denied"
                    permissionAlertMessage = "You have disabled notifications. Please enable them in Settings for reminders to work."
                    showSettingsButton = true
                    
                case .notDetermined:
                    NotificationManager.shared.requestAuthorization()
                    return
                    
                default:
                    permissionAlertTitle = "Unknown Status"
                    permissionAlertMessage = "An unknown situation occurred."
                    showSettingsButton = false
                }
                showPermissionAlert = true
            }
        }
    }
}


#Preview {
    SettingsView()
}
