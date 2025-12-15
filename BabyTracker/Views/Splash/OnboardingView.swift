//
//  OnboardingView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 13.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            image: "list.bullet.clipboard",
            title: "Track Daily Routines",
            description: "Log feeding, sleep, and diaper changes in seconds."
        ),
        OnboardingPage(
            image: "chart.xyaxis.line",
            title: "Monitor Growth",
            description: "Track your baby's height and weight with WHO-standard charts."
        ),
        OnboardingPage(
            image: "heart.text.square.fill",
            title: "Vaccines & Health",
            description: "Stay on top of vaccines, dental development, and medicine reminders."
        ),
        OnboardingPage(
            image: "photo.stack.fill",
            title: "Capture Special Moments",
            description: "First smile, first step... Preserve your baby's milestones with photos."
        )
    ]
    
    var body: some View {
        ZStack {
            Color.themeBackground.ignoresSafeArea()
            
            TabView {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index], isLastPage: index == pages.count - 1, action: {
                        withAnimation {

                            showOnboarding = true
                        }
                    })
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isLastPage: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.themeAccent.opacity(0.1))
                    .frame(width: 200, height: 200)
                
                Image(systemName: page.image)
                    .font(.system(size: 80))
                    .foregroundStyle(Color.themeAccent)
            }
            .padding(.bottom, 20)
            
            Text(page.title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(Color.themeText)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.body)
                .foregroundStyle(Color.themeText.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Spacer()
            
            if isLastPage {
                Button(action: action) {
                    Text("Let's begin.")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.themeAccent)
                        .cornerRadius(15)
                }
                .accessibilityIdentifier(K.Identifiers.onboardingStartButton)
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            } else {
                Color.clear.frame(height: 50).padding(.bottom, 50)
            }
        }
    }
}
