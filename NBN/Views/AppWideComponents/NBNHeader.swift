//
//  NBNHeader.swift
//  NBN
//
//  Created by RJ  Kigner on 1/2/26.
//

import SwiftUI

struct NBNHeader: View {
    var body: some View {
        HStack(alignment: .center){
            Image("NBN_txtonly_Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 50)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
        .background(
            NBNColors.alabaster
                .shadow(color: NBNColors.bondiBlue.opacity(0.3), radius: 4, y: 4)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    NBNHeader()
}
