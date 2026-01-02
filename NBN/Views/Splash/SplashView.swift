//
//  SplashView.swift
//  NBN
//
//  Created by RJ  Kigner on 1/2/26.
//

import SwiftUI

/*
 Better with the tagline, without the tagline, just the tagline moving in?
 */

struct SplashView: View {
    @State private var opacity: Double = 0
    @State private var offset: CGFloat = -100

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack {
                Image("NBN_txtonly_Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.6)

                Text("ALIYAH: IT'S YOUR MOVE")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.elAlHaiti)
                
            }
            .offset(x: offset)
            .opacity(opacity)
        
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                opacity = 1.0
                offset = 0
            }
        }
    }
}

#Preview {
    SplashDemoView()
}

/// Simple demo view to replay the splash animation.
private struct SplashDemoView: View {
    @State private var reloadToken = UUID()

    var body: some View {
        VStack {
            SplashView()
                .id(reloadToken)
            Button("Replay") {
                reloadToken = UUID()
            }
            .padding(.top, 20)
        }
    }
}
