import Foundation

// Task model to represent each task
struct Task: Identifiable, Codable {
    var id: Int
    var title: String
    var priority: String
    var status: String
}

// Model to represent the entire month
struct MonthData: Codable {
    var month: String
    var year: Int
    var days: [String: [Task]]
}

