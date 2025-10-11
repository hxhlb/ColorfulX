//
//  ControlSurface.swift
//  ColorfulApp
//
//  Created by qaq on 11/10/2025.
//

import ColorfulX
import SwiftUI

struct ControlSurface: View {
    @Binding var isExpanded: Bool
    let panelAnimation: Animation
    @Binding var preset: ColorfulPreset
    @Binding var speed: Double
    @Binding var bias: Double
    @Binding var noise: Double
    @Binding var duration: TimeInterval
    @Binding var scale: Double
    @Binding var frame: Int
    let isDarkExperience: Bool
    let toggleAppearance: () -> Void

    private var displayIndex: Int {
        (ColorfulPreset.allCases.firstIndex(of: preset) ?? 0) + 1
    }

    var body: some View {
        GlassPanel(cornerRadius: isExpanded ? 28 : 24, padding: isExpanded ? 24 : 18) {
            VStack(spacing: isExpanded ? 20 : 0) {
                header

                if isExpanded {
                    Divider()
                        .transition(.opacity)

                    ScrollView {
                        VStack(spacing: 20) {
                            PresetWheel(preset: $preset)
                            ValueSlider(title: "Speed", value: $speed, range: 0.0 ... 10.0, step: 0.1, format: "%.1f")
                            ValueSlider(title: "Bias", value: $bias, range: 0.00001 ... 0.01, step: 0.00001, format: "%.5f")
                            ValueSlider(title: "Noise", value: $noise, range: 0 ... 64, step: 1, format: "%.0f")
                            ValueSlider(title: "Transition", value: $duration, range: 0.0 ... 10.0, step: 0.1, format: "%.1f")
                            ValueSlider(title: "Scale", value: $scale, range: 0.001 ... 2.0, step: 0.001, format: "%.3f")
                            FramePickerControl(frame: $frame)
                        }
                        .padding(.vertical, 4)
                    }
                    .frame(maxHeight: 320)
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
                }
            }
            .frame(maxWidth: isExpanded ? 420 : 320)
        }
        .animation(panelAnimation, value: isExpanded)
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            Button {
                withAnimation(panelAnimation) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    Text(displayIndex, format: .number.precision(.integerLength(2)))
                        .font(.system(size: isExpanded ? 22 : 18, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText())

                    VStack(alignment: .leading, spacing: isExpanded ? 2 : 0) {
                        if isExpanded {
                            Text("Control Panel")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundStyle(.secondary)
                                .transition(.opacity)
                        }

                        Text(preset.hint)
                            .font(.system(size: isExpanded ? 20 : 16, weight: .semibold, design: .rounded))
                            .contentTransition(.opacity)
                    }

                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: isExpanded ? 18 : 16, weight: .semibold))
                        .symbolVariant(.fill)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.borderless)
            .tint(.primary)
            .accessibilityLabel(isExpanded ? "Collapse control panel" : "Expand control panel")

            Button(action: toggleAppearance) {
                Image(systemName: isDarkExperience ? "sun.max.fill" : "moon.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 44, height: 44)
                    .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.borderless)
            .tint(.primary)
            .accessibilityLabel(isDarkExperience ? "Switch to light experience" : "Switch to dark experience")

            if isExpanded {
                Button {
                    withAnimation(panelAnimation) {
                        isExpanded = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                }
                .buttonStyle(.borderless)
                .tint(.primary)
                .transition(.scale.combined(with: .opacity))
                .accessibilityLabel("Close control panel")
            }
        }
    }
}
