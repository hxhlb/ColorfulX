//
//  AuroraGlowView.swift
//  AuroraGlow
//
//  Created by qaq on 13/10/2025.
//

import AppKit
import ColorfulX
import Foundation

class AuroraGlowView: NSView {
    override var isFlipped: Bool {
        true
    }

    let colorful: AnimatedMulticolorGradientView = {
        let director = SpeckleAnimationRoundedRectangleDirector(
            inset: -0.2,
            cornerRadius: 1,
            direction: .clockwise,
            movementRate: 0.1,
            positionResponseRate: 1,
        )
        #if os(macOS) && DEBUG
            director.debugVisualizationEnabled = true
        #endif
        let view = AnimatedMulticolorGradientView(
            animationDirector: director,
        )
        view.setColors(.appleIntelligence, animated: false, repeats: true)
        view.speed *= 2
        view.noise = 0
        view.bias /= 500_000
        return view
    }()

    init() {
        super.init(frame: .zero)

        addSubview(colorful)
        colorful.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorful.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorful.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorful.widthAnchor.constraint(equalToConstant: 200),
            colorful.heightAnchor.constraint(equalToConstant: 64),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }
}
