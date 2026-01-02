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
    
    private var progressFraction: Double {
        let total = max(app.totalDocuments, 0)
        guard total > 0 else { return 0 }
        let fraction = Double(app.completedDocuments) / Double(total)
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
            
            Text(percentString)
                .font(.system(size: 25, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(NBNColors.elAlHaiti)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    ProgressRing()
}

