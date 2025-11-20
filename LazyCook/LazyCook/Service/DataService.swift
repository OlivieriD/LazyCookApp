import Foundation
import SwiftData

actor DataService {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func save() throws {
        try modelContext.save()
    }
    
    func fetchRecipes(predicate: Predicate<Recipe>? = nil) throws -> [Recipe] {
        let descriptor = FetchDescriptor<Recipe>(predicate: predicate)
        return try modelContext.fetch(descriptor)
    }
    
    func insert<T: PersistentModel>(_ model: T) {
        modelContext.insert(model)
    }
    
    func delete<T: PersistentModel>(_ model: T) {
        modelContext.delete(model)
    }
    
    func fetchMealPlans() throws -> [MealPlan] {
        let descriptor = FetchDescriptor<MealPlan>()
        return try modelContext.fetch(descriptor)
    }
}
