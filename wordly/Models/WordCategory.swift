import Foundation

enum WordCategory: String, CaseIterable, Identifiable {
    case science = "Science"
    case business = "Business"
    case arts = "Arts"
    case technology = "Technology"
    case academic = "Academic"
    case everyday = "Everyday"

    var id: String { self.rawValue }

    static var allCases: [WordCategory] {
        return [.science, .business, .arts, .technology, .academic, .everyday]
    }
}
