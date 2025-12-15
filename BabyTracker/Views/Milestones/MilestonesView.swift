//
//  MilestonesView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//

import SwiftUI
import SwiftData
import PhotosUI

struct MilestonesView: View {
    
    @Query private var milestones: [Milestones]
    @Query private var profiles: [BabyLog]
    @Environment(\.modelContext) private var modelContext
    
    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    @State private var selectedMilestone: Milestones?
    @State private var showEditSheet = false
    
    @State private var showAddAlert = false
    @State private var newMilestoneTitle = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.themeBackground
                    .ignoresSafeArea()
                
                if milestones.isEmpty {
                    ContentUnavailableView {
                        Label("No Cards Yet", systemImage: "star.slash")
                            .foregroundStyle(Color.themeAccent)
                    } description: {
                        Text("Your list looks empty. You can load the default list or add a new one.")
                            .foregroundStyle(Color.themeText)
                    } actions: {
                        Button("Load Default List") {
                            checkAndCreateDefaults()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.themeAccent)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(milestones.sorted(by: { !$0.isCompleted && $1.isCompleted })) { item in
                                MilestoneGridItem(item: item)
                                    .onTapGesture {
                                        selectedMilestone = item
                                        showEditSheet = true
                                    }
                            }
                        }
                        .padding()
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Milestones")
            .toolbarBackground(Color.themeBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        newMilestoneTitle = ""
                        showAddAlert = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.themeAccent)
                    }
                }
                
            }
            .alert("Add New Special Moment", isPresented: $showAddAlert) {
                TextField("Title (e.g., First Holiday)", text: $newMilestoneTitle)
                Button("Cancel", role: .cancel) { }
                Button("Add") {
                    addNewMilestone()
                }
                .disabled(newMilestoneTitle.isEmpty)
            }
            .onAppear {
                if milestones.isEmpty {
                    checkAndCreateDefaults()
                }
            }
            .sheet(item: $selectedMilestone) { item in
                MilestoneEditView(milestone: item, babyName: profiles.first?.name ?? "My Baby")
            }
        }
    }
    
    private func checkAndCreateDefaults() {
        let existingTitles = milestones.map { $0.title }
        for title in MilestoneDefaults.list {
            if !existingTitles.contains(title) {
                let newItem = Milestones(title: title)
                modelContext.insert(newItem)
            }
        }
    }
    
    private func addNewMilestone() {
        let newItem = Milestones(title: newMilestoneTitle)
        withAnimation {
            modelContext.insert(newItem)
        }
    }
}

struct MilestoneGridItem: View {
    let item: Milestones
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            ZStack(alignment: .topTrailing) {
                if let data = item.photo, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 165, height: 165)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.themeText.opacity(0.1), lineWidth: 1)
                        )
                } else {
                    ZStack {
                        Color.themeCardBackground
                        
                        VStack(spacing: 5) {
                            Image(systemName: item.isCompleted ? "checkmark.seal.fill" : "camera.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(item.isCompleted ? Color.themeAccent : Color.gray.opacity(0.4))
                            
                            if !item.isCompleted {
                                Text("Add Photo")
                                    .font(.caption2)
                                    .foregroundStyle(Color.gray)
                            }
                        }
                    }
                    .frame(width: 165, height: 165)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.themeText.opacity(0.1), lineWidth: 1)
                    )
                }
                
                if item.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.white)
                        .background(Circle().fill(Color.green))
                        .padding(8)
                        .shadow(radius: 2)
                }
            }
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.themeText)
                    .lineLimit(1)
                
                if let date = item.date, item.isCompleted {
                    Text(date.formatted(date: .numeric, time: .omitted))
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.themeAccent.opacity(0.1))
                        .clipShape(Capsule())
                        .foregroundStyle(Color.themeAccent)
                } else {
                    Text("Not Yet")
                        .font(.caption2)
                        .foregroundStyle(Color.gray.opacity(0.6))
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

#Preview {
    MilestonesView()
        .modelContainer(for: [Milestones.self, BabyLog.self], inMemory: true)
}
