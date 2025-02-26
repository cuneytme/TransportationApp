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
        navigationItem.title = "Services"
        navigationController?.isToolbarHidden = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.frame.size.height = 0
        
        servicesView.tableView.delegate = self
        servicesView.tableView.dataSource = self
        servicesView.searchBar.delegate = self
        servicesView.segmentedControl.addTarget(self,
                                              action: #selector(segmentedControlValueChanged),
                                              for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
            .sink { [weak self] services in
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
        
        NotificationCenter.default.publisher(for: .favoritesDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.servicesView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension ServicesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceCardCell.identifier, for: indexPath) as? ServiceCardCell else {
            return UITableViewCell()
        }
        
        let service = viewModel.filteredServices[indexPath.row]
        let serviceType = viewModel.getServiceType(for: service)
        let icon = serviceType?.lowercased() == "tram" ? "🚊" : "🚌"
        let serviceText = "\(icon) \(service)"
        
        var routeText: String? = nil
        if let stopDetails = viewModel.getServiceStopDetails(for: service) {
            routeText = "\(stopDetails.first) ↔️ \(stopDetails.last)"
        }
        
        cell.configure(
            with: serviceText,
            route: routeText,
            isFavorite: viewModel.isFavorite(serviceNumber: service)
        )
        
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let serviceNumber = viewModel.filteredServices[indexPath.row]
        let serviceInfoVC = ServiceInfoViewController(serviceNumber: serviceNumber)
        
        serviceInfoVC.modalPresentationStyle = .overFullScreen
        serviceInfoVC.modalTransitionStyle = .crossDissolve
        serviceInfoVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5) 
        present(serviceInfoVC, animated: true)
    }
    
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        let service = viewModel.filteredServices[sender.tag]
        viewModel.toggleFavorite(serviceNumber: service)
        sender.isSelected = viewModel.isFavorite(serviceNumber: service)
    }
}

extension ServicesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterServices(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.filterServices(with: "")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
} 
