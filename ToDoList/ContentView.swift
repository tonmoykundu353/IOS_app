import SwiftUI

struct ContentView: View {
    @State private var tasksByDay: [String: [Task]] = [:]
    @State private var selectedDay: String = "2024-12-01"

    var body: some View {
        VStack {
            // List of days in December
            List(tasksByDay.keys.sorted(), id: \.self) { day in
                Button(action: {
                    selectedDay = day
                }) {
                    Text(day)
                        .padding()
                        .background(selectedDay == day ? Color.blue : Color.clear)
                        .cornerRadius(8)
                        .foregroundColor(.black)
                }
            }
            .padding()

            // Display tasks for the selected day
            if let tasks = tasksByDay[selectedDay] {
                List(tasks) { task in
                    VStack(alignment: .leading) {
                        Text(task.title)
                            .font(.headline)
                        Text("Priority: \(task.priority)")
                            .font(.subheadline)
                        Text("Status: \(task.status)")
                            .font(.subheadline)
                    }
                    .padding()
                    .background(self.taskBackgroundColor(for: task.status)) // Change background based on status
                    .cornerRadius(8)
                    .padding(.bottom, 5)
                }
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    // Function to load the tasks from the JSON file
    func loadData() {
        guard let path = Bundle.main.path(forResource: "tasks", ofType: "json") else {
            print("tasks.json not found.")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let monthData = try JSONDecoder().decode(MonthData.self, from: data)
            tasksByDay = monthData.days
        } catch {
            print("Error loading data: \(error)")
        }
    }
    
    // Function to return background color based on task status
    func taskBackgroundColor(for status: String) -> Color {
        switch status.lowercased() {
        case "completed":
            return Color.green.opacity(0.3) // Completed tasks with green background
        case "in progress":
            return Color.yellow.opacity(0.3) // In progress tasks with yellow background
        case "incomplete":
            return Color.red.opacity(0.3) // Pending tasks with red background
        default:
            return Color.clear // Default background if status is unknown
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
