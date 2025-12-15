//
//  MilestoneCardView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//

import SwiftUI

struct MilestoneCardView: View {
    
    var title: String
    var date: Date?
    var photoData: Data?
    var babyName: String
    
    var body: some View {
        ZStack {
            if let data = photoData, let uiImage = UIImage(data: data) {
                GeometryReader { geometry in
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .blur(radius: 20)
                        .overlay(Color.black.opacity(0.4))
                        .clipped()
                }
            } else {
                LinearGradient(
                    colors: [Color.themeAccent, Color.themeBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            
            VStack(spacing: 25) {
                
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                    Text("Memorable Moment")
                        .font(.headline)
                        .tracking(2)
                    Image(systemName: "sparkles")
                }
                .foregroundStyle(.white.opacity(0.9))
                .padding(.top, 40)
                
                Spacer()
                
                VStack(spacing: 0) {
                    if let data = photoData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 280, height: 280)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(15)
                    } else {
                        ZStack {
                            Color.themeBackground.opacity(0.1)
                            Image(systemName: "camera.macro")
                                .font(.system(size: 60))
                                .foregroundStyle(Color.themeAccent.opacity(0.5))
                        }
                        .frame(width: 280, height: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(15)
                    }
                    
                    VStack(spacing: 10) {
                        Text(title)
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.themeText)
                            .padding(.horizontal)
                        
                        if let date = date {
                            HStack {
                                Image(systemName: "calendar")
                                Text(date.formatted(date: .long, time: .omitted))
                            }
                            .font(.caption.bold())
                            .foregroundStyle(Color.themeAccent)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 12)
                            .background(Color.themeAccent.opacity(0.1))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.bottom, 25)
                }
                .background(Color.themeCardBackground)
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
                
                Spacer()
                
                HStack {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 30, height: 30)
                        Image(systemName: "stroller.fill")
                            .font(.caption)
                    }
                    Text("\(babyName)'s Journal")
                        .font(.subheadline.bold())
                    
                    Spacer()
                    
                    Text("BabySteps App")
                        .font(.caption)
                        .opacity(0.7)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .frame(width: 360, height: 640)
        .clipped()
        .cornerRadius(30)
    }
}

#Preview {
    MilestoneCardView(title: "First Step", date: Date(), photoData: nil, babyName: "Jayna Baby")
}
