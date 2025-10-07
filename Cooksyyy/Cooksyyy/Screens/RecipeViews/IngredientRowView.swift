//
//  IngredientRowView.swift
//  Cooksyy
//
//  Created by Nxtwave on 25/09/25.
//

import SwiftUI
import Combine


struct IngredientRow: View {
    let ingredient: String
    let isChecked: Bool
    let toggleCheck: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: toggleCheck) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(isChecked ? Color.orange : Color.gray.opacity(0.7), lineWidth: 2)
                    .background(isChecked ? Color.orange.opacity(0.3) : Color.clear)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Group {
                            if isChecked {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.orange)
                            }
                        }
                    )
            }
            .buttonStyle(PlainButtonStyle())

            VStack(alignment: .leading, spacing: 2) {
                let (name, qty) = parseIngredient(ingredient)
                Text(name)
                    .font(.body)
                    .foregroundColor(.black)
                if let quantity = qty {
                    Text(quantity)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
    }

    private func parseIngredient(_ ingredient: String) -> (String, String?) {
        // Simple parse: split by comma or dash to separate quantity from name
        // Example: "1 cup sugar" or "Sugar - 1 cup"
        // We try to detect quantity as leading digits/units.

        // Try to split by ","
        if ingredient.contains(",") {
            let parts = ingredient.split(separator: ",", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 2 {
                return (parts[0], parts[1])
            }
        }
        // Try to split by " - "
        if ingredient.contains(" - ") {
            let parts = ingredient.split(separator: "-", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 2 {
                return (parts[0], parts[1])
            }
        }

        // Try to detect leading quantity
        let components = ingredient.split(separator: " ")
        if let first = components.first, first.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            // Leading quantity detected (like "1 cup sugar")
            let qty = components.prefix(2).joined(separator: " ")
            let name = components.dropFirst(2).joined(separator: " ")
            if !name.isEmpty {
                return (name, qty)
            }
        }

        return (ingredient, nil)
    }
}

