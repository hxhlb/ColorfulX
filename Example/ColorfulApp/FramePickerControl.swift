//
//  FramePickerControl.swift
//  ColorfulApp
//
//  Created by qaq on 11/10/2025.
//

import SwiftUI

struct FramePickerControl: View {
    @Binding var frame: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Frame Limit")
                .font(.body.bold())

            Picker("", selection: $frame) {
                ForEach([0, 15, 30, 60, 120], id: \.self) { option in
                    Text(option == 0 ? "MAX" : "\(option) FPS")
                        .font(.footnote)
                        .fontDesign(.monospaced)
                        .tag(option)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}
