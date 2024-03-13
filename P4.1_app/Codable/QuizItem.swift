//
//  QuizItem.swift
//  P4.1 Quiz
//
//  Created by Santiago Pavón Gómez on 11/9/23.
//

import Foundation

struct QuizItem: Codable, Identifiable {
    let id: Int
    let question: String

    let author: Author?                      //si tiene ? es que igual no todos los items la tienen
    let attachment: Attachment?
    var favourite: Bool                    //VARIABLE LA PODEMOS CAMBIAR
    
    struct Author: Codable {
        let isAdmin: Bool?
        let username: String?
        let profileName: String?
        let photo: Attachment?
    }
    
    struct Attachment: Codable {
        let filename: String?
        let mime: String?
        let url: URL?
    }
}
