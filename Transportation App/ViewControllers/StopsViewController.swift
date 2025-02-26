//
//  StopsViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 29.01.2025.
//

import UIKit
import Combine

final class StopsViewController: UIViewController {
    private let stopsView = StopsView()
    private let viewModel: StopsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: StopsViewModel = StopsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = stopsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchStops()
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
        title = "Stops"
        stopsView.tableView.delegate = self
        stopsView.tableView.dataSource = self
        stopsView.searchBar.delegate = self
    }
    
    private func setupBindings() {
        viewModel.$filteredStops
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.stopsView.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.stopsView.activityIndicator.startAnimating()
                } else {
                    self?.stopsView.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] error in
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .favoritesDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.stopsView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension StopsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredStops.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StopCardCell.identifier, for: indexPath) as? StopCardCell else {
            return UITableViewCell()
        }
        
        let stop = viewModel.filteredStops[indexPath.row]
        
        cell.configure(
            with: stop.name,
            isFavorite: viewModel.isFavorite(stopId: stop.stopId)
        )
        
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let stop = viewModel.filteredStops[indexPath.row]
        let stopDetailVC = StopDetailViewController(stop: stop)
        navigationController?.pushViewController(stopDetailVC, animated: true)
    }
    
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        let stop = viewModel.filteredStops[sender.tag]
        viewModel.toggleFavorite(stop: stop)
        sender.isSelected = viewModel.isFavorite(stopId: stop.stopId)
    }
}

extension StopsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterStops(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.filterStops(with: "")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
} 
