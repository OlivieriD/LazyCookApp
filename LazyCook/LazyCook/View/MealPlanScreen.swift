import SwiftUI

struct MealPlanScreen: View {
    @ObservedObject var mealPlanVM: MealPlanViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(mealPlanVM.mealPlans.sorted(by: { $0.date < $1.date })) { plan in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(plan.date, format: .dateTime.month(.abbreviated).day())
                                .font(.caption)
                            Spacer()
                            Text(plan.time)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        HStack {
                            Text(plan.scheduledRecipe?.title ?? "No Recipe")
                                .font(.headline)
                            Spacer()
                            Text(plan.mealType)
                                .font(.subheadline)
                                .bold()
                                .padding(4)
                                .background(Color.green.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    }
                }
                .onDelete(perform: deleteMealPlan)
            }
            .navigationTitle("Meal Planner")
            .onAppear {
                mealPlanVM.fetchMealPlans()
            }
        }
    }
    
    private func deleteMealPlan(offsets: IndexSet) {
        for index in offsets {
            let plan = mealPlanVM.mealPlans[index]
            mealPlanVM.deleteMealPlan(plan: plan)
        }
    }
}
