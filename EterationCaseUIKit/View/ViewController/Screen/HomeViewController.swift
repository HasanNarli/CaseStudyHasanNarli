//
//  HomeViewController.swift
//  EterationCaseUIKit
//
//  Created by arge-macbook-air on 25.05.2024.
//

import UIKit
import UIScrollView_InfiniteScroll
import CoreData

class HomeViewController: BaseViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filters:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Filter", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [filterLabel, filterButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var homeViewModel = HomeViewModel()
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMoreData()
        setupInfiniteScroll()
    }
    
    func fetchMoreData() {
        homeViewModel.fetchMoreProducts { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.finishInfiniteScroll()
            }
        }
    }
    
    func setupInfiniteScroll() {
        collectionView.addInfiniteScroll { [weak self] collectionView in
            guard let self = self else { return }
            if !self.isLoading {
                self.isLoading = true
                self.fetchMoreData()
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = .customBlue
        setupNavigationBar()
        
        // Add SearchBar
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Add Horizontal StackView
        view.addSubview(horizontalStackView)
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // Add UICollectionView
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "E-Market"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.sizeToFit()
        
        let leftBarButton = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        navigationController?.navigationBar.barTintColor = UIColor.customBlue
        navigationController?.navigationBar.isTranslucent = true
    }
    
    @objc func filterButtonTapped() {
        // Filtreleme butonu tıklama işlemleri
    }
}

extension HomeViewController: ProductCollectionViewCellDelegate {
    func didSelectFavorite(cell: ProductCollectionViewCell) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let addCart = NSEntityDescription.insertNewObject(forEntityName: "EterationCaseUIKit", into: context)
        
        if let indexPath = collectionView.indexPath(for: cell) {
            let selectedProduct = homeViewModel.homeModels[indexPath.row]
            let isInCart = CartManager.shared.isProductInCart(homeViewModel.homeModels[indexPath.row])
            if isInCart {
                CartManager.shared.removeFromCart(item: selectedProduct)
                showAlert(message: "Product removed from cart!")
                cell.addToCartButton.titleLabel?.text = "Add to Cart"
            } else {
                CartManager.shared.addToCart(item: selectedProduct)
                addCart.setValue(selectedProduct.image, forKey: "image")
                addCart.setValue(selectedProduct.price, forKey: "price")
                addCart.setValue(selectedProduct.name, forKey: "name")
                addCart.setValue(selectedProduct.description, forKey: "desc")
                addCart.setValue(UUID(), forKey: "id")
                
                do {
                    try context.save()
                    print("success")
                } catch {
                    print("Error")
                }
                showAlert(message: "Product added to cart!")
                cell.addToCartButton.titleLabel?.text = "Remove from Cart"
            }
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        }
        self.collectionView.reloadData()
    }
    
    func didSelectFavoriteButton(cell: ProductCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let selectedProduct = homeViewModel.homeModels[indexPath.row]
            // Favorilere ekleme işlemi
            FavoriteManager.shared.addToFavorites(item: selectedProduct)
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.homeModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = homeViewModel.homeModels[indexPath.item]
        cell.delegate = self
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let spacingBetweenItems: CGFloat = 20

        let totalSpacing = (2 * 15) + ((numberOfItemsPerRow - 1) * spacingBetweenItems) // 15 is the section insets
        let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: width, height: width + 100) // 100 is an arbitrary height for labels and button
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = homeViewModel.homeModels[indexPath.item]
        navigateToProductDetail(selectedProduct)
    }
}

extension HomeViewController {
    func navigateToProductDetail(_ selectedProduct: HomeModel) {
        let productDetailVC = ContentsViewController()
        productDetailVC.selectedProduct = selectedProduct
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

