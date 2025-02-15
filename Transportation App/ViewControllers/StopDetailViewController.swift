//
//  StopDetailViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 07.02.2025.
//


import UIKit
import Combine
final class StopDetailViewController: UIViewController {
    private let stopDetailView = StopDetailView()
    private let viewModel: StopDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(stop: Stop) {
        self.viewModel = StopDetailViewModel(stop: stop)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = stopDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupNavigationHandlers()
        viewModel.startLiveUpdates()
    }
    
    private func setupUI() {
        title = viewModel.title
        stopDetailView.tableView.delegate = self
        stopDetailView.tableView.dataSource = self
    }
    
    private func setupBindings() {
        viewModel.$liveTimes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.stopDetailView.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.stopDetailView.activityIndicator.startAnimating()
                } else {
                    self?.stopDetailView.activityIndicator.stopAnimating()
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
    }
    
    private func setupNavigationHandlers() {
        viewModel.onServiceSelected = { [weak self] serviceName in
            let serviceDetailVC = ServiceDetailViewController(serviceNumber: serviceName)
            self?.navigationController?.pushViewController(serviceDetailVC, animated: true)
        }
    }
}

extension StopDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.liveTimes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.liveTimes[section].departures.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Route \(viewModel.liveTimes[section].routeName)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusTimeCell", for: indexPath)
        let route = viewModel.liveTimes[indexPath.section]
        let departure = route.departures[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = "🚌 \(departure.routeName) - \(departure.destination)"
        
        let status = departure.isLive ? "Live" : "Planned"
        content.secondaryText = "\(status) - Departure: \(departure.displayTime)"
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let route = viewModel.liveTimes[indexPath.section]
        let departure = route.departures[indexPath.row]
        viewModel.didSelectService(departure.routeName)
    }
} 
