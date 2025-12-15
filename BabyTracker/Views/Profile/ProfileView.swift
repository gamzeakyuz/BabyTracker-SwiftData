//
//  ProfileView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ProfileView: View {
    
    @Query private var profiles: [BabyLog]
    
    var body: some View {
        ZStack {
            Color.themeBackground
                .ignoresSafeArea()
            
            Group {
                if let profile = profiles.first {
                    NavigationStack {
                        ProfileDetailView(profile: profile)
                    }
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                } else {
                    EditProfileView(profileToEdit: nil)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .animation(.easeInOut(duration: 0.5), value: profiles.isEmpty)
        }
        .tint(Color.themeAccent)
    }
}


#Preview {
    ProfileView()
}
