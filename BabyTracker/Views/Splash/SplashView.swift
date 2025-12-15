//
//  SplashView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//

import SwiftUI

struct SplashView: View {
    
    @Binding var isActive: Bool
    @State private var startAnimation = false
    @State private var circleAnimation = false
        
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.themeBackground, Color.themeAccent.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                ZStack {
                    ForEach(0..<3) { index in
                        Circle()
                            .stroke(Color.themeAccent.opacity(0.3), lineWidth: 2)
                            .frame(width: 80, height: 80)
                            .scaleEffect(circleAnimation ? 2.8 : 1)
                            .opacity(circleAnimation ? 0 : 1)
                            .animation(
                                .easeOut(duration: 1.5).repeatForever(autoreverses: false).delay(Double(index) * 0.3),
                                value: circleAnimation
                            )
                    }
                    .padding()
                    
                    Circle()
                        .fill(Color.themeCardBackground)
                        .frame(width: 80, height: 80)
                        .shadow(color: Color.themeAccent.opacity(0.2), radius: 15, x: 0, y: 10)
                        .overlay {
                            Image(systemName: "stroller.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.themeAccent, Color.rawIceBlue],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        }
                        .scaleEffect(startAnimation ? 1 : 0.5)
                        .rotationEffect(.degrees(startAnimation ? 0 : -45))
                }
                .padding(.bottom, 10)
                
                VStack(spacing: 8) {
                    Text("BabySteps")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color.themeAccent)
                    
                    Text("Growth, Health and Routine")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.themeText.opacity(0.7))
                        .tracking(1.5)
                }
                .opacity(startAnimation ? 1 : 0)
                .offset(y: startAnimation ? 0 : 20)
            }
        }
        .onAppear {
            circleAnimation = true
            
            withAnimation(.interpolatingSpring(stiffness: 80, damping: 7)) {
                startAnimation = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView(isActive: .constant(false))
}
