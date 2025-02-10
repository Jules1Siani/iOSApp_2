//
//  ContentView.swift
//  iOSApp2
//
//  Created by Jules Mickael on 2025-02-10.
//
import SwiftUI
import PhotosUI

struct ScavengerHuntView: View {
    
    let clues = [
        "Find the oldest bookstore in town.",
        "Look for a golden popcorn statue at the cinema.",
        "Locate the giant coffee cup downtown.",
        "A mural of history—find the past painted on the wall.",
        "The place where music never stops playing.",
        "The bakery known for its legendary croissants.",
        "Find the hidden garden behind the library.",
        "A bridge with lovers’ locks—find the heart engraved one.",
        "The tallest clock tower in the city.",
        "A neon-lit diner straight from the ‘50s."
    ]
    
    @State private var foundItems: Set<Int> = []
    @State private var selectedImages: [Int: UIImage] = [:]
    @State private var selectedItemIndex: Int? = nil
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    
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
            
            Text("Find items, take photos, and win discounts!")
                .font(.subheadline)
                .padding(.bottom)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(clues.indices, id: \.self) { index in
                        VStack {
                            Text(clues[index])
                                .font(.headline)
                                .padding()
                            
                            if let image = selectedImages[index] {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .cornerRadius(10)
                                    .padding(.bottom, 5)
                            }
                            
                            Button(action: {
                                selectedItemIndex = index
                                showImagePicker = true
                            }) {
                                Text(foundItems.contains(index) ? "✅ Found!" : "📸 Take Photo")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(foundItems.contains(index) ? Color.green : Color.blue)
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
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, completion: {
                if let index = selectedItemIndex, let image = selectedImage {
                    selectedImages[index] = image
                    foundItems.insert(index)
                }
            })
        }
    }
}

// MARK: - Image Picker for Photo Selection
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var completion: () -> Void
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                        self.parent.completion()
                    }
                }
            }
        }
    }
}

// MARK: - Preview for SwiftUI Canvas
struct ScavengerHuntView_Previews: PreviewProvider {
    static var previews: some View {
        ScavengerHuntView()
    }
}



