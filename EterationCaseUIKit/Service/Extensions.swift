//
//  Extensions.swift
//  EterationCaseUIKit
//
//  Created by arge-macbook-air on 22.05.2024.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "Alert", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let applyAction = UIAlertAction(title: "Apply", style: .default, handler: nil)
        alertController.addAction(applyAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static let customBlue = UIColor(hex: "#2A59FE")
}

