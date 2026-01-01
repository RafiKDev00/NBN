//
//  DocumentsIcon.swift
//  NBN
//
//  Created by RJ  Kigner on 12/31/25.
//

import SwiftUI


import SwiftUI

struct DocumentsIcon: View {
    var lineWidth: CGFloat = 1.5

    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height

            let docW = w * 0.56
            let docH = h * 0.66
            let r = w * 0.06

            let baseX = w * 0.24
            let baseY = h * 0.18

            let dx = w * 0.06
            let dy = h * 0.04

            let stroke = StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)

            // Front document
            let frontRect = CGRect(x: baseX, y: baseY, width: docW, height: docH)
            let frontPath = Path(roundedRect: frontRect, cornerRadius: r)

            // Back documents (full shapes)
            let back1Rect = CGRect(x: baseX - dx, y: baseY + dy, width: docW, height: docH)
            let back2Rect = CGRect(x: baseX - 2*dx, y: baseY + 2*dy, width: docW, height: docH)

            let back1Path = Path(roundedRect: back1Rect, cornerRadius: r)
            let back2Path = Path(roundedRect: back2Rect, cornerRadius: r)

            // 1) Draw the back docs
            context.stroke(back2Path, with: .color(.primary), style: stroke)
            context.stroke(back1Path, with: .color(.primary), style: stroke)

            // 2) Erase anything that lies under the front doc (true occlusion)
            context.blendMode = .destinationOut
            context.fill(frontPath, with: .color(.black)) // color doesn't matter; it erases
            context.blendMode = .normal

            // 3) Draw the front doc on top
            context.stroke(frontPath, with: .color(.primary), style: stroke)

            // 4) Add text lines (front only)
            let insetX = w * 0.08
            let x1 = frontRect.minX + insetX
            let x2 = frontRect.maxX - insetX

            for i in 0..<3 {
                let y = frontRect.minY + docH * (0.32 + CGFloat(i) * 0.18)
                var line = Path()
                line.move(to: CGPoint(x: x1, y: y))
                line.addLine(to: CGPoint(x: x2, y: y))
                context.stroke(line, with: .color(.primary), style: stroke)
            }
        }
        .frame(width: 30, height: 30)
    }
}



#Preview{
    DocumentsIcon()
}
