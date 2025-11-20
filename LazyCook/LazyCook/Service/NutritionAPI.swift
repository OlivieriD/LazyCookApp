import Foundation

struct NutritionResponse: Decodable {
    let calories: Double?
    let protein: Double?
    let fat: Double?
    let carbs: Double?
}

enum APIError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
}

actor NutritionAPI {
    private let baseURL = "https://api.mocknutritionservice.com"
    private let apiKey = "YOUR_MOCK_API_KEY"

    func fetchNutrition(for ingredients: [Ingredient]) async throws -> String {
        let query = ingredients.map { "\($0.quantity) \($0.unit) \($0.name)" }.joined(separator: ", ")
        
        guard var components = URLComponents(string: "\(baseURL)/nutrition") else {
            throw APIError.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            // Mocking a successful response for demonstration, as the external service is not real.
            // In a real app, you would decode the data:
            // let result = try JSONDecoder().decode(NutritionResponse.self, from: data)
            // let info = "Calories: \(result.calories ?? 0) kcal, Protein: \(result.protein ?? 0)g"
            
            // Placeholder Mock Data
            return "Total Calories: 540 kcal, Protein: 45g, Fat: 20g (Mock Data)"
        } catch {
            throw APIError.invalidData
        }
    }
}
