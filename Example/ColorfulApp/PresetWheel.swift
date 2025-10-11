//
//  PresetWheel.swift
//  ColorfulApp
//
//  Created by qaq on 11/10/2025.
//

import ColorfulX
import SwiftUI

struct PresetWheel: View {
    @Binding var preset: ColorfulPreset

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preset")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)

            Picker("", selection: $preset) {
                ForEach(ColorfulPreset.allCases, id: \.self) { option in
                    Text(option.hint).tag(option)
                }
            }
            .pickerStyle(.wheel)
            .tint(.primary)
            .frame(height: 120)

            PresetPalette(colors: preset.colors, circleSize: 40)
        }
    }
}
