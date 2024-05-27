//
//  FavoriteManager.swift
//  EterationCaseUIKit
//
//  Created by arge-macbook-air on 26.05.2024.
//

import Foundation

class FavoriteManager {
    static let shared = FavoriteManager()
    
    private init() {}
    
    private var favoriteItems: [HomeModel] = []
    
    func addToFavorites(item: HomeModel) {
        if !favoriteItems.contains(where: { $0.id == item.id }) {
            favoriteItems.append(item)
        }
    }
    
    func getFavorites() -> [HomeModel] {
        return favoriteItems
    }
}

