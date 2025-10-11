//
//  ControlSurface.swift
//  ColorfulApp
//
//  Created by qaq on 11/10/2025.
//

import ColorfulX
import SwiftUI

struct ControlSurface: View {
    @State var isExpanded: Bool = false
    @State var isExpandedContent: Bool = false

    let panelAnimation: Animation = .spring
    @Binding var preset: ColorfulPreset
    @Binding var speed: Double
    @Binding var bias: Double
    @Binding var noise: Double
    @Binding var duration: TimeInterval
    @Binding var scale: Double
    @Binding var frame: Int

    var body: some View {
        ZStack {
            if isExpandedContent {
                controls
                    .transition(.opacity)
            } else {
                Image(systemName: "slider.horizontal.3")
                    .font(.body.bold())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture { isExpanded.toggle() }
                    .transition(.opacity)
                    .frame(width: 44, height: 44)
            }
        }
        .contentShape(Rectangle())
        .clipped()
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
        .animation(panelAnimation, value: isExpanded)
        .onReceive(NotificationCenter.default.publisher(for: .closeControls)) { _ in
            isExpanded = false
        }
        .onChange(of: isExpanded) { _, newValue in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation(.spring) {
                    isExpandedContent = newValue
                }
            }
        }
    }

    var controls: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                PresetPickerView(preset: $preset)

                Divider()

                ValueSliderView(title: "Speed", value: $speed, range: 0.0 ... 10.0, step: 0.1, format: "%.1f")
                ValueSliderView(title: "Bias", value: $bias, range: 0.00001 ... 0.01, step: 0.00001, format: "%.5f")
                ValueSliderView(title: "Noise", value: $noise, range: 0 ... 64, step: 1, format: "%.0f")
                ValueSliderView(title: "Transition", value: $duration, range: 0.0 ... 10.0, step: 0.1, format: "%.1f")
                ValueSliderView(title: "Scale", value: $scale, range: 0.001 ... 2.0, step: 0.001, format: "%.3f")
                FramePickerControl(frame: $frame)

                Divider()

                Button {
                    isExpanded.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.bold())
                }
                .buttonStyle(.plain)
            }
            .padding(16)
            .frame(width: 350)
        }
        .frame(maxHeight: 320)
        .frame(width: 350)
    }
}
