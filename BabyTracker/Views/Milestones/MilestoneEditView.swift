//
//  MilestoneEditView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//

import SwiftUI
import PhotosUI
import SwiftData

struct MilestoneEditView: View {
    
    @Bindable var milestone: Milestones
    var babyName: String
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.themeBackground
                    .ignoresSafeArea()
                
                Form {
                    Section {
                        HStack {
                            Spacer()
                            VStack(spacing: 12) {
                                PhotosPicker(selection: $selectedItem, matching: .images) {
                                    ZStack {
                                        if let data = selectedPhotoData, let uiImage = UIImage(data: data) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 220, height: 220)
                                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 24)
                                                        .stroke(Color.themeAccent, lineWidth: 3)
                                                )
                                                .shadow(color: Color.black.opacity(0.2), radius: 10)
                                        } else {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 24)
                                                    .fill(Color.themeCardBackground)
                                                    .frame(width: 220, height: 220)
                                                    .shadow(color: Color.black.opacity(0.05), radius: 5)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 24)
                                                            .stroke(Color.themeText.opacity(0.1), lineWidth: 1)
                                                    )
                                                
                                                VStack(spacing: 10) {
                                                    Image(systemName: "camera.macro")
                                                        .font(.system(size: 50))
                                                        .foregroundStyle(Color.themeAccent)
                                                    Text("Add Memory Photo")
                                                        .font(.subheadline)
                                                        .foregroundStyle(Color.themeText.opacity(0.6))
                                                }
                                            }
                                        }
                                        
                                        if selectedPhotoData != nil {
                                            Image(systemName: "pencil.circle.fill")
                                                .font(.system(size: 32))
                                                .foregroundStyle(Color.themeAccent)
                                                .background(Circle().fill(Color.white))
                                                .offset(x: 95, y: 95)
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                                .onChange(of: selectedItem) {
                                    Task {
                                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                                            withAnimation {
                                                selectedPhotoData = data
                                                milestone.photo = data
                                                milestone.isCompleted = true
                                                if milestone.date == nil { milestone.date = Date() }
                                            }
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    
                    Section {
                        HStack {
                            Image(systemName: "text.quote")
                                .foregroundStyle(Color.themeAccent)
                            TextField("Enter Title", text: $milestone.title)
                                .font(.headline)
                                .foregroundStyle(Color.themeText)
                        }
                        
                        Toggle(isOn: $milestone.isCompleted) {
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundStyle(Color.themeAccent)
                                Text("Milestone Achieved")
                                    .foregroundStyle(Color.themeText)
                            }
                        }
                        .tint(Color.themeAccent)
                        
                        if milestone.isCompleted {
                            DatePicker(selection: Binding(
                                get: { milestone.date ?? Date() },
                                set: { milestone.date = $0 }
                            ), displayedComponents: .date) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundStyle(Color.themeAccent)
                                    Text("Date")
                                        .foregroundStyle(Color.themeText)
                                }
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "note.text")
                                    .foregroundStyle(Color.themeAccent)
                                Text("Notes")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.themeText.opacity(0.7))
                            }
                            TextField("Write a short note about this moment..", text: Binding(
                                get: { milestone.note ?? "" },
                                set: { milestone.note = $0 }
                            ), axis: .vertical)
                            .lineLimit(3...6)
                            .foregroundStyle(Color.themeText)
                            .padding(8)
                            .background(Color.themeBackground.opacity(0.5))
                            .cornerRadius(8)
                        }
                        .padding(.vertical, 4)
                        
                    } header: {
                        Text("Details")
                            .foregroundStyle(Color.themeText.opacity(0.6))
                    }
                    .listRowBackground(Color.themeCardBackground)
                    
                    if milestone.isCompleted {
                        Section {
                            ShareLink(item: generateImage(), preview: SharePreview("Special Moment: \(milestone.title)", image: Image(systemName: "star.fill"))) {
                                HStack {
                                    Spacer()
                                    VStack(spacing: 5) {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.title2)
                                        Text("Share This Moment (Story)")
                                            .fontWeight(.bold)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    LinearGradient(colors: [Color.themeAccent, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .foregroundStyle(.white)
                                .cornerRadius(12)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                        } footer: {
                            Text("Share this moment with your loved ones.")
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color.themeText.opacity(0.5))
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(milestone.title.isEmpty ? "New Moment" : milestone.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.themeBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Okay") { dismiss() }
                        .fontWeight(.bold)
                        .foregroundStyle(Color.themeAccent)
                }
            }
            .onAppear {
                selectedPhotoData = milestone.photo
            }
        }
    }
    @MainActor
    private func generateImage() -> Image {
        let cardView = MilestoneCardView(
            title: milestone.title,
            date: milestone.date,
            photoData: milestone.photo,
            babyName: babyName
        )
        
        let renderer = ImageRenderer(content: cardView)
        renderer.scale = 3.0
        
        if let uiImage = renderer.uiImage {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "xmark")
    }
}


#Preview {
    let sampleMilestone = Milestones(
        title: "Firts Tooth",
        date: Date(),
        note: "Lower tooth is starting to show!",
        isCompleted: true
    )
    
    MilestoneEditView(milestone: sampleMilestone, babyName: "Jayna Baby")
        .modelContainer(for: Milestones.self, inMemory: true)
}
