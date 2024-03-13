

import SwiftUI

let urlBase = "https://quiz.dit.upm.es"

let token = "89c7f639828e4db2d99a"

struct Endpoints {

    static func random10() -> URL? {                    //funcion que pide 10 quizzes random
        let path = "/api/quizzes/random10"
        let str = "\(urlBase)\(path)?token=\(token)"
        return URL(string: str)
    }

    static func checkAnswer(quizItem: QuizItem, answer: String) -> URL? {                    //funcion que comprueba las respuestas
        let path = "/api/quizzes/\(quizItem.id)/check"
        guard let answer_corregida = answer.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)           //corrijo la respuesta para no meter caracteres raros en la url
        else {return nil}
        let str = "\(urlBase)\(path)?answer=\(answer_corregida)&token=\(token)"
        return URL(string: str)
    }

    static func toggleFav(quizItem: QuizItem) -> URL? {
        let path = "/api/users/tokenOwner/favourites/\(quizItem.id)"
        let str = "\(urlBase)\(path)?token=\(token)"
        return URL(string: str)
    }

    
    static func getAnswer(quizItem: QuizItem) -> URL? {
            let path = "/api/quizzes/\(quizItem.id)/answer"
            let str = "\(urlBase)\(path)?token=\(token)"
            return URL(string: str)
    }
}
