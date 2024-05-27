//
//  CoreDataManager.swift
//  EterationCaseUIKit
//
//  Created by arge-macbook-air on 23.05.2024.
//
import Foundation
import CoreData
import UIKit

class CartManager {
    static let shared = CartManager()
    
    private let cartKey = "cart"
    
    private init() {}
    
    // Get the current items in the cart
    var cartItems: [HomeModel] {
        return getCart()
    }
    
    // Add an item to the cart
    func addToCart(item: HomeModel) {
        var currentCart = getCart()
        currentCart.append(item)
        saveCart(cart: currentCart)
    }
    
    // Remove an item from the cart
    func removeFromCart(item: HomeModel) {
        
        var currentCart = getCart()
        if let index = currentCart.firstIndex(where: { $0.id == item.id }) {
            currentCart.remove(at: index)
            saveCart(cart: currentCart)
            deleteProductFromCoreData(productName: item.name ?? "")
        }
    }
    
    // Clear all items from the cart
    func clearCart() {
        saveCart(cart: [])
    }
    
    // MARK: - Private Methods
    
    // Get the current cart from UserDefaults
    private func getCart() -> [HomeModel] {
        if let data = UserDefaults.standard.data(forKey: cartKey) {
            do {
                let decoder = JSONDecoder()
                let cart = try decoder.decode([HomeModel].self, from: data)
                return cart
            } catch {
                print("Error decoding cart: \(error)")
            }
        }
        return []
    }
    
    // Save the current cart to UserDefaults
    private func saveCart(cart: [HomeModel]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(cart)
            UserDefaults.standard.set(data, forKey: cartKey)
        } catch {
            print("Error encoding cart: \(error)")
        }
    }
    
    func isProductInCart(_ product: HomeModel) -> Bool {
        let currentCart = getCart()
        return currentCart.contains { $0.id == product.id }
    }
    
    private func deleteProductFromCoreData(productName: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EterationCaseUIKit")
        fetchRequest.predicate = NSPredicate(format: "name == %@", productName as CVarArg)

        do {
            let result = try context.fetch(fetchRequest)
            if let productEntity = result.first as? NSManagedObject {
                context.delete(productEntity)
                try context.save()
            }
        } catch {
            print("Error deleting product from Core Data: \(error)")
        }
    }
}

