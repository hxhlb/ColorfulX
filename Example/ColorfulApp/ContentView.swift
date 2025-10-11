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

    var body: some View {
        ZStack {
            backgroundGrid
            animatedGradient
            overlayContent
        }
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
        ControlSurface(
            preset: $preset,
            speed: $speed,
            bias: $bias,
            noise: $noise,
            duration: $duration,
            scale: $scale,
            frame: $frame
        )
    }
}
