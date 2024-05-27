//
//  EteService.swift
//  EterationCaseUIKit
//
//  Created by arge-macbook-air on 22.05.2024.
//

import Foundation

class ProductService {
    static let shared = ProductService()
    private var currentPage = 0
    private let itemsPerPage = 4
    init() {}
    
    func fetchMoreProducts(completion: @escaping (Result<[HomeModel], Error>) -> Void) {
        currentPage += 1
        
        guard let url = URL(string: "https://5fc9346b2af77700165ae514.mockapi.io/products") else {
            completion(.failure(CarServiceError.invalidURL))
            return
        }
        
        // Network request implementation
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(CarServiceError.invalidData))
                return
            }
            
            do {
                let products = try JSONDecoder().decode([HomeModel].self, from: data)
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

}
enum CarServiceError: Error {
    case invalidURL
    case invalidData
    case decodingError
}


