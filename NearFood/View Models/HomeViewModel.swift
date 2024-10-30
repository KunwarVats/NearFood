
//
//  ViewModel.swift
//  NearFood
//
//  Created by Kunwar Vats on 30/10/24.
//
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {

    @Published var currentIndex = 0
    @Published var offsetX: CGFloat = 0 // Track
    @Published var businesses: [Business] = []
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let APIClient = NetworkClient()
    private var APIOffset = 0
    private var latitude: Double?
    private var longitude: Double?

    func nextCard() {
        
        if currentIndex == businesses.count - 4 {
            loadMoreRestaurants()
        }
        guard currentIndex < businesses.count else { return }
        offsetX = -300 // Set offset to animate offscreen to the left
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.currentIndex += 1
            self.offsetX = 0
        }
    }

    func previousCard() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        offsetX = -300
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.offsetX = 0 // Animate back from the left
        }
    }

    func loadMoreRestaurants() {
        // Add more dummy data or refresh to simulate endless loading
        //restaurants.append(contentsOf: sampleRestaurants)
        
        if let latitude, let longitude {
            APIOffset = APIOffset + 20
            loadBusinesses(latitude: latitude, longitude: longitude)
        }
    }
        
    func updateLocation(latitude: Double, longitude: Double) {
        // Your location update logic here
        print("Updated Location: Lat: \(latitude), Long: \(longitude)")
        self.latitude = latitude
        self.longitude = longitude
        loadBusinesses(latitude: latitude, longitude: longitude)
    }
    
    func bindLocationUpdates(from locationClient: LocationClient) {
        locationClient.$latitude
            .combineLatest(locationClient.$longitude)
            .sink { [weak self] latitude, longitude in
                guard let self = self, let latitude = latitude, let longitude = longitude else { return }
                self.updateLocation(latitude: latitude, longitude: longitude)
            }
            .store(in: &cancellables)
    }
    
    func loadBusinesses(latitude: Double, longitude: Double) {
        APIClient.fetchBusinesses(latitude: latitude, longitude: longitude, offset: APIOffset)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break // Handle successful completion if necessary
                case .failure(let err):
                    self.error = err.localizedDescription
                }
            }, receiveValue: { businesses in
                self.businesses.append(contentsOf: businesses)
            })
            .store(in: &cancellables)
    }
}
