import Foundation

struct CheckResponseItem: Codable{
    let quizId: Int
    let answer: String
    let result: Bool
}
