import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Inject services into ViewModels
    @StateObject private var recipeVM: RecipeViewModel
    @StateObject private var mealPlanVM: MealPlanViewModel
    
    init(modelContext: ModelContext) {
        // Use the SAME modelContext throughout the app
        let dataService = DataService(modelContext: modelContext)
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
