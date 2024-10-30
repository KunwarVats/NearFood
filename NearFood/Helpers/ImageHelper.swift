//
//  ImageHelper.swift
//  NearFood
//
//  Created by Kunwar Vats on 30/10/24.
//

import SwiftUI
import Combine

class ImageHelper: ObservableObject {
    @Published var image: UIImage? = nil
    private var cancellables = Set<AnyCancellable>()

    func load(url: URL) {
        // Use URLSession to load the image data
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .compactMap { UIImage(data: $0) }
            .receive(on: DispatchQueue.main) // Switch to main thread to update UI
            .sink(receiveCompletion: { completion in
                // Handle errors if needed
                if case .failure(let error) = completion {
                    print("Error loading image: \(error)")
                }
            }, receiveValue: { [weak self] image in
                self?.image = image // Set the loaded image
            })
            .store(in: &cancellables)
    }
}
