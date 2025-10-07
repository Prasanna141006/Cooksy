//
//  MainPage.swift
//  Cooksyy
//
//  Created by Nxtwave on 03/09/25.
//

import SwiftUI

struct MainPage: View {
    @StateObject var viewModel = MainPageViewModel()
    @State private var searchText: String = ""
    @State private var selectedCuisine: String? = nil

    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return viewModel.recipes
        } else {
            return viewModel.recipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var uniqueCuisines: [String] {
        Array(Set(viewModel.recipes.map { $0.cuisine })).sorted()
    }
    
    var displayedRecipes: [Recipe] {
        let cuisineFiltered = (selectedCuisine != nil) ? viewModel.recipes.filter { $0.cuisine == selectedCuisine } : viewModel.recipes
        if searchText.isEmpty {
            return cuisineFiltered
        } else {
            return cuisineFiltered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
               ContainerRelativeShape()
                    .fill(Color.black.opacity(0.95))
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 8) {

                    Text("📋 Flavour Board!")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                        .padding(.top, 10)
                        .padding(.leading, 14)
                        .shadow(color: .yellow.opacity(0.3), radius: 1, x: 0, y: 2)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            Button(action: { selectedCuisine = nil }) {
                                Text("All")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .foregroundColor(selectedCuisine == nil ? .white : .orange)
                                    .background(selectedCuisine == nil ? Color.orange : Color.orange.opacity(0.15))
                                    .clipShape(Capsule())
                            }
                            ForEach(uniqueCuisines, id: \.self) { cuisine in
                                Button(action: { selectedCuisine = cuisine }) {
                                    Text(cuisine)
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .foregroundColor(selectedCuisine == cuisine ? .white : .orange)
                                        .background(selectedCuisine == cuisine ? Color.orange : Color.orange.opacity(0.15))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                    }
                    
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 18), count: 3), spacing: 24) {
                            ForEach(displayedRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    VStack(spacing: 10) {
                                        AsyncImage(url: URL(string: recipe.image)) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 90, height: 90)
                                                .clipShape(Circle())
                                        } placeholder: {
                                            Circle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 90, height: 90)
                                                .overlay(
                                                    Image(systemName: "photo")
                                                        .imageScale(.large)
                                                        .foregroundStyle(.gray.opacity(0.7))
                                                )
                                        }
                                        Text(recipe.name)
                                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                                            .foregroundColor(.orange)
                                            .opacity(0.85)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .frame(maxWidth: 100)
                                    }
                                }
                            }
                        }


                    }
                   

                }
            }

//            .searchable(text: $searchText, placement: .navigationBarDrawer)
//                .padding(.horizontal, 12)
//                .padding(.top, 8)
            .task {
                viewModel.getrecipe()
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Cooksyy")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                }
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.crop.circle.fill")
                            .frame(width: 80, height: 80)
                    }
                }

            }

        }
    }
}


#Preview {
    MainPage()
}
