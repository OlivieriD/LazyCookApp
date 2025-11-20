import SwiftUI

struct RecipeDetailScreen: View {
    @State var recipe: Recipe
    @ObservedObject var recipeVM: RecipeViewModel
    @ObservedObject var mealPlanVM: MealPlanViewModel

    @State private var isShowingEditSheet = false
    @State private var isShowingPlannerSheet = false
    
    var body: some View {
        List {
            Section("Instructions") {
                Text(recipe.instructions)
            }
            
            Section("Ingredients (\(recipe.servings) Servings)") {
                ForEach(recipe.ingredients) { ingredient in
                    Text("\(ingredient.quantity) \(ingredient.unit) of \(ingredient.name)")
                }
            }
            
            Section("Nutritional Information") {
                VStack(alignment: .leading) {
                    Text(recipe.nutritionalInfo)
                        .font(.callout)
                    
                    if recipe.nutritionalInfo.contains("Fetching...") || recipe.nutritionalInfo.contains("Error") || recipe.nutritionalInfo.contains("Not fetched") {
                        Button("Fetch Nutrition") {
                            recipeVM.fetchNutrition(for: recipe)
                        }
                        .disabled(recipe.nutritionalInfo.contains("Fetching..."))
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            
            Section("Actions") {
                Button("Plan Meal") {
                    isShowingPlannerSheet = true
                }
                
                Button("Edit Recipe") {
                    isShowingEditSheet = true
                }
            }
        }
        .navigationTitle(recipe.title)
        .sheet(isPresented: $isShowingEditSheet) {
            AddEditRecipeScreen(vm: recipeVM, mode: .edit(recipe))
        }
        .sheet(isPresented: $isShowingPlannerSheet) {
            MealPlannerSheet(recipe: recipe, mealPlanVM: mealPlanVM)
        }
    }
}

struct MealPlannerSheet: View {
    @Environment(\.dismiss) var dismiss
    let recipe: Recipe
    @ObservedObject var mealPlanVM: MealPlanViewModel

    @State private var selectedDate = Date()
    @State private var selectedTime = "Dinner"
    let times = ["Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Schedule \(recipe.title)") {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    Picker("Time Slot", selection: $selectedTime) {
                        ForEach(times, id: \.self) { time in
                            Text(time)
                        }
                    }
                }
            }
            .navigationTitle("Plan Meal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Schedule") {
                        mealPlanVM.saveMealPlan(recipe: recipe, date: selectedDate, time: selectedTime)
                        dismiss()
                    }
                }
            }
        }
    }
}
