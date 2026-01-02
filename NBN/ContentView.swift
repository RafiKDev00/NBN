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
    @State private var tabSelection = 1
    private let documentsTabIconSize: CGFloat = 32
    private let homeTabIconSize: CGFloat = 80
    private let flightTabIconSize: CGFloat = 32
    
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
                                        size: CGSize(width: documentsTabIconSize, height: documentsTabIconSize)
                                    )
                                }
                            }
                            .tag(0)
                        Home(onSelectFlight: { tabSelection = 2 }, onSelectDocuments: { tabSelection = 0 })
                            .tabItem {
                                Label {
                                    Text("Home")
                                } icon: {
                                    tabIcon(named: "IconUser", size: homeTabIconSize)
                                }
                            }
                            .tag(1)

                        FlightReservation()
                            .tabItem{
                                Label {
                                    Text("Flights")
                                } icon: {
                                    tabIcon(named: "IconFlight", size: flightTabIconSize)
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

private func tabIcon(named: String, size: CGFloat) -> Image {
    Image.fromView(
        Image(named)
            .renderingMode(.template)
            .resizable()
            .scaledToFit(),
        size: CGSize(width: size, height: size)
    )
    .renderingMode(.template)
}
#Preview {
    ContentView()
}
