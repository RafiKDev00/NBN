//
//  MyDocuments.swift
//  NBN
//
//  Created by RJ  Kigner on 12/31/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct MyDocuments: View {
    @StateObject private var app = AppModel.shared
    @State private var openSection: Section? = nil
    @State private var showPicker = false
    @State private var uploadTarget: DocumentName?
    @State private var showSizeAlert = false
    
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
                                    VStack(alignment: .trailing, spacing: 6) {
                                        Text(doc.status == .received ? "Received" : "Missing")
                                            .font(.caption.weight(.semibold))
                                            .foregroundStyle(doc.status == .received ? NBNColors.alabaster : NBNColors.doveGray)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 10)
                                            .background(
                                                Capsule()
                                                    .fill(doc.status == .received ? NBNColors.bondiBlue : NBNColors.doveGray.opacity(0.2))
                                            )
                                        Button {
                                            if let target = DocumentName(rawValue: doc.name) {
                                                uploadTarget = target
                                                showPicker = true
                                            }
                                        } label: {
                                            HStack(spacing: 4) {
                                                Image(systemName: "square.and.arrow.up.circle")
                                                Text("Upload")
                                            }
                                        }
                                        .buttonStyle(.plain)
                                        .foregroundStyle(NBNColors.bondiBlue)
                                    }
                                }
                            }
                        }
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        openSection = openSection == .general ? nil : .general
                    }
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
                                    VStack(alignment: .trailing, spacing: 6) {
                                        Text(doc.status == .received ? "Received" : "Missing")
                                            .font(.caption.weight(.semibold))
                                            .foregroundStyle(doc.status == .received ? NBNColors.alabaster : NBNColors.doveGray)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 10)
                                            .background(
                                                Capsule()
                                                    .fill(doc.status == .received ? NBNColors.bondiBlue : NBNColors.doveGray.opacity(0.2))
                                            )
                                        Button {
                                            if let target = DocumentName(rawValue: doc.name) {
                                                uploadTarget = target
                                                showPicker = true
                                            }
                                        } label: {
                                            HStack(spacing: 4) {
                                                Image(systemName: "square.and.arrow.up.circle")
                                                Text("Upload")
                                            }
                                        }
                                        .buttonStyle(.plain)
                                        .foregroundStyle(NBNColors.bondiBlue)
                                    }
                                }
                            }
                        }
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        openSection = openSection == .personal ? nil : .personal
                    }
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .safeAreaBar(edge: .top){
            NBNHeader()
        }
        .sheet(isPresented: $showPicker) {
            DocumentPicker { url in
                if let target = uploadTarget {
                    if let fileSize = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize,
                       fileSize > 15 * 1024 * 1024 {
                        showSizeAlert = true
                    } else {
                        Task {
                            try? await app.uploadDocumentRemote(target, fileURL: url)
                            await app.loadProgress()
                        }
                    }
                }
                uploadTarget = nil
            } onCancel: {
                uploadTarget = nil
            }
        }
        .alert("File too large", isPresented: $showSizeAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please upload a file under 15 MB.")
        }
        
    }
}


#Preview {
    MyDocuments()
}

private struct DocumentPicker: UIViewControllerRepresentable {
    let onPick: (URL) -> Void
    let onCancel: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick, onCancel: onCancel)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.data], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onPick: (URL) -> Void
        let onCancel: () -> Void
        
        init(onPick: @escaping (URL) -> Void, onCancel: @escaping () -> Void) {
            self.onPick = onPick
            self.onCancel = onCancel
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            onPick(url)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            onCancel()
        }
    }
}
