//
//  AddGrowthSheet.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//

import SwiftUI
import SwiftData

struct AddGrowthSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var date = Date()
    @State private var weightString = ""
    @State private var heightString = ""
    @State private var headString = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.themeBackground
                    .ignoresSafeArea()
                
                Form {
                    Section {
                        DatePicker(selection: $date, displayedComponents: .date) {
                            HStack {
                                Image(systemName: "calendar.badge.plus")
                                    .foregroundStyle(Color.themeAccent)
                                Text("Measurement Date")
                                    .foregroundStyle(Color.themeText)
                            }
                        }
                    } header: {
                        Text("TİME")
                            .foregroundStyle(Color.themeText.opacity(0.6))
                    }
                    .listRowBackground(Color.themeCardBackground)
                    
                    Section {
                        MeasurementRow(
                            icon: "scalemass.fill",
                            title: "Weight",
                            unit: "kg",
                            text: $weightString
                        )
                        
                        MeasurementRow(
                            icon: "ruler.fill",
                            title: "Height",
                            unit: "cm",
                            text: $heightString
                        )
                        
                        MeasurementRow(
                            icon: "face.dashed",
                            title: "Head Circumference",
                            unit: "cm",
                            text: $headString
                        )
                        
                    } header: {
                        Text("Physical Development")
                            .foregroundStyle(Color.themeText.opacity(0.6))
                    }
                    .listRowBackground(Color.themeCardBackground)
                    
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Growth Record")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.themeBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.red.opacity(0.8))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveRecord()
                    }
                    .disabled(weightString.isEmpty || heightString.isEmpty)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.themeAccent)
                }
            }
        }
    }
}

struct MeasurementRow: View {
    let icon: String
    let title: String
    let unit: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.themeAccent.opacity(0.15))
                    .frame(width: 30, height: 30)
                Image(systemName: icon)
                    .font(.caption.bold())
                    .foregroundStyle(Color.themeAccent)
            }
            
            Text(title)
                .foregroundStyle(Color.themeText)
            
            Spacer()
            
            TextField("0.0", text: $text)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(Color.themeText)
                .frame(width: 60)
            
            Text(unit)
                .font(.caption)
                .foregroundStyle(Color.gray)
                .frame(width: 25, alignment: .leading)
        }
    }
}

extension AddGrowthSheet {
    
    private func saveRecord(){
        let weight = Double(weightString.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let height = Double(heightString.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let head = Double(headString.replacingOccurrences(of: ",", with: "."))
        
        let newRecord = GrowthRecord(date: date, weight: weight, height: height, headCircumference: head)
        modelContext.insert(newRecord)
        dismiss()
    }
    
}

#Preview {
    AddGrowthSheet()
}
