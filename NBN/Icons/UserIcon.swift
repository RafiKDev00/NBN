//
//  UserIcon.swift
//  NBN
//
//  Created by RJ  Kigner on 12/31/25.
//

import SwiftUI

struct UserIconShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.width
        let h = rect.height

        //MARK: head
        let headWidth = w * 0.22
        let headHeight = h * 0.32

        let headRect = CGRect(
            x: (w - headWidth) / 2,
            y: h * -0.02,
            width: headWidth,
            height: headHeight
        )

        path.addRoundedRect(
            in: headRect,
            cornerSize: CGSize(width: headWidth / 2, height: headWidth / 2)
        )

        //MARK: body
        
        let bodyRadius = w * 0.28
        let centerY = h * 0.72
        let center = CGPoint(x: w / 2, y: centerY)

        path.addArc(
            center: center,
            radius: bodyRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )

        path.addLine(
            to: CGPoint(
                x: w / 2 - bodyRadius,
                y: centerY
            )
        )

        return path
    }
}


import SwiftUI

struct UserIcon: View {
    var body: some View {
        UserIconShape()
            .stroke(
                style: StrokeStyle(
                    lineWidth: 1.5,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .frame(width: 30, height: 30)
    }
}


#Preview{
    UserIcon()

}
