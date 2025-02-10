//
//  ImageView.swift
//  iOSApp2
//
//  Created by Jules Mickael on 2025-02-10.
//

import SwiftUI

struct ImageView: View {
    
    let images = ["image1", "image2", "image3", "image4", "image5", "image6", "image7", "image8"]
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(images, id: \.self) { image in
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipped()
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
            }
            .padding()
        }
        .background(Color("customblue").opacity(0.1)) // Fond bleu personnalisé léger
        .navigationTitle("Photo Gallery")
    }
}

// MARK: - Preview
struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
    }
}


