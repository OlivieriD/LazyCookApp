import Foundation
import SwiftData
import Combine

@MainActor
final class MealPlanViewModel: ObservableObject {
    @Published var mealPlans: [MealPlan] = []
    @Published var error: Error?
    
    private let dataService: DataService
    
    init(dataService: DataService) {
        self.dataService = dataService
        fetchMealPlans()
    }
    
    func fetchMealPlans() {
        
        Task {
            do {
                mealPlans = try await dataService.fetchMealPlans().sorted { $0.date < $1.date }
            } catch {
                self.error = error
            }
        }
    }
    
    func saveMealPlan(recipe: Recipe, date: Date, time: String) {
        let newPlan = MealPlan(date: date, mealType: "Dinner", scheduledRecipe: recipe, time: time)
        Task {
            do {
                await dataService.insert(newPlan)
                try await dataService.save()
                fetchMealPlans()
            } catch {
                self.error = error
            }
        }
    }
    
    func deleteMealPlan(plan: MealPlan) {
        Task {
            do {
                await dataService.delete(plan)
                try await dataService.save()
                fetchMealPlans()
            } catch {
                self.error = error
            }
        }
    }
}
