
//
//  QuizItemRow.swift
//  P4.1_app
//
//  Created by c052 DIT UPM on 16/11/23.
//

import SwiftUI

struct QuizItemRowView: View {
    var quizItem: QuizItem
    
    @Environment(\.horizontalSizeClass) var hsc
    @Environment(\.verticalSizeClass) var vsc
    var body: some View {
        if hsc == .compact && vsc == .regular{
            VStack{
                Spacer()
                    .frame(width: 12, height: 12)
                HStack{
                    foto
                    Spacer()
                }
                HStack{
                    pregunta
                    Spacer()
                    estrella
                }
                HStack{
                    perfil
                    Spacer()
                }
                Spacer()
                    .frame(width: 12, height: 12)
            }
        }else{
            HStack{
                Spacer()
                    .frame(width: 12, height: 12)
                
                    foto
                    Spacer()
                VStack{
                    HStack{
                        pregunta
                        estrella
                        Spacer()
                    }
                    HStack{
                        perfil
                        Spacer()
                    }
                }

            }
        }
        
    }
    
    private var pregunta: some View{
        Text(quizItem.question)
            .bold()
            .lineLimit(3)
    }
    
    private var foto: some View{
        
            AsyncImage(url: quizItem.attachment?.url){ phase
                in
                switch phase{
                case .empty:
                    Image(systemName: "circle.slash")
                case .success(let image):
                    image.resizable()
                        .scaledToFill()
                        .frame(maxWidth: 200, maxHeight: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
    
                case .failure(_):
                    Image(systemName: "circle.slash")
                @unknown default:
                    Image(systemName: "circle.slash")
                }
            
        }
    }
    
    private var estrella: some View{
        Image(quizItem.favourite ? "estrella_encendida" : "estrella_apagada")
            .resizable()
            .frame(width: 20, height: 20)
            .clipped()
            .scaledToFill()
    }
    
    private var perfil: some View{
        HStack{
            Text(quizItem.author?.profileName ?? "Anónimo").font(.footnote)
            AsyncImage(url: quizItem.author?.photo?.url)
                .frame(width: 20, height: 20)
                .clipShape(Circle())
                .scaledToFill()
                .overlay{
                    Circle().stroke(Color.gray, lineWidth: 1.5)
                }
                .shadow(color: .gray, radius: 5, x: 0.5, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
        }
    }
    
}
