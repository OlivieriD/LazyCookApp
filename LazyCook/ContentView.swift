import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Inject services into ViewModels
    @StateObject private var recipeVM: RecipeViewModel
    @StateObject private var mealPlanVM: MealPlanViewModel
    
    init() {
        // Must initialize the services before the ViewModels
        let dataService = DataService(modelContext: try! ModelContext(.init(for: Recipe.self, MealPlan.self)))
        let nutritionAPI = NutritionAPI()
        
        // Initialize ViewModels with their dependencies
        _recipeVM = StateObject(wrappedValue: RecipeViewModel(dataService: dataService, nutritionAPI: nutritionAPI))
        _mealPlanVM = StateObject(wrappedValue: MealPlanViewModel(dataService: dataService))
    }
    
    var body: some View {
        TabView {
            RecipeListScreen(recipeVM: recipeVM, mealPlanVM: mealPlanVM)
                .tabItem {
                    Label("Recipes", systemImage: "fork.knife.circle.fill")
                }
            
            MealPlanScreen(mealPlanVM: mealPlanVM)
                .tabItem {
                    Label("Planner", systemImage: "calendar")
                }
        }
    }
}
