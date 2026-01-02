//
//  MyDocuments.swift
//  NBN
//
//  Created by RJ  Kigner on 12/31/25.
//

import SwiftUI

struct MyDocuments: View {
    @StateObject private var app = AppModel.shared
    @State private var openSection: Section? = nil
    
    enum Section {
        case general
        case personal
    }
    
    private var generalDocs: [Document] {
        app.applicant?.documents.filter {
            $0.name == "Waiver Of Confidentiality" || $0.name == "Photograph Of Family Member(s) Making Aliyah"
        } ?? []
    }
    
    private var personalDocs: [Document] {
        app.applicant?.documents.filter {
            $0.name != "Waiver Of Confidentiality" && $0.name != "Photograph Of Family Member(s) Making Aliyah"
        } ?? []
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 12){
                Instructions()
                
                HomeTextCard(height: openSection == .general ? nil : 80) {
                    HStack {
                        Text("General Documents")
                            .font(.title3.weight(.semibold))
                        Spacer()
                        Text("\(generalDocs.filter { $0.status == .received }.count) / \(generalDocs.count)")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(NBNColors.bondiBlue)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 8)
                            .overlay(
                                Capsule()
                                    .stroke(NBNColors.bondiBlue, lineWidth: 2)
                            )
                        Image(systemName: openSection == .general ? "chevron.up" : "chevron.down")
                            .foregroundStyle(NBNColors.doveGray)
                    }
                } content: {
                    if openSection == .general {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(generalDocs, id: \.name) { doc in
                            HStack {
                                Text(doc.name)
                                    .font(.subheadline.weight(.medium))
                                Spacer()
                                Text(doc.status == .received ? "Received" : "Missing")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(doc.status == .received ? NBNColors.alabaster : NBNColors.doveGray)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 10)
                                    .background(
                                        Capsule()
                                            .fill(doc.status == .received ? NBNColors.bondiBlue : NBNColors.doveGray.opacity(0.2))
                                    )
                            }
                        }
                    }
                    }
                }
                .onTapGesture {
                    openSection = openSection == .general ? nil : .general
                }
                
                HomeTextCard(height: openSection == .personal ? nil : 80) {
                    HStack {
                        Text("Personal Documents")
                            .font(.title3.weight(.semibold))
                        Spacer()
                        Text("\(personalDocs.filter { $0.status == .received }.count) / \(personalDocs.count)")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(NBNColors.bondiBlue)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 8)
                            .overlay(
                                Capsule()
                                    .stroke(NBNColors.bondiBlue, lineWidth: 2)
                            )
                        Image(systemName: openSection == .personal ? "chevron.up" : "chevron.down")
                            .foregroundStyle(NBNColors.doveGray)
                    }
                } content: {
                    if openSection == .personal {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(personalDocs, id: \.name) { doc in
                            HStack {
                                Text(doc.name)
                                    .font(.subheadline.weight(.medium))
                                Spacer()
                                Text(doc.status == .received ? "Received" : "Missing")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(doc.status == .received ? NBNColors.alabaster : NBNColors.doveGray)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 10)
                                    .background(
                                        Capsule()
                                            .fill(doc.status == .received ? NBNColors.bondiBlue : NBNColors.doveGray.opacity(0.2))
                                    )
                            }
                        }
                    }
                    }
                }
                .onTapGesture {
                    openSection = openSection == .personal ? nil : .personal
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .safeAreaBar(edge: .top){
            NBNHeader()
        }
        
    }
}


#Preview {
    MyDocuments()
}
