//
//  FavoritesViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 23.02.2025.
//

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupUI() {
        title = "Favorites"
        favoritesView.tableView.delegate = self
        favoritesView.tableView.dataSource = self
        favoritesView.searchBar.delegate = self
    }
    
    private func setupBindings() {
        viewModel.$filteredFavorites
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

extension FavoritesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterFavorites(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.filterFavorites(with: "")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredFavorites.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCardCell.identifier, for: indexPath) as? FavoriteCardCell else {
            return UITableViewCell()
        }
        
        let favorite = viewModel.filteredFavorites[indexPath.row]
        
        cell.configure(with: favorite, firstStop: nil, lastStop: nil)
        
        if favorite.type == .service {
            Task {
                do {
                    let stopDetails = try await viewModel.getServiceStopDetails(for: favorite.id)
                    await MainActor.run {
                        if let currentIndex = tableView.indexPath(for: cell),
                           currentIndex == indexPath {
                            cell.configure(
                                with: favorite,
                                firstStop: stopDetails?.first,
                                lastStop: stopDetails?.last
                            )
                        }
                    }
                } catch {
                 //
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favorite = viewModel.filteredFavorites[indexPath.row]
            viewModel.removeFavorite(favorite)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = viewModel.filteredFavorites[indexPath.row]
        viewModel.navigateToDetail(for: favorite)
        tableView.deselectRow(at: indexPath, animated: true)
    }
} 
