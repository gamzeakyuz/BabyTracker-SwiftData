//
//  EditProfileView.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var profileToEdit: BabyLog?
    
    @State private var name = ""
    @State private var birthDate = Date()
    @State private var gender: Gender = .boy
    @State private var birthWeight = ""
    @State private var birthHeight = ""
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedPhotoData: Data? = nil
    
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
                                                .frame(width: 130, height: 130)
                                                .clipShape(Circle())
                                                .overlay(
                                                    Circle().stroke(Color.themeAccent, lineWidth: 3)
                                                )
                                                .shadow(color: Color.themeAccent.opacity(0.3), radius: 8)
                                        } else {
                                            Circle()
                                                .fill(Color.themeCardBackground)
                                                .frame(width: 130, height: 130)
                                                .overlay(
                                                    Circle().stroke(Color.themeText.opacity(0.1), lineWidth: 1)
                                                )
                                                .overlay {
                                                    Image(systemName: "camera.fill")
                                                        .font(.largeTitle)
                                                        .foregroundStyle(Color.themeAccent.opacity(0.6))
                                                }
                                        }
                                        
                                        Circle()
                                            .fill(Color.themeAccent)
                                            .frame(width: 32, height: 32)
                                            .overlay {
                                                Image(systemName: "pencil")
                                                    .font(.caption.bold())
                                                    .foregroundStyle(.white)
                                            }
                                            .offset(x: 45, y: 45)
                                    }
                                }
                                .onChange(of: selectedItem) {
                                    Task {
                                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                                            selectedPhotoData = data
                                        }
                                    }
                                }
                                
                                Text(selectedPhotoData == nil ? "Add Photo" : "Change Photo")
                                    .font(.footnote.weight(.medium))
                                    .foregroundStyle(Color.themeAccent)
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
                    
                    Section {
                        HStack {
                            Image(systemName: "person.text.rectangle")
                                .foregroundStyle(Color.themeAccent)
                            TextField("Baby Name", text: $name)
                                .foregroundStyle(Color.themeText)
                                .accessibilityIdentifier(K.Defaults.babyName)
                        }
                        
                        DatePicker(selection: $birthDate, displayedComponents: .date) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundStyle(Color.themeAccent)
                                Text("Date of birth")
                                    .foregroundStyle(Color.themeText)
                            }
                        }
                        
                        Picker(selection: $gender) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                Text(gender.rawValue).tag(gender)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "person.2.circle")
                                    .foregroundStyle(Color.themeAccent)
                                Text("Gender")
                            }
                        }
                        .pickerStyle(.menu)
                        .listRowSeparator(.hidden)
                    } header: {
                        Text("BASIC INFORMATION")
                            .foregroundStyle(Color.themeText.opacity(0.6))
                    }
                    .listRowBackground(Color.themeCardBackground)
                    
                    Section {
                        HStack {
                            Image(systemName: "scalemass.fill")
                                .foregroundStyle(Color.themeAccent)
                                .frame(width: 20)
                            Text("Weight (kg)")
                                .foregroundStyle(Color.themeText)
                            Spacer()
                            TextField("0.0", text: $birthWeight)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(Color.themeText)
                        }
                        
                        HStack {
                            Image(systemName: "ruler.fill")
                                .foregroundStyle(Color.themeAccent)
                                .frame(width: 20)
                            Text("Height (cm)")
                                .foregroundStyle(Color.themeText)
                            Spacer()
                            TextField("0.0", text: $birthHeight)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(Color.themeText)
                        }
                    } header: {
                        Text("Birth Measurements")
                            .foregroundStyle(Color.themeText.opacity(0.6))
                    }
                    .listRowBackground(Color.themeCardBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(profileToEdit == nil ? "Create Profile" : "Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.themeBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if profileToEdit != nil {
                        Button("Cancel") { dismiss() }
                            .foregroundStyle(Color.red.opacity(0.8))
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .accessibilityIdentifier(K.Identifiers.saveProfileButton)
                        .disabled(name.isEmpty)
                        .foregroundStyle(Color.themeAccent)
                        .fontWeight(.bold)
                }
            }
            .onAppear {
                loadExistingData()
            }
        }
    }
}
extension EditProfileView {
    private func loadExistingData() {
        if let profile = profileToEdit {
            name = profile.name
            birthDate = profile.birthDate
            gender = profile.gender
            selectedPhotoData = profile.photo
            if let w = profile.birthWeight { birthWeight = String(w) }
            if let h = profile.birthHeight { birthHeight = String(h) }
        }
    }
    
    private func save() {
        let weight = Double(birthWeight.replacingOccurrences(of: ",", with: "."))
        let height = Double(birthHeight.replacingOccurrences(of: ",", with: "."))
        
        if let profile = profileToEdit {
            profile.name = name
            profile.birthDate = birthDate
            profile.gender = gender
            profile.photo = selectedPhotoData
            profile.birthWeight = weight
            profile.birthHeight = height
            
        } else {
            let newProfile = BabyLog(
                name: name,
                birthDate: birthDate,
                gender: gender,
                photo: selectedPhotoData,
                birthWeight: weight,
                birthHeight: height
            )
            modelContext.insert(newProfile)
        }
        
        dismiss()
    }
}


#Preview {
    EditProfileView()
}
