//
//  GlassPanel.swift
//  ColorfulApp
//
//  Created by qaq on 11/10/2025.
//

import SwiftUI

struct GlassPanel<Content: View>: View {
    let cornerRadius: CGFloat
    let padding: CGFloat
    let content: Content

    init(cornerRadius: CGFloat = 24, padding: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: cornerRadius))
            .padding(.horizontal, 16)
    }
}
