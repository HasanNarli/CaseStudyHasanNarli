//
//  ProductCollectionViewCell.swift
//  EterationCaseUIKit
//
//  Created by arge-macbook-air on 25.05.2024.
//

import UIKit
import SDWebImage

protocol ProductCollectionViewCellDelegate: AnyObject {
    func didSelectFavorite(cell: ProductCollectionViewCell)
    func didSelectFavoriteButton(cell: ProductCollectionViewCell)
}

class ProductCollectionViewCell: UICollectionViewCell {
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .blue
        label.font = UIFont(name: "Montserrat", size: 14)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont(name: "Montserrat", size: 14)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to Cart", for: .normal)
        button.backgroundColor = .customBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: ProductCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(addToCartButton)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 150),
            productImageView.heightAnchor.constraint(equalToConstant: 150),
            
            favoriteButton.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.widthAnchor.constraint(equalToConstant: 58),
            priceLabel.heightAnchor.constraint(equalToConstant: 17),
            
            nameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: 34),
            
            addToCartButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            addToCartButton.heightAnchor.constraint(equalToConstant: 36),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with model: HomeModel?) {
        nameLabel.text = model?.name
        priceLabel.text = "\(model?.price ?? "") ₺"
        
        if let imageUrl = model?.image, let url = URL(string: imageUrl) {
            productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            productImageView.image = UIImage(named: "placeholder")
        }
        
        if let productItems = model {
            if CartManager.shared.isProductInCart(productItems) {
                addToCartButton.setTitle("Remove from Cart", for: .normal)
            } else {
                addToCartButton.setTitle("Add to Cart", for: .normal)
            }
        }
    }
    
    @objc func addToCartButtonTapped() {
        delegate?.didSelectFavorite(cell: self)
    }
    
    @objc func favoriteButtonTapped() {
        delegate?.didSelectFavoriteButton(cell: self)
    }
}
