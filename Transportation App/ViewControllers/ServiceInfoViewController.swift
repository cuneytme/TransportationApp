//
//  ServiceInfoViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 07.02.2025.
//

import UIKit
import Combine

final class ServiceInfoViewController: UIViewController {
    private let serviceInfoView = ServiceInfoView()
    private let viewModel: ServiceInfoViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(serviceNumber: String) {
        self.viewModel = ServiceInfoViewModel(serviceNumber: serviceNumber)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = serviceInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupActions()
    }
    
    private func setupUI() {
        title = "Service Info"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupBindings() {
        viewModel.$serviceInfo
            .sink { [weak self] info in
                self?.serviceInfoView.serviceInfoLabel.text = info
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
    
    private func setupActions() {
        serviceInfoView.showServiceStopsButton.addTarget(
            self,
            action: #selector(showServiceStopsButtonTapped),
            for: .touchUpInside
        )
        
        serviceInfoView.showTimetableButton.addTarget(
            self,
            action: #selector(showTimetableButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func showServiceStopsButtonTapped() {
        let serviceDetailVC = ServiceDetailViewController(serviceNumber: viewModel.getServiceNumber())
        navigationController?.pushViewController(serviceDetailVC, animated: true)
    }
    
    @objc private func showTimetableButtonTapped() {
        guard let stopId = viewModel.getFirstStopId() else {
            showError("There is no stop for this service")
            return
        }
        
        let timetableVC = TimetableViewController(serviceNumber: viewModel.getServiceNumber(), stopId: stopId)
        navigationController?.pushViewController(timetableVC, animated: true)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} 
