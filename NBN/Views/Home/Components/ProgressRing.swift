//
//  ProgressRing.swift
//  NBN
//
//  Created by RJ  Kigner on 1/2/26.
//

import SwiftUI

struct ProgressRing: View {
    @StateObject private var app = AppModel.shared
    
    var size: CGFloat = 120
    var lineWidth: CGFloat = 16
    var overrideCompleted: Int?
    var overrideTotal: Int?
    
    private var progressFraction: Double {
        let completed = Double(overrideCompleted ?? app.completedDocuments)
        let total = Double(overrideTotal ?? app.totalDocuments)
        guard total > 0 else { return 0 }
        let fraction = completed / total
        return min(max(fraction, 0), 1)
    }

    private var percentString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: progressFraction)) ?? "0%"
    }

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 1)
                .rotation(.degrees(-90))
                .stroke(.quinary, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            Circle()
                .trim(from: 0, to: progressFraction)
                .rotation(.degrees(-90))
                .stroke(NBNColors.bondiBlue, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .shadow(color: NBNColors.bondiBlue.opacity(0.4), radius: 2, x: 0, y: 0)
            
            Text(percentString)
                .font(.system(size: 25, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(NBNColors.elAlHaiti)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    VStack(spacing: 16) {
        ProgressRing(overrideCompleted: 6, overrideTotal: 12)
        Spacer()
        ProgressRing(overrideCompleted: 12, overrideTotal: 12)
        Spacer()
        ProgressRing(overrideCompleted: 0, overrideTotal: 12)
    }
    .padding()
}
