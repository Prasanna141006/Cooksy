//
//  DirectionView.swift
//  Cooksyy
//
//  Created by Nxtwave on 25/09/25.
//

import SwiftUI
import Combine




struct DirectionStepRow: View {
    let stepNumber: Int
    let description: String
    let elapsedSeconds: Int
    let isRunning: Bool
    let toggleTimer: () -> Void


    private func timeString(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Step \(stepNumber)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)

            Text(description)
                .font(.body)
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 12) {
                Button(action: toggleTimer) {
                    Image(systemName: "timer")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(isRunning ? Color.orange.opacity(0.85) : Color.orange)
                        .clipShape(Circle())
                        .shadow(color: Color.orange.opacity(0.4), radius: 4, x: 0, y: 2)
                }
                if isRunning {
                    Text(timeString(elapsedSeconds))
                        .font(.footnote)
                        .foregroundColor(.orange)
                        .monospacedDigit()
                }
                Spacer()
            }
        }
    }

}

