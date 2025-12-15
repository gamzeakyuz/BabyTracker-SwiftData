//
//  MainTabView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 10.12.2025.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        TabView {
            
            DailyRoutineView()
                .tabItem {
                    Label("Daily", systemImage: "list.bullet.clipboard")
                }
            
            GrowthView()
                .tabItem {
                    Label("Growth", systemImage: "chart.xyaxis.line")
                }
            
            HealthView()
                .tabItem {
                    Label("Health", systemImage: "heart.text.square")
                }
            
            MilestonesView()
                .tabItem {
                    Label("Milestones", systemImage: "photo.stack")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .tint(Color.themeAccent)
    }
}

#Preview {
    MainTabView()
}
