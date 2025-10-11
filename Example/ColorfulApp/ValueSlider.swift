//
//  ValueSlider.swift
//  ColorfulApp
//
//  Created by qaq on 11/10/2025.
//

import SwiftUI

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
                .tint(.primary)
        }
    }
}
