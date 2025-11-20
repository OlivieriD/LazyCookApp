import SwiftUI

enum RecipeFormMode {
    case create
    case edit(Recipe)
    
    var title: String {
        switch self {
        case .create: "New Recipe"
        case .edit: "Edit Recipe"
        }
    }
}

struct AddEditRecipeScreen: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: RecipeViewModel
    var mode: RecipeFormMode
    
    @State private var title: String
    @State private var instructions: String
    @State private var servings: Int
    @State private var ingredients: [Ingredient]
    @State private var newIngredientName: String = ""
    @State private var newIngredientQuantity: String = ""
    @State private var newIngredientUnit: String = ""
    
    init(vm: RecipeViewModel, mode: RecipeFormMode) {
        self.vm = vm
        self.mode = mode
        
        switch mode {
        case .create:
            _title = State(initialValue: "")
            _instructions = State(initialValue: "")
            _servings = State(initialValue: 1)
            _ingredients = State(initialValue: [])
        case .edit(let recipe):
            _title = State(initialValue: recipe.title)
            _instructions = State(initialValue: recipe.instructions)
            _servings = State(initialValue: recipe.servings)
            _ingredients = State(initialValue: recipe.ingredients)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Recipe Details") {
                    TextField("Recipe Title", text: $title)
                    TextField("Instructions", text: $instructions, axis: .vertical)
                    Stepper("Servings: \(servings)", value: $servings, in: 1...20)
                }
                
                Section("Ingredients") {
                    ForEach(ingredients) { ingredient in
                        Text("\(ingredient.quantity) \(ingredient.unit) of \(ingredient.name)")
                    }
                    .onDelete(perform: deleteIngredients)
                    
                    HStack {
                        TextField("Qty", text: $newIngredientQuantity)
                            .frame(width: 50)
                            .keyboardType(.numbersAndPunctuation)
                        TextField("Unit", text: $newIngredientUnit)
                            .frame(width: 60)
                        TextField("Name", text: $newIngredientName)
                        
                        Button {
                            addIngredient()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(newIngredientName.isEmpty)
                    }
                }
            }
            .navigationTitle(mode.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveRecipe() }
                        .disabled(title.isEmpty || instructions.isEmpty || ingredients.isEmpty)
                }
            }
        }
    }
    
    private func addIngredient() {
        let newIngredient = Ingredient(
            name: newIngredientName,
            quantity: newIngredientQuantity,
            unit: newIngredientUnit
        )
        ingredients.append(newIngredient)
        newIngredientName = ""
        newIngredientQuantity = ""
        newIngredientUnit = ""
    }
    
    private func deleteIngredients(offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
    
    private func saveRecipe() {
        switch mode {
        case .create:
            let newRecipe = Recipe(
                title: title,
                instructions: instructions,
                servings: servings,
                ingredients: ingredients
            )
            vm.saveRecipe(recipe: newRecipe)
        case .edit(let recipe):
            recipe.title = title
            recipe.instructions = instructions
            recipe.servings = servings
            recipe.ingredients = ingredients
            vm.updateRecipe(recipe)
        }
        dismiss()
    }
}
