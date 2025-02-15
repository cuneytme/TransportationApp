import UIKit
import Combine

final class FavoritesViewController: UIViewController {
    private let favoritesView = FavoritesView()
    private let viewModel: FavoritesViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: FavoritesViewModel = FavoritesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = favoritesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadFavorites()
    }
    
    private func setupUI() {
        title = "Favorites"
        favoritesView.tableView.delegate = self
        favoritesView.tableView.dataSource = self
    }
    
    private func setupBindings() {
        viewModel.$favorites
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.favoritesView.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$navigationAction
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] action in
                self?.handleNavigation(action)
            }
            .store(in: &cancellables)
    }
    
    private func handleNavigation(_ action: FavoritesViewModel.NavigationAction) {
        switch action {
        case .showServiceInfo(let serviceNumber):
            let serviceInfoVC = ServiceInfoViewController(serviceNumber: serviceNumber)
            navigationController?.pushViewController(serviceInfoVC, animated: true)
            
        case .showStopDetail(let stop):
            let stopDetailVC = StopDetailViewController(stop: stop)
            navigationController?.pushViewController(stopDetailVC, animated: true)
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
        let favorite = viewModel.favorites[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = favorite.name
        content.secondaryText = favorite.type == .service ? "Service" : "Stop"
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favorite = viewModel.favorites[indexPath.row]
            viewModel.removeFavorite(favorite)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = viewModel.favorites[indexPath.row]
        viewModel.navigateToDetail(for: favorite)
        tableView.deselectRow(at: indexPath, animated: true)
    }
} 
