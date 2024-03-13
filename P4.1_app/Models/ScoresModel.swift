import SwiftUI


@Observable class ScoresModel{

    var acertadas: Set<Int> = []
    var record: Set<Int> = []

    init(){
        let a = UserDefaults.standard.object(forKey: "record") as? [Int] ?? []  //sino devuelvo arrazy vacio
        record = Set(a)
    }

    func check(quizItem: QuizItem, answer: String){

//        if answer =+-= quizItem.answer{
//            acertadas.insert(quizItem.id)
//        }
    }

    func add(quizItem: QuizItem) {
        acertadas.insert(quizItem.id)
        record.insert(quizItem.id)

        UserDefaults.standard.set(Array(record), forKey: "record")
        UserDefaults.standard.synchronize()
    }

    func pendiente(_ quizItem: QuizItem) -> Bool{
        !acertadas.contains(quizItem.id)
    }

    func cleanup(){
        acertadas = []
    }


}
