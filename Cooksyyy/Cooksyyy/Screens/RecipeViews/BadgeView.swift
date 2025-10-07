//
//  BadgeView.swift
//  Cooksyy
//
//  Created by Nxtwave on 25/09/25.
//

import SwiftUI

struct BadgeView: View {
    let iconName: String
    let text: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: iconName)
                .font(.system(size: 14))
                .foregroundColor(Color.orange.opacity(0.8))
            Text(text)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(.black)
        }
        .frame(width: 60)
        .padding(.vertical, 4)
        .padding(.horizontal, 10)
        .background(Color.orange.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

