import Foundation

struct Word: Identifiable, Equatable {
    let id = UUID().uuidString
    let term: String
    let pronunciation: String
    let partOfSpeech: String
    let definition: String
    let example: String
    let category: WordCategory
    var masteryLevel: MasteryLevel = .new

    // For loading mastery levels from UserDefaults
    mutating func loadSavedMasteryLevel() {
        self.masteryLevel = UserDefaultsManager.shared.getMasteryLevel(for: id)
    }

    // For saving mastery level to UserDefaults
    func saveMasteryLevel() {
        UserDefaultsManager.shared.saveMasteryLevel(for: id, level: masteryLevel)
    }
}
