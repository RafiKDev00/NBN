//
//  ContentView.swift
//  NBN
//
//  Created by RJ  Kigner on 12/31/25.
//
//
//  ContentView.swift
//  NBN
//
//  Created by RJ  Kigner on 12/31/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var isShowingSplash = true
    @StateObject private var appModel = AppModel.shared
    @State private var tabSelection = 0
    
    var body: some View {
        ZStack {
            if isShowingSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                if let applicant = appModel.applicant {
                    TabView(selection: $tabSelection){
                        MyDocuments()
                            .tabItem {
                                Label {
                                    Text("Documents")
                                } icon: {
                                    Image.fromView(
                                        DocumentsIcon(),
                                        size: CGSize(width: 40, height: 40)
                                    )
                                }
                            }
                            .tag(0)
                        Home(onSelectFlight: { tabSelection = 2 })
                            .tabItem {
                                Label {
                                    Text("Home")
                                } icon: {
                                    Image("IconUser")
                                        .renderingMode(.template)
                                }
                            }
                            .tag(1)

                        FlightReservation()
                            .tabItem{
                                Label {
                                    Text("Flight")
                                } icon: {
                                    Image("IconFlight")
                                        .renderingMode(.template)
                                }
                            }
                            .tag(2)
                    }
                } else {
                    AuthView { newApplicant in
                        appModel.setApplicant(newApplicant)
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    isShowingSplash = false
                }
            }
        }
    }
}

struct SplashView: View {
    @State private var opacity: Double = 0
    @State private var offset: CGFloat = -100
    
    var body: some View {
        ZStack {
            Color.white // Change to match your brand color if needed
                .ignoresSafeArea()
            
            Image("NBN-Logo")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.6)
                .opacity(opacity)
                .offset(x: offset)
        }
        .onAppear {
            // Slide in from left with fade
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                opacity = 1.0
                offset = 0
            }
        }
    }
}

#Preview {
    ContentView()
}
