//
//  QuizzesModel.swift
//  P4.1 Quiz
//
//  Created by Santiago Pavón Gómez on 11/9/23.
//

import Foundation

@Observable class QuizzesModel {
    
    // Los datos
    private(set) var quizzes = [QuizItem]()
    
    func download() async throws {
            guard let url = Endpoints.random10() else {
                throw "Internal error: No puedo hacer el fetch"                    //fallo en la construccion de la URL
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else {        //casteo de URLResponse a HTTPURLResponse para poder comprobar el statusCode
                throw "Fallo en la devolución de datos"
            }

            // print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
            
            guard let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data)  else {
                throw "Error: recibidos datos corruptos."
            }
            
            self.quizzes = quizzes
            
            print("Quizzes cargados")
        
    }




    func check(quizItem: QuizItem, answer: String) async throws -> Bool {   // Comprueba

            guard let url = Endpoints.checkAnswer(quizItem: quizItem, answer: answer) else {
                throw "No puedo comprobar la respuesta"
            }

            let (data, response) = try await URLSession.shared.data(from: url) // Uso la conexion shared (por defecto)

        guard (response as? HTTPURLResponse)?.statusCode == 200  else {  // Guard: es como un if (asegurate de que)
                throw "Respuesta HTTP inesperada"
            }
            
            // print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
            
            guard let res = try? JSONDecoder().decode(CheckResponseItem.self, from: data)  else {
                throw "Datos recibidos corruptos."
            }

        return res.result
        
    }


    func toggleFavourite(quizItem: QuizItem) async throws {

        guard let url = Endpoints.toggleFav(quizItem: quizItem) else {
                throw "No puedo hacer favorito"
            }

        var request = URLRequest(url: url)
            request.httpMethod = quizItem.favourite ?  "DELETE" : "PUT"

            let (data, response) = try await URLSession.shared.data(for: request) // Ojo con for y no from. No queremos un GET queremos un PUT o DELETE

            guard (response as? HTTPURLResponse)?.statusCode == 200  else {  // Guard: es como un if (asegurate de que)
                throw "Respuesta HTTP inesperada (posible error en la peticion)"
            }
            
            // print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
            
            guard let res = try? JSONDecoder().decode(FavouriteStatusItem.self, from: data)  else {
                throw "Datos recibidos corruptos."
            }

            guard let index = quizzes.firstIndex(where:{qi in
                qi.id == quizItem.id
            })  else {
                throw "ufffff"
            }
        
            quizzes[index].favourite = res.favourite

    }

    
    
    func getAnswer(quizItem: QuizItem) async throws -> String {   // Comprueba

            guard let url = Endpoints.getAnswer(quizItem: quizItem) else {
                throw "No puedo comprobar la respuesta"
            }

            let (data, response) = try await URLSession.shared.data(from: url) // Uso la conexion shared (por defecto)

            guard (response as? HTTPURLResponse)?.statusCode == 200  else {  // Guard: es como un if (asegurate de que)
                    throw "Respuesta HTTP inesperada"
                }
                
                // print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
                
                guard let res = try? JSONDecoder().decode(AnswerItem.self, from: data)  else {
                    throw "Datos recibidos corruptos."
                }

            return res.answer
            
        }

}












extension String : Error{
    public var errorDescription : String? {
        return self
    }
}
