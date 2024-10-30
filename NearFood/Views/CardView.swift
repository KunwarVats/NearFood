//
//  CardView.swift
//  NearFood
//
//  Created by Kunwar Vats on 30/10/24.
//

import SwiftUI

struct CardView: View {
    let restaurant: Business
    @StateObject private var imageHelper = ImageHelper()

    var body: some View {
        VStack {
            if let image = imageHelper.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 200)
                    .clipped()
            } else {
                Color.gray // Placeholder color while loading
                    .frame(width: 300, height: 200)
                    .clipped()                    .onAppear {
                        // Load the image when the view appears
                        if let url = URL(string: restaurant.imageUrl) {
                            imageHelper.load(url: url)
                        }
                    }
            }
            Text(restaurant.name)
                .font(.headline)
                .padding(.top)
            Text("Rating: \(restaurant.rating, specifier: "%.1f") ★")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: 300, height: 350)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
