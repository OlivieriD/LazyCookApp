import SwiftUI
import SwiftData

struct RecipeListScreen: View {
    @ObservedObject var recipeVM: RecipeViewModel
    @ObservedObject var mealPlanVM: MealPlanViewModel
    
    @State private var isShowingAddSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(recipeVM.recipes) { recipe in
                    NavigationLink(destination: RecipeDetailScreen(recipe: recipe, recipeVM: recipeVM, mealPlanVM: mealPlanVM)) {
                        VStack(alignment: .leading) {
                            Text(recipe.title)
                                .font(.headline)
                            Text("\(recipe.servings) servings")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteRecipes)
            }
            .navigationTitle("My Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddSheet = true
                    } label: {
                        Label("Add Recipe", systemImage: "plus.circle.fill")
                    }
                }
            }
            .onAppear {
                recipeVM.fetchRecipes()
            }
            .sheet(isPresented: $isShowingAddSheet) {
                AddEditRecipeScreen(vm: recipeVM, mode: .create)
            }
        }
    }
    
    private func deleteRecipes(offsets: IndexSet) {
        for index in offsets {
            let recipe = recipeVM.recipes[index]
            recipeVM.deleteRecipe(recipe: recipe)
        }
    }
}
