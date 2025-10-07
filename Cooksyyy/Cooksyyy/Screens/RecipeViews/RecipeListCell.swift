//
//  RecipeListCell.swift
//  Cooksyy
//
//  Created by Nxtwave on 03/09/25.
//

import SwiftUI

struct RecipeListCell: View {
    var recipe : Recipe
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: recipe.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 80)
                        .clipped()
                        .cornerRadius(8)
                } placeholder: {
                    Image("food-placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 80)
                        .clipped()
                        .cornerRadius(8)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text(recipe.name)
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    // Add additional details if needed here
                }
                Spacer(minLength: 12)
            }
            .padding(14)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
    }
}
#Preview {
    RecipeListCell(recipe: Recipe(
        id: 1,
        name: "Sample Dish",
        ingredients: ["Rice", "Salt", "Tomato"],
        instructions: ["Boil rice", "Add salt", "Serve with tomato"],
        prepTimeMinutes: 10,
        cookTimeMinutes: 20,
        servings: 2,
        difficulty: .easy,
        cuisine: "Indian",
        caloriesPerServing: 120,
        tags: ["vegan"],
        userID: 0,
        image: "https://picsum.photos/300",
        rating: 4.7,
        reviewCount: 150,
        mealType: ["Lunch"]
    ))
}
