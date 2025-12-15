//
//  ShareSheet.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//
import SwiftUI
import SwiftData
import Foundation

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
