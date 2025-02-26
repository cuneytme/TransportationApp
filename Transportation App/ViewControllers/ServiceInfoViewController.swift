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
        setupBindings()
        setupActions()
        setupDismissGesture()
    }
    
    private func setupBindings() {
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showError(error)
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
    
    private func setupDismissGesture() {
        serviceInfoView.dismissCallback = { [weak self] in
            self?.viewModel.handleBackgroundTap()
        }
        
        viewModel.dismissTrigger = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    @objc private func showServiceStopsButtonTapped() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                let serviceDetailVC = ServiceDetailViewController(serviceNumber: self.viewModel.getServiceNumber())
                navigationController.pushViewController(serviceDetailVC, animated: true)
            }
        }
    }
    
    @objc private func showTimetableButtonTapped() {
        guard let stopId = viewModel.getFirstStopId() else {
            showError("There is no stop for this service")
            return
        }
        
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                let timetableVC = TimetableViewController(serviceNumber: self.viewModel.getServiceNumber(), stopId: stopId)
                navigationController.pushViewController(timetableVC, animated: true)
            }
        }
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
