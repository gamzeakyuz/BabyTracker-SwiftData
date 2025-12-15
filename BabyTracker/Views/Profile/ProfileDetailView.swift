//
//  ProfileDetailView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//
import SwiftUI

struct ProfileDetailView: View {
    
    let profile: BabyLog
    @State private var showEditSheet = false
    @State private var showSettingSheet = false
    
    var body: some View {
        ZStack {
            Color.themeBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    VStack(spacing: 15) {
                        if let data = profile.photo, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.themeAccent, lineWidth: 3)
                                )
                                .shadow(color: Color.themeAccent.opacity(0.3), radius: 10, x: 0, y: 5)
                        } else {
                            ZStack {
                                Circle()
                                    .fill(Color.themeCardBackground)
                                    .frame(width: 140, height: 140)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5)
                                
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60)
                                    .foregroundStyle(Color.themeAccent.opacity(0.5))
                            }
                        }
                        
                        Text(profile.name)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.themeText)
                        
                        Text("\(calculateAge())")
                            .font(.subheadline.bold())
                            .foregroundStyle(Color.themeAccent)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.themeAccent.opacity(0.1))
                            .clipShape(Capsule())
                    }
                    .padding(.top, 20)
                    
                    Rectangle()
                        .fill(Color.themeText.opacity(0.1))
                        .frame(height: 1)
                        .padding(.horizontal, 40)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Info")
                            .font(.title3.bold())
                            .foregroundStyle(Color.themeText)
                            .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            InfoCard(
                                title: "Date of Birth",
                                value: profile.birthDate.formatted(date: .long, time: .omitted),
                                icon: "calendar.badge.clock"
                            )
                            
                            InfoCard(
                                title: "Gender",
                                value: profile.gender.rawValue,
                                icon: "person.text.rectangle"
                            )
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            InfoCard(
                                title: "Birth Weight",
                                value: profile.birthWeight != nil ? String(format: "%.2f kg", profile.birthWeight!) : "-",
                                icon: "scalemass.fill"
                            )
                            
                            InfoCard(
                                title: "Birth Height",
                                value: profile.birthHeight != nil ? "\(Int(profile.birthHeight!)) cm" : "-",
                                icon: "ruler.fill"
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.themeBackground, for: .navigationBar) 
        .toolbar {
            ToolbarItem(placement: .secondaryAction) {
                Button("Edit") {
                    showEditSheet = true
                }
                .foregroundStyle(Color.themeAccent)
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showSettingSheet = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(Color.themeText)
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EditProfileView(profileToEdit: profile)
        }
        .sheet(isPresented: $showSettingSheet) {
            SettingsView()
        }
    }
}

extension ProfileDetailView {
    private func calculateAge() -> String {
        let components = Calendar.current.dateComponents([.year, .month], from: profile.birthDate, to: Date())
        let years = components.year ?? 0
        let months = components.month ?? 0
        
        if years > 0 {
            return "\(years) Age \(months) Month"
        } else {
            return "\(months) Monthly"
        }
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.themeAccent.opacity(0.15))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.caption.bold())
                        .foregroundStyle(Color.themeAccent)
                }
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.themeText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(Color.themeText.opacity(0.6))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.themeCardBackground)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
