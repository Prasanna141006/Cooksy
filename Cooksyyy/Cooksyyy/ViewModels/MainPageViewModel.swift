//
//  MainPageViewModel.swift
//  Cooksyy
//
//  Created by Nxtwave on 03/09/25.
//

import Foundation
import Combine

class MainPageViewModel : ObservableObject {


    @Published var recipes: [Recipe] = []


    func getrecipe() {
        Task {
            do {
                recipes = try await NetworkManager.shared.fetchrecipes()

            } catch {
              print("Failed to fetch recipes: \(error)")
            }
        }
    }

    

}

