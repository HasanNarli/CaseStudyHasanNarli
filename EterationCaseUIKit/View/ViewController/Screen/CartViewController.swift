//
//  CartViewController.swift
//  EterationCaseUIKit
//
//  Created by arge-macbook-air on 25.05.2024.
//
import UIKit
import CoreData

class CartViewController: BaseViewController {
    
    // Table view for displaying cart items
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "productCell")
        tableView.tableFooterView = UIView() // To hide empty cell separators
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let bottomBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Total: 0 ₺"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Complete", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var cartItems: [CartModel] = []
    var quantities: [UUID: Int] = [:] // Dictionary to hold quantities for each item
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "E-Market"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.sizeToFit()
        
        let leftBarButton = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        if let navigationBar = self.navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.customBlue
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(bottomBarView)
        bottomBarView.addSubview(totalLabel)
        bottomBarView.addSubview(completeButton)
        
        // Set constraints for table view using programmatic auto layout
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor, constant: -10),
            
            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 60),
            
            totalLabel.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: 16),
            totalLabel.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            
            completeButton.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -16),
            completeButton.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            completeButton.widthAnchor.constraint(equalToConstant: 120),
            completeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Set the delegate and data source for the table view
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func getData() {
        cartItems.removeAll(keepingCapacity: false)
        quantities.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EterationCaseUIKit")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            var uniqueNames: Set<String> = Set()
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String,
                   let price = result.value(forKey: "price") as? String,
                   let id = result.value(forKey: "id") as? UUID {
                    if !uniqueNames.contains(name) {
                        let cartItem = CartModel(name: name, price: price, id: id)
                        cartItems.append(cartItem)
                        quantities[id] = 1 // Default quantity
                        uniqueNames.insert(name)
                    }
                }
            }
            tableView.reloadData()
            updateTotal()
        } catch {
            print("Error")
        }
    }
    
    private func updateTotal() {
        var total = 0
        for item in cartItems {
            if let quantity = quantities[item.id], let price = Int(item.price) {
                total += price * quantity
            }
        }
        totalLabel.text = "Total: \(total) ₺"
    }
    
    @objc func completeButtonTapped() {
        // Complete purchase action
        print("Complete purchase")
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let product = cartItems[indexPath.row]
        cell.configure(with: product, quantity: quantities[product.id] ?? 1)
        cell.delegate = self
        return cell
    }
}

extension CartViewController: ProductTableViewCellDelegate {
    func didChangeQuantity(cell: ProductTableViewCell, quantity: Int) {
        if let indexPath = tableView.indexPath(for: cell) {
            let product = cartItems[indexPath.row]
            quantities[product.id] = quantity
            updateTotal()
        }
    }
}

