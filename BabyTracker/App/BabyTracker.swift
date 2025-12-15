//
//  myBabyApp.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 10.12.2025.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct BabyTracker: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    @State private var isSplashFinished = false
    
    let container: ModelContainer
    
    init() {
        let fileManager = FileManager.default
        if let supportDir = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            if !fileManager.fileExists(atPath: supportDir.path) {
                do {
                    try fileManager.createDirectory(at: supportDir, withIntermediateDirectories: true)
                    print("✅ (Fix) AThe Application Support folder was created manually.")
                } catch {
                    print("❌ (Fix) Folder could not be created: \(error)")
                }
            }
        }
        let schema = Schema([
            DailyLog.self,
            GrowthRecord.self,
            BabyLog.self,
            Vaccine.self,
            Milestones.self,
            ToothLog.self
        ])
        
        do {
            container = try ModelContainer(for: schema, configurations: [])
        } catch {
            fatalError("ModelContainer could not be initialized: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isSplashFinished {
                    if hasSeenOnboarding {
                        MainTabView()
                            .transition(.opacity)
                    } else {
                        OnboardingView(showOnboarding: $hasSeenOnboarding)
                            .transition(.opacity)
                    }
                } else {
                    SplashView(isActive: $isSplashFinished)
                }
            }
            .tint(Color.themeAccent)
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .modelContainer(container)
    }
}
