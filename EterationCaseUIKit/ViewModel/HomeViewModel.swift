//
//  HomeViewModel.swift
//  EterationCaseUIKit
//
//  Created by arge-macbook-air on 25.05.2024.
//
import Foundation

class HomeViewModel {
    
    private let productService = ProductService()
    
    var homeModels: [HomeModel] = []
    
    func fetchMoreProducts(completion: @escaping () -> Void) {
        productService.fetchMoreProducts { [weak self] result in
            guard let self = self else {
                completion()
                return
            }
            switch result {
            case .success(let newProducts):
                self.homeModels.append(contentsOf: newProducts)
            case .failure(let error):
                print("Failed to fetch products: \(error)")
            }
            completion()
        }
    }
}

