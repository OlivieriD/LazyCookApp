import SwiftUI
import SwiftData

@main
struct LazyCookApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Recipe.self, MealPlan.self])
    }
}
