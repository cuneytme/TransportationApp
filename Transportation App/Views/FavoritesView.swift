//
//  FavoritesView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//



import UIKit

final class FavoritesView: UIView {
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search favorites"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .white
        searchBar.searchTextField.backgroundColor = .white
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .black
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray
        ]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search favorites", attributes: attributes)
        return searchBar
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(FavoriteCardCell.self, forCellReuseIdentifier: FavoriteCardCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemBlue
        table.separatorStyle = .none
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBlue
        
        addSubview(headerView)
        headerView.addSubview(searchBar)
        addSubview(tableView)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            searchBar.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
            searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        configureSearchBar()
    }
    
    private func configureSearchBar() {
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = .white
            if let leftView = searchTextField.leftView as? UIImageView {
                leftView.tintColor = .gray
            }
        }
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([
            .foregroundColor: UIColor.white
        ], for: .normal)
    }
}

extension UIButton {
    static func createFavoriteButton() -> UIButton {
        let button = UIButton(type: .custom)
        let normalImage = UIImage(systemName: "heart")?
        .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        let selectedImage = UIImage(systemName: "heart.fill")?
        .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.backgroundColor = .clear
        let buttonSize: CGFloat = 44
        button.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        return button
    }
}

