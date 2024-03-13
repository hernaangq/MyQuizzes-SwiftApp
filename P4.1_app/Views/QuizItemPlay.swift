
//
//  QuizItemPlay.swift
//  P4.1_app
//
//  Created by c052 DIT UPM on 16/11/23.
//

import SwiftUI

struct QuizItemPlayView: View {

    var quizItem: QuizItem
    
    @State var answer: String = ""
    @State var show_alert: Bool = false
    @State var show_puntos: Bool = false

    @State var errorMsg = "" {
        didSet{                                //cada vez que se cambie errorMsg ponemos a true el showErrorMsgAlert
            show_alert = true
        }
    }

    @State var checkingResponse = false
    @State var answerIsOk = false

    @Environment(\.horizontalSizeClass) var hsc
    @Environment(\.verticalSizeClass) var vsc
    
    var scoresModel: ScoresModel
    var quizzesModel: QuizzesModel

    var body: some View {
        if hsc == .compact && vsc == .regular{
            VStack{
                Spacer().frame(height: 30)
                HStack{
                    Spacer().frame(width: 15)
                    pregunta
                    estrella
                    Spacer().frame(width: 15)
                }
                Spacer().frame(height: 30)
                field
                Spacer().frame(height: 30)
                
                HStack{
                    Spacer().frame(width: 15)
                    foto
                    Spacer().frame(width: 15)
                }
                Spacer().frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                HStack{
                    Spacer(minLength: 2)
                    puntos
                    Spacer()
                    perfil
                    Spacer().frame(width: 15)
                }
                
            }.navigationTitle("PLAY")
        }else{
            VStack{
                HStack{
                    pregunta
                    estrella
                }
                HStack{
                    VStack{
                        field
                        puntos
                        perfil
                    }
                    foto
                }
            }.navigationTitle("PLAY")
        }
            
    }
    
    private var puntos: some View{

            Text("\(scoresModel.acertadas.count)")
                .fontWeight(.bold)
                .font(.title)
                .opacity(show_puntos ? 0 : 1)

    }


    private var field: some View{
        VStack{
            TextField("Introduzca su respuesta", text:$answer)
                .font(.title)
                .multilineTextAlignment(.center)
                .onSubmit {
                    Task {
                        await checkResponse()
                    }


                }
            if checkingResponse {
                ProgressView()                                  // simbolo de carga en el boton mientras se comprueba la respuesta en el server
            } else {
                Button("Comprobar"){
                Task {
                        await checkResponse()
                    }
                }
            }
        }.alert("Resultado", isPresented: $show_alert){
            
        }message: {
            //Text(self.quizItem.answer =+-= answer ? "RESPUESTA CORRECTA, ¡MUY BIEN!" : "RESPUESTA INCORRECTA, INTÉNTELO DE NUEVO")
            Text(answerIsOk ? "RESPUESTA CORRECTA, ¡MUY BIEN!" : "RESPUESTA INCORRECTA, INTÉNTELO DE NUEVO")
        }
    }
    
    private var pregunta: some View{
        Text(quizItem.question)
            .font(.title)
            .bold()
    }
    
    private var estrella: some View{
        Button{
            Task{
                do {
                    try await quizzesModel.toggleFavourite(quizItem: quizItem)
                } catch {
                    throw "Datos recibidos corruptos."
                }
            }
        }label:{
            Image(quizItem.favourite ? "estrella_encendida" : "estrella_apagada")
                .resizable()
                .frame(width: 25, height: 25)
                .clipped()
                .scaledToFill()
        }
    }
    
    
    
    private var perfil: some View{
        HStack{
            Text(quizItem.author?.profileName ?? "Anónimo").font(.footnote)
            AsyncImage(url: quizItem.author?.photo?.url)

                .frame(width: 30, height: 30)
                .scaledToFill()
                .clipShape(Circle())
                .contentShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .overlay{
                    Circle().stroke(Color.gray, lineWidth: 1.5)
                }
                .contextMenu(ContextMenu(menuItems: {
                    Button(action: {
                        answer = ""
                    }, label:{
                        Label ("Limpiar", systemImage: "x.circle")  // Ademas hay que hacer esto poniendo la respuesta
                    })
                    Button(action: {
                        show_puntos = false
                    }, label:{
                        
                        Label ("Enseñar Puntos", systemImage: "sun.max.fill")
                    })
                    Button(action: {
                        show_puntos = true
                    }, label:{
                        Label ("Esconder Puntos", systemImage: "eraser")
                    })
                    Button(action: {
                        Task{
                            do{
                                let aux = try await quizzesModel.getAnswer(quizItem: quizItem)
                                answer = aux                                                       // AQUI HAY QUE PONER LA RESPUESTA
                            } catch {
                                throw "Datos recibidos corruptos."
                            }
                        }
                    }, label:{
                        Label ("Solución", systemImage: "square.and.arrow.up.on.square")

                    })
                }))
                .shadow(color: .gray, radius: 5, x: 0.5, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)

        }
    }
    

    @State var scale = 1.0
    private var foto: some View{
        GeometryReader { geometry in
                    EasyAsyncImage(url: quizItem.attachment?.url)
                
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .shadow(color: .black, radius: 10)
                .scaleEffect(scale)
                        .onTapGesture(count: 2) {
                            Task {
                                let ac = try await quizzesModel.getAnswer(quizItem: quizItem)
                                answer = ac
                                withAnimation {
                                    scale = 1.5 - scale
                                } completion: {
                                    withAnimation {
                                        scale = 1.5 - scale
                                    }
                                }
                            }
                        }
                }
            }
        



    func checkResponse() async {

        do{
         checkingResponse = true

         answerIsOk = try await quizzesModel.check(quizItem: quizItem, answer: answer)

         show_alert = true

         if answerIsOk{
             scoresModel.add(quizItem: quizItem)
         }

         checkingResponse = false

        } catch {
            errorMsg = error.localizedDescription
        }
         
    }









}
