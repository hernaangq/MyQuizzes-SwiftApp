//
//  EasyAsyncImage.swift
//  P4.1_app
//
//  Created by c052 DIT UPM on 15/12/23.
//
import SwiftUI

struct EasyAsyncImage: View {
    var url: URL?
    var body: some View {
        AsyncImage(url: url) { phase in
            if url == nil {
                Color.white
            }
            else if let image = phase.image {
                image.resizable()
            }   else if phase.error != nil {
                Color.red
            }   else {
                ProgressView()
            }
            }
    }
}
