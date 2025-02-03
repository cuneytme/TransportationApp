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
    
    private func setupUI() {
        title = "Duraklar"
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
                let alert = UIAlertController(title: "Hata", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }
}

extension StopsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredStops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StopCell", for: indexPath)
        let stop = viewModel.filteredStops[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = stop.name
        content.secondaryText = "Konum: \(stop.locality) • Servisler: \(stop.services?.joined(separator: ", ") ?? "")"
        cell.contentConfiguration = content
        
        return cell
    }
}

extension StopsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterStops(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
} 
