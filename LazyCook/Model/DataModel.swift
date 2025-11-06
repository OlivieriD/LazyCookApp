import Foundation
import SwiftData

struct Ingredient: Codable, Identifiable {
    let id = UUID()
    var name: String
    var quantity: String
    var unit: String
}

@Model
final class Recipe {
    var title: String
    var instructions: String
    var servings: Int
    var ingredients: [Ingredient]
    var nutritionalInfo: String
    
    init(title: String = "", instructions: String = "", servings: Int = 1, ingredients: [Ingredient] = [], nutritionalInfo: String = "Not fetched") {
        self.title = title
        self.instructions = instructions
        self.servings = servings
        self.ingredients = ingredients
        self.nutritionalInfo = nutritionalInfo
    }
}

@Model
final class MealPlan {
    var date: Date
    var mealType: String
    var scheduledRecipe: Recipe?
    var time: String

    init(date: Date = Date(), mealType: String = "", scheduledRecipe: Recipe? = nil, time: String = "") {
        self.date = date
        self.mealType = mealType
        self.scheduledRecipe = scheduledRecipe
        self.time = time
    }
}
