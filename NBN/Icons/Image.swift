//
//  Image.swift
//  NBN
//
//  Created by RJ  Kigner on 12/31/25.
//
import SwiftUI

extension Image {
    static func fromView<V: View>(_ view: V, size: CGSize) -> Image {
        let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
        renderer.scale = UIScreen.main.scale

        if let uiImage = renderer.uiImage {
            return Image(uiImage: uiImage).renderingMode(.template)
        }

        return Image(systemName: "questionmark")
    }
}
