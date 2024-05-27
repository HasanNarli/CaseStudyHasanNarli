//
//  ContentsViewController.swift
//  EterationCaseUIKit
//
//  Created by arge-macbook-air on 25.05.2024.
//

import UIKit
import SDWebImage
import CoreData
import UIScrollView_InfiniteScroll

class ContentsViewController: BaseViewController {

    // Image view for product image
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Title label for product name
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    // Description label for product description
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    // Horizontal stack view for price and add to cart button
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 100
        return stackView
    }()
    
    // Vertical stack view for price information
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    // Label for "Price:"
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Price:"
        return label
    }()
    
    // Label for displaying price value
    let priceValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    // Button for "Add to Cart"
    let addToCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to Cart", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    var selectedProduct: HomeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = selectedProduct?.name
        setupUI()
    }
    

    
    private func setupUI() {
        // Add subviews to the view
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(horizontalStackView)
        
        // Add subviews to the horizontal stack view
        horizontalStackView.addArrangedSubview(priceStackView)
        horizontalStackView.addArrangedSubview(addToCartButton)
        
        // Add subviews to the vertical stack view
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceValueLabel)
        
        // Set constraints programmatically
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            horizontalStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            horizontalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
        
        // Configure UI elements
        configureUI()
        detailButtonConfigureUI(button: addToCartButton)
    }
    
    private func configureUI() {
        if let imageUrl = selectedProduct?.image, let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
        titleLabel.text = selectedProduct?.name
        descriptionLabel.text = selectedProduct?.description
        priceValueLabel.text = "\(selectedProduct?.price ?? "")₺"
    }
    
    @objc func addToCartButtonTapped() {
        showButton()
    }
    
    func showButton() {
        guard let selectedProduct = selectedProduct else { return }
        
        let isInCart = CartManager.shared.isProductInCart(selectedProduct)
        
        if (isInCart) {
            // If the product is already in the cart, remove it
            CartManager.shared.removeFromCart(item: selectedProduct)
            showAlert(message: "Product removed from cart!")
            addToCartButton.titleLabel?.text = "Add to Cart"
        } else {
            // If the product is not in the cart, add it
            CartManager.shared.addToCart(item: selectedProduct)
            showAlert(message: "Product added to cart!")
            addToCartButton.titleLabel?.text = "Remove from Cart"
        }
        
        detailButtonConfigureUI(button: addToCartButton)
    }
    
    func detailButtonConfigureUI(button: UIButton) {
        if let selectedProduct = selectedProduct {
            if (CartManager.shared.isProductInCart(selectedProduct)) {
                button.setTitle("Remove from Cart", for: .normal)
            } else {
                button.setTitle("Add to Cart", for: .normal)
            }
        }
    }
}
