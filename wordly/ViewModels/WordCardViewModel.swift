import Foundation
import SwiftUI

final class WordCardViewModel: ObservableObject, Identifiable {
    @Published var words: [Word]
    @Published var dailyGoal: Int = 5
    
    init(words: [Word] = []) {
        self.words = words
    }
    
    func loadWordsForCategories(_ categories: [WordCategory]) {
        self.words = CategoryWordSets.getWordsForCategories(categories)
    }
}
