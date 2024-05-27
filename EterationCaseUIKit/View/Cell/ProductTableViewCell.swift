//
//  ProductTableViewCell.swift
//  EterationCaseUIKit
//
//  Created by arge-macbook-air on 25.05.2024.
//

import UIKit

protocol ProductTableViewCellDelegate: AnyObject {
    func didChangeQuantity(cell: ProductTableViewCell, quantity: Int)
}

class ProductTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .blue
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: ProductTableViewCellDelegate?
    private var quantity: Int = 0
    private var productPrice: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(minusButton)
        contentView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            minusButton.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: -8),
            minusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            minusButton.widthAnchor.constraint(equalToConstant: 30),
            minusButton.heightAnchor.constraint(equalToConstant: 30),
            
            quantityLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            quantityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 50),
            quantityLabel.heightAnchor.constraint(equalToConstant: 30),
            
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        minusButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
    }
    
    func configure(with model: CartModel, quantity: Int) {
        nameLabel.text = model.name
        self.productPrice = Int(model.price) ?? 0
        self.quantity = quantity
        updatePriceLabel()
        quantityLabel.text = "\(quantity)"
    }
    
    @objc private func decreaseQuantity() {
        if quantity > 0 {
            quantity -= 1
            quantityLabel.text = "\(quantity)"
            updatePriceLabel()
            delegate?.didChangeQuantity(cell: self, quantity: quantity)
        }
    }
    
    @objc private func increaseQuantity() {
        quantity += 1
        quantityLabel.text = "\(quantity)"
        updatePriceLabel()
        delegate?.didChangeQuantity(cell: self, quantity: quantity)
    }
    
    private func updatePriceLabel() {
        let total = productPrice * quantity
        priceLabel.text = "\(total) ₺"
    }
}

