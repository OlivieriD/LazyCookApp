import SwiftUI
import SwiftData

@main
struct LazyCookApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: sharedModelContainer.mainContext)
                .modelContainer(sharedModelContainer)
        }
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Recipe.self,
            MealPlan.self,
            Ingredient.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
