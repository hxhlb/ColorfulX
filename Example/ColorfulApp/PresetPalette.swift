//
//  PresetPalette.swift
//  ColorfulApp
//
//  Created by qaq on 11/10/2025.
//

import ColorfulX
import SwiftUI

struct PresetPalette: View {
    let colors: [ColorElement]
    let circleSize: CGFloat

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(colors, id: \.self) { color in
                    Circle()
                        .fill(Color(color))
                        .frame(width: circleSize, height: circleSize)
                        .overlay(
                            Circle()
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 4)
        }
    }
}
