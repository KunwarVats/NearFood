//
//  ContentView.swift
//  NearFood
//
//  Created by Kunwar Vats on 30/10/24.
//

import SwiftUI
import Combine

struct HomeView: View
{
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var locationClient = LocationClient()
    private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        
        ZStack {
            // Background color for the entire view
            
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange, Color.yellow]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            // Overlay shapes
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 300, height: 300)
                .position(x: 100, y: 200)
            
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 200, height: 200)
                .position(x: 300, y: 100)

            VStack {
                if viewModel.currentIndex < viewModel.businesses.count {
                    ZStack {
                        ForEach(viewModel.currentIndex..<viewModel.businesses.count, id: \.self) { index in
                            CardView(restaurant: viewModel.businesses[index])
                                .offset(x: index == viewModel.currentIndex ? viewModel.offsetX : 0) // Apply animation only to the top card
                                .opacity(index == viewModel.currentIndex ? 1 : 0) // Make only the top card visible
                                .animation(.spring(), value: viewModel.offsetX)
                        }
                    }
                    .frame(height: 400)
                } else {
                    Text("No more restaurants to show")
                }
                
                HStack(spacing: 10) {
                    Button(action: viewModel.previousCard) {
                        Text("Previous")
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, minHeight: 45)
                            .background((Color.clear))
                            .foregroundColor(Color.red)
                            .overlay(
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)) // Create a rounded rectangle for the border
                                    .stroke(Color.red, lineWidth: 2) // Set the border color and width
                            )
                    }
                    Spacer()
                    Button(action: viewModel.nextCard) {
                        Text("Next")
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, minHeight: 45)
                            .background((Color.clear))
                            .foregroundColor(Color.blue)
                            .overlay(
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)) // Create a rounded rectangle for the border
                                    .stroke(Color.blue, lineWidth: 2) // Set the border color and width
                            )
                    }
                    
                }
                .padding(.horizontal, 45) // Horizontal padding around the entire HStack
            }
        }
        .onAppear {
            viewModel.bindLocationUpdates(from: locationClient)
        }
    }
}

#Preview {
    HomeView()
}
