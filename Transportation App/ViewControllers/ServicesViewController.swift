//
//  ServicesViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 07.02.2025.
//

import UIKit
import Combine

final class ServicesViewController: UIViewController {
    private let servicesView = ServicesView()
    private let viewModel: ServicesViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ServicesViewModel = ServicesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = servicesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchServices()
    }
    
    private func setupUI() {
        title = "Services"
        servicesView.tableView.delegate = self
        servicesView.tableView.dataSource = self
        servicesView.searchBar.delegate = self
        servicesView.segmentedControl.addTarget(self, 
                                              action: #selector(segmentedControlValueChanged),
                                              for: .valueChanged)
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let transportType: TransportType
        switch sender.selectedSegmentIndex {
        case 0:
            transportType = .all
        case 1:
            transportType = .bus
        case 2:
            transportType = .tram
        default:
            transportType = .all
        }
        viewModel.updateTransportType(transportType)
    }
    
    private func setupBindings() {
        viewModel.$filteredServices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.servicesView.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.servicesView.activityIndicator.startAnimating()
                } else {
                    self?.servicesView.activityIndicator.stopAnimating()
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
}

extension ServicesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath)
        let service = viewModel.filteredServices[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        if let serviceType = viewModel.getServiceType(for: service) {
            let icon = serviceType.lowercased() == "tram" ? "🚊" : "🚌"
            content.text = "\(icon) \(service)"
            print("Servis \(service) - Service Type: \(serviceType)")
        } else {
            content.text = "🚌 \(service)"
        }
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let serviceNumber = viewModel.filteredServices[indexPath.row]
        let serviceInfoVC = ServiceInfoViewController(serviceNumber: serviceNumber)
        navigationController?.pushViewController(serviceInfoVC, animated: true)
    }
}

extension ServicesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterServices(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
} 
