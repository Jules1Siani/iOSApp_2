//
//  ContentView.swift
//  iOSApp2
//
//  Created by Jules Mickael on 2025-02-10.
//
import SwiftUI

struct ScavengerHuntView: View {
    
    let clues = [
        "Find the red bench in the city's largest park.",
        "Look for a mural depicting a wild animal.",
        "Spot the fountain with an angel statue downtown.",
        "Find a café with an old-fashioned clock on its wall.",
        "Identify the restaurant that serves purple burgers.",
        "Take a photo of the streetlamp decorated with fairy lights.",
        "Locate a building with an entirely yellow door.",
        "Find a road sign with a quirky sticker on it.",
        "Take a picture of the entrance to a free museum.",
        "Discover a shop with a bright red neon sign."
    ]
    
    let imageOptions = ["image1", "image2", "image3", "image4", "image5", "image6", "image7", "image8", "image9", "image10"]

    @State private var foundItems: Set<Int> = []
    @State private var selectedImages: [Int: String] = [:] // Stocke les noms des images sélectionnées
    @State private var selectedItemIndex: Int? = nil
    @State private var showImageSelection = false
    
    var discountMessage: String {
        switch foundItems.count {
        case 7...9:
            return "🎉 20% Discount Code: LOCAL20"
        case 5...6:
            return "🎉 10% Discount Code: LOCAL10"
        case 10:
            return "🎉 20% Discount Code: LOCAL20 + Entered in the $5000 draw!"
        default:
            return "❌ No discount earned yet."
        }
    }
    
    var body: some View {
        VStack {
            Text("🏆 Citywide Scavenger Hunt")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("Find items, select photos, and win discounts!")
                .font(.subheadline)
                .padding(.bottom)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(clues.indices, id: \.self) { index in
                        VStack {
                            Text(clues[index])
                                .font(.headline)
                                .padding()
                            
                            if let imageName = selectedImages[index] {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .cornerRadius(10)
                                    .padding(.bottom, 5)
                            }
                            
                            Button(action: {
                                selectedItemIndex = index
                                showImageSelection = true
                            }) {
                                Text(foundItems.contains(index) ? "✅ Found!" : "📷 Take Photo")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(foundItems.contains(index) ? Color.green : Color("lightpink"))
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
            
            Button(action: {
                print("Results Submitted: \(foundItems.count) items found.")
            }) {
                Text("📩 Submit Results")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
            .padding()
            
            Text(discountMessage)
                .font(.headline)
                .foregroundColor(.red)
                .padding()
        }
        .padding()
        .sheet(isPresented: $showImageSelection) {
            if let index = selectedItemIndex {
                ImageSelectionView(images: imageOptions) { selectedImage in
                    selectedImages[index] = selectedImage
                    foundItems.insert(index)
                }
            }
        }
    }
}

struct ImageSelectionView: View {
    let images: [String]
    var onSelect: (String) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("Select an Image")
                    .font(.headline)
                    .padding()
                
                ForEach(images, id: \.self) { imageName in
                    Button(action: {
                        onSelect(imageName)
                    }) {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                            .padding()
                    }
                }
            }
        }
    }
}

struct ScavengerHuntView_Previews: PreviewProvider {
    static var previews: some View {
        ScavengerHuntView()
    }
}
