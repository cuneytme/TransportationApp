import UIKit

final class FavoritesView: UIView {
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "FavoriteCell")
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
        backgroundColor = .white
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
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

