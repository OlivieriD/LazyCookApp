import Foundation
import SwiftData
import Combine

@MainActor
final class RecipeViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var error: Error?

    private let dataService: DataService
    private let nutritionAPI: NutritionAPI
    
    init(dataService: DataService, nutritionAPI: NutritionAPI) {
        self.dataService = dataService
        self.nutritionAPI = nutritionAPI
    }
    
    func fetchRecipes() {
        isLoading = true
        error = nil
        
        Task {
            do {
                recipes = try await dataService.fetchRecipes()
                isLoading = false
            } catch {
                self.error = error
                isLoading = false
            }
        }
    }
    
    func saveRecipe(recipe: Recipe) {
        Task {
            do {
                await dataService.insert(recipe)
                try await dataService.save()
                fetchRecipes()
            } catch {
                self.error = error
            }
        }
    }
    
    func updateRecipe(_ recipe: Recipe) {
        Task {
            do {
                try await dataService.save()
                fetchRecipes()
            } catch {
                self.error = error
            }
        }
    }
    
    func deleteRecipe(recipe: Recipe) {
        Task {
            do {
                await dataService.delete(recipe)
                try await dataService.save()
                fetchRecipes()
            } catch {
                self.error = error
            }
        }
    }
    
    func fetchNutrition(for recipe: Recipe) {
        Task {
            do {
                recipe.nutritionalInfo = "Fetching..."
                let info = try await nutritionAPI.fetchNutrition(for: recipe.ingredients)
                recipe.nutritionalInfo = info
                self.updateRecipe(recipe)
            } catch {
                recipe.nutritionalInfo = "Error fetching nutrition: \(error.localizedDescription)"
                self.error = error
            }
        }
    }
}
