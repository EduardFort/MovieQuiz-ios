import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (oldValue: GameRecord, newValue: GameRecord) -> Bool {
        return oldValue.correct < newValue.correct
    }
    
    func record() -> String {
        return "\(correct)/\(total) (\(date.dateTimeString))"
    }
}
