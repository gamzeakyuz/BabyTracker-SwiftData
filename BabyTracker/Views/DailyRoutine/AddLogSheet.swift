//
//  AddLogSheet.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 10.12.2025.
//

import SwiftUI
import SwiftData

struct AddLogSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var selectedType: LogType = .feeding
    @State private var selectedReaction: FoodReaction? = nil
    
    @State private var date = Date()
    @State private var note = ""
    
    @State private var valueString = ""
    @State private var selectedSubType = ""
    
    let feedingType = ["Breast Milk","Baby Food"]
    let diaperType = ["Pee", "Poop","Mixed"]
    let sleepTypes = ["Night Sleep", "Nap"]
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                Color.themeBackground
                    .ignoresSafeArea()
                
                Form {
                    Section {
                        Picker(selection: $selectedType) {
                            ForEach(LogType.allCases, id: \.self) { type in
                                Label(type.rawValue, systemImage: type.iconName)
                                    .tag(type)
                            }
                        } label: {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.themeAccent.opacity(0.15))
                                        .frame(width: 32, height: 32)
                                    Image(systemName: selectedType.iconName)
                                        .foregroundStyle(Color.themeAccent)
                                }
                                Text("Activity Type")
                                    .foregroundStyle(Color.themeText)
                            }
                        }
                        .pickerStyle(.menu)
                        .accessibilityIdentifier("typePicker")
                        
                        DatePicker(selection: $date, displayedComponents: [.date, .hourAndMinute]) {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundStyle(Color.themeAccent)
                                Text("Time")
                                    .foregroundStyle(Color.themeText)
                            }
                        }
                    }header: {
                        Text("GENERAL INFORMATION")
                            .foregroundStyle(Color.themeText.opacity(0.6))
                    }
                    .listRowBackground(Color.themeCardBackground)
                    
                    Section {
                        if selectedType == .feeding {
                            Picker(selection: $selectedSubType) {
                                Text("Choose").tag("")
                                ForEach(feedingType, id: \.self) { Text($0).tag($0) }
                            } label: {
                                RowLabel(icon: "fork.knife", title: "Nutrition Type")
                            }
                            
                            HStack {
                                RowLabel(icon: "drop.fill", title: "Amount")
                                Spacer()
                                TextField("0", text: $valueString)
                                    .accessibilityIdentifier(K.Identifiers.amountField)
                                    .keyboardType(.decimalPad)
                                    .modifier(AddLogTextField())
                                Text("ml")
                                    .foregroundStyle(.gray)
                                    .accessibilityIdentifier(K.Defaults.currency)
                            }
                            
                        } else if selectedType == .sleep {
                            Picker(selection: $selectedSubType) {
                                Text("Choose").tag("")
                                ForEach(sleepTypes, id: \.self) { Text($0).tag($0) }
                            } label: {
                                RowLabel(icon: "bed.double.fill", title: "Sleep Type")
                            }
                            
                            HStack {
                                RowLabel(icon: "hourglass", title: "Duration")
                                Spacer()
                                TextField("0", text: $valueString)
                                    .keyboardType(.numberPad)
                                    .modifier(AddLogTextField())
                                Text("min")
                                    .foregroundStyle(.gray)
                            }
                            
                        } else if selectedType == .diaper {
                            VStack(alignment: .leading, spacing: 10) {
                                RowLabel(icon: "toilet.fill", title: "Situation")
                                Picker("Situation", selection: $selectedSubType) {
                                    ForEach(diaperType, id: \.self) { type in
                                        Text(type).tag(type)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding(.vertical, 5)
                            }
                        } else if selectedType == .solidFood {
                            
                            HStack {
                                RowLabel(icon: "carrot.fill", title:"What did she/he eat?")
                                Spacer()
                                TextField("Examples: carrots, eggs", text: $selectedSubType)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundStyle(Color.themeText)
                            }
                            
                            VStack(alignment: .leading, spacing: 10){
                                RowLabel(icon: "face.smiling", title: "Her/His reaction")
                                
                                Picker("Reaction", selection: $selectedReaction) {
                                    ForEach(FoodReaction.allCases, id: \.self) { type in
                                        Text(type.rawValue).tag(type)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            .padding(.vertical, 5)
                            
                        }
                        
                        HStack(alignment: .top) {
                            Image(systemName: "note.text")
                                .foregroundStyle(Color.themeAccent)
                                .padding(.top, 5)
                            
                            TextField("Add a note (optional)...", text: $note, axis: .vertical)
                                .lineLimit(3...10)
                                .foregroundStyle(Color.themeText)
                        }
                    } header: {
                        Text("DETAIL")
                            .foregroundStyle(Color.themeText.opacity(0.6))
                    }
                    .listRowBackground(Color.themeCardBackground)
                }
                .scrollContentBackground(.hidden)
                
            }
            .navigationTitle("New Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveLog()
                    }
                    .disabled(validateForm() == false)
                    .accessibilityIdentifier(K.Identifiers.saveButton)
                }
            }
            
        }
        .onChange(of: selectedType) { _, newValue in
            resetFields(for: newValue)
        }
    }
    func RowLabel(icon: String, title: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(Color.themeAccent)
                .frame(width: 20)
            Text(title)
                .foregroundStyle(Color.themeText)
        }
    }
}

extension AddLogSheet {
    private func resetFields(for type: LogType) {
        
        valueString = ""
        note = ""
        selectedReaction = nil
        
        switch type {
        case .feeding:
            selectedSubType = feedingType.first ?? ""
        case .diaper:
            selectedSubType = diaperType.first ?? ""
        case .sleep:
            selectedSubType = sleepTypes.first ?? ""
        case .medicine, .activity:
            selectedSubType = ""
        case .solidFood:
            selectedSubType = ""
        }
    }
    
    private func saveLog() {
        let normalized = valueString.replacingOccurrences(of: ",", with: ".")
        let value = Double(normalized)
        let finalReaction = (selectedType == .solidFood) ? selectedReaction : nil
        
        let unit: String?
        switch selectedType {
        case .feeding: unit = "ml"
        case .sleep: unit = "min"
        default: unit = nil
        }
        
        let newLog = DailyLog(
            date: date,
            type: selectedType,
            subType: selectedSubType.isEmpty ? nil : selectedSubType,
            note: note.isEmpty ? nil : note,
            value: value,
            unit: unit,
            reaction: finalReaction
        )
        
        modelContext.insert(newLog)
        dismiss()
    }
    
    private func validateForm() -> Bool {
        switch selectedType {
        case .feeding, .sleep:
            let normalized = valueString.replacingOccurrences(of: ",", with: ".")
            return Double(normalized) != nil
        default:
            return true
        }
    }
}

#Preview {
    AddLogSheet()
}
