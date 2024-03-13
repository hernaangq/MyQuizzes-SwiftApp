//
//  ContentView.swift
//  P4.1_app
//
//  Created by c052 DIT UPM on 16/11/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var quizzesModel = QuizzesModel()
    @State var scoresModel = ScoresModel()

    @State var errorMsg = "" {
        didSet{                                //cada vez que se cambie errorMsg ponemos a true el showErrorMsgAlert
            showErrorMsgAlert = true
        }
    }


    @State var showErrorMsgAlert = false
    @State var showAll = true
    
    var body: some View {
        NavigationStack{
            List {
                Toggle("Ver Todos", isOn: $showAll)   //switch para cambiar todos

                    ForEach(quizzesModel.quizzes) { quizItem in
                        if showAll || scoresModel.pendiente(quizItem){
                            NavigationLink{
                            QuizItemPlayView(quizItem: quizItem, scoresModel: scoresModel, quizzesModel: quizzesModel)
                        } label: {
                            QuizItemRowView(quizItem: quizItem)
                        }
                    }
                    }
            }
            .navigationTitle("P4 Quizzes")     //METER EN LA SEGUNDA
            .navigationBarItems(
                leading: Text("RECORD = \(scoresModel.record.count)"),
                trailing: Button(action: {                             //BOTON DE REINICIAR SCORE
                    Task{                                                      //igual que onAppear pero cancela las descargas si se cambia de pantalla
                        do {
                            try await quizzesModel.download()
                            scoresModel.cleanup()
                        } catch {
                            errorMsg = error.localizedDescription
                        }
                        }
                }, label: {
                    Label("Refrescar", systemImage: "arrow.counterclockwise")
                }
                )
            )



        }
        .alert("Error",
            isPresented: $showErrorMsgAlert,
            actions: {
            },
            message: {
                Text(errorMsg)
            }
        )
        .task {                                     //igual que onAppear pero cancela las descargas si se cambia de pantalla
            do {
               try await quizzesModel.download()
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }

}


infix operator =+-= : ComparisonPrecedence

extension String {

    static func =+-=(s1:String, s2:String) -> Bool{
        var a = s1.lowercased().trimmingCharacters(in: .whitespaces)
        var b = s2.lowercased().trimmingCharacters(in: .whitespaces)
        return a==b
    }
    
}

#Preview {
    ContentView()
}
