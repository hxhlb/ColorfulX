//
//  ContentView.swift
//  ColorfulApp
//
//  Created by QAQ on 2023/12/1.
//

import ColorfulX
import SwiftUI

private let defaultPreset: ColorfulPreset = .aurora

struct ContentView: View {
    @AppStorage("preset") private var preset: ColorfulPreset = defaultPreset
    @AppStorage("speed") private var speed: Double = 1.0
    @AppStorage("bias") private var bias: Double = 0.01
    @AppStorage("noise") private var noise: Double = 1
    @AppStorage("duration") private var duration: TimeInterval = 3.5
    @AppStorage("scale") private var scale: Double = 1
    @AppStorage("frame") private var frame: Int = 60

    @State private var showSettings = false
    @State private var prefersDarkExperience = false
    @Namespace private var namespace

    var body: some View {
        ZStack {
            backgroundGrid
            animatedGradient
            overlayContent
        }
        .tint(.black)
        #if os(iOS)
            .sheet(isPresented: $showSettings) {
                SettingsSheet(
                    preset: $preset,
                    speed: $speed,
                    bias: $bias,
                    noise: $noise,
                    duration: $duration,
                    scale: $scale,
                    frame: $frame
                )
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
            .preferredColorScheme(prefersDarkExperience ? .dark : .light)
        #endif
    }

    private var backgroundGrid: some View {
        ChessboardView()
            .opacity(0.25)
            .ignoresSafeArea()
    }

    private var animatedGradient: some View {
        ColorfulView(
            color: $preset,
            speed: $speed,
            bias: $bias,
            noise: $noise,
            transitionSpeed: $duration,
            frameLimit: $frame,
            renderScale: $scale
        )
        .ignoresSafeArea()
    }

    @ViewBuilder
    private var overlayContent: some View {
        VStack(spacing: 24) {
            Spacer()
            platformControls
            SignatureView()
        }
        .padding()
    }

    @ViewBuilder
    private var platformControls: some View {
        #if os(iOS)
            FloatingControls(
                showSettings: $showSettings,
                preset: preset,
                isDarkExperience: prefersDarkExperience,
                toggleAppearance: toggleExperience,
                namespace: namespace
            )
        #elseif os(macOS)
            MacControlPanel(
                preset: $preset,
                speed: $speed,
                bias: $bias,
                noise: $noise,
                duration: $duration,
                scale: $scale,
                frame: $frame
            )
        #elseif os(tvOS)
            Button(action: randomizePreset) {
                Image(systemName: "wind")
            }
            .buttonStyle(.glass)
        #else
            EmptyView()
        #endif
    }

    private func randomizePreset() {
        guard let candidate = ColorfulPreset.allCases.randomElement() else { return }
        preset = candidate
    }

    private func toggleExperience() {
        withAnimation(.snappy(duration: 0.3, extraBounce: 0.2)) {
            prefersDarkExperience.toggle()
        }
    }
}

private struct SignatureView: View {
    var body: some View {
        Text("Made with love by @Lakr233")
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .glassEffect(.regular, in: .rect(cornerRadius: 12))
    }
}

private struct GlassCard<Content: View>: View {
    private let cornerRadius: CGFloat
    private let padding: CGFloat
    private let content: Content

    init(cornerRadius: CGFloat = 20, padding: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
    }
}

private struct PresetPalette: View {
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

struct ValueSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let format: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                Spacer()
                Text(String(format: format, value))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .monospacedDigit()
            }

            Slider(value: $value, in: range, step: step)
                .tint(.black)
        }
    }
}

struct FramePickerControl: View {
    @Binding var frame: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Frame Limit")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)

            Picker("", selection: $frame) {
                ForEach([0, 15, 30, 60, 120], id: \.self) { option in
                    Text(option == 0 ? "Unlimited" : "\(option) FPS").tag(option)
                }
            }
            .pickerStyle(.segmented)
            .tint(.black)
        }
    }
}

#if os(macOS)
    private struct MacControlPanel: View {
        @Binding var preset: ColorfulPreset
        @Binding var speed: Double
        @Binding var bias: Double
        @Binding var noise: Double
        @Binding var duration: TimeInterval
        @Binding var scale: Double
        @Binding var frame: Int

        var body: some View {
            GlassCard(cornerRadius: 16, padding: 24) {
                VStack(spacing: 16) {
                    MacPresetPicker(preset: $preset)
                    Divider()
                    ValueSlider(title: "Speed", value: $speed, range: 0.0 ... 10.0, step: 0.1, format: "%.1f")
                    Divider()
                    ValueSlider(title: "Bias", value: $bias, range: 0.00001 ... 0.01, step: 0.00001, format: "%.5f")
                    Divider()
                    ValueSlider(title: "Noise", value: $noise, range: 0 ... 64, step: 1, format: "%.0f")
                    Divider()
                    ValueSlider(title: "Transition", value: $duration, range: 0.0 ... 10.0, step: 0.1, format: "%.1f")
                    Divider()
                    ValueSlider(title: "Scale", value: $scale, range: 0.001 ... 2.0, step: 0.001, format: "%.3f")
                    Divider()
                    FramePickerControl(frame: $frame)
                }
                .frame(width: 360)
            }
        }
    }

    private struct MacPresetPicker: View {
        @Binding var preset: ColorfulPreset

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Preset")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Picker("", selection: $preset) {
                        ForEach(ColorfulPreset.allCases, id: \.self) { option in
                            Text(option.hint).tag(option)
                        }
                    }
                    .frame(width: 160)
                    .tint(.black)
                }

                PresetPalette(colors: preset.colors, circleSize: 28)
            }
        }
    }
#endif

#if os(iOS)
    private struct FloatingControls: View {
        @Binding var showSettings: Bool
        let preset: ColorfulPreset
        let isDarkExperience: Bool
        let toggleAppearance: () -> Void
        let namespace: Namespace.ID

        private var displayIndex: Int {
            (ColorfulPreset.allCases.firstIndex(of: preset) ?? 0) + 1
        }

        var body: some View {
            GlassEffectContainer(spacing: 20) {
                HStack(spacing: 16) {
                    Button {
                        showSettings = true
                    } label: {
                        HStack(spacing: 12) {
                            Text(displayIndex, format: .number.precision(.integerLength(2)))
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .monospacedDigit()
                                .contentTransition(.numericText())

                            Text(preset.hint)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .contentTransition(.opacity)

                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 16, weight: .semibold))
                                .symbolVariant(.fill)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                    .tint(.black)
                    .glassEffect(.regular.interactive())
                    .glassEffectID("settings", in: namespace)

                    Button(action: toggleAppearance) {
                        Image(systemName: isDarkExperience ? "sun.max.fill" : "moon.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(width: 44, height: 44)
                            .contentTransition(.symbolEffect(.replace))
                    }
                    .tint(.black)
                    .glassEffect(.regular.interactive())
                    .glassEffectID("appearance", in: namespace)
                    .accessibilityLabel(isDarkExperience ? "Switch to light experience" : "Switch to dark experience")
                }
            }
            .tint(.black)
        }
    }

    private struct PresetWheel: View {
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
                .tint(.black)
                .frame(height: 120)

                PresetPalette(colors: preset.colors, circleSize: 40)
            }
        }
    }

    struct SettingsSheet: View {
        @Binding var preset: ColorfulPreset
        @Binding var speed: Double
        @Binding var bias: Double
        @Binding var noise: Double
        @Binding var duration: TimeInterval
        @Binding var scale: Double
        @Binding var frame: Int

        @Environment(\.dismiss) private var dismiss

        var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        GlassCard {
                            PresetWheel(preset: $preset)
                        }
                        .padding(.horizontal, 16)

                        GlassCard {
                            VStack(spacing: 20) {
                                ValueSlider(title: "Speed", value: $speed, range: 0.0 ... 10.0, step: 0.1, format: "%.1f")
                                ValueSlider(title: "Bias", value: $bias, range: 0.00001 ... 0.01, step: 0.00001, format: "%.5f")
                                ValueSlider(title: "Noise", value: $noise, range: 0 ... 64, step: 1, format: "%.0f")
                                ValueSlider(title: "Transition", value: $duration, range: 0.0 ... 10.0, step: 0.1, format: "%.1f")
                                ValueSlider(title: "Scale", value: $scale, range: 0.001 ... 2.0, step: 0.001, format: "%.3f")
                            }
                        }
                        .padding(.horizontal, 16)

                        GlassCard {
                            FramePickerControl(frame: $frame)
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 24)
                }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done", action: dismiss.callAsFunction)
                            .buttonStyle(.glass)
                    }
                }
                .tint(.black)
            }
        }
    }
#endif
