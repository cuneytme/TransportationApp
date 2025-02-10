//
//  TimetableViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 07.02.2025.
//

import UIKit
import Combine

final class TimetableViewController: UIViewController {
    private let timetableView = TimetableView()
    private let viewModel: TimetableViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(serviceNumber: String, stopId: Int) {
        self.viewModel = TimetableViewModel(serviceNumber: serviceNumber, stopId: stopId)
        super.init(nibName: nil, bundle: nil)
        title = "Services Hours"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = timetableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupTableView()
        setupSegmentedControl()
        
        Task {
            await viewModel.fetchTimetables()
        }
    }
    
    private func setupTableView() {
        timetableView.tableView.delegate = self
        timetableView.tableView.dataSource = self
    }
    
    private func setupSegmentedControl() {
        timetableView.segmentedControl.addTarget(
            self,
            action: #selector(segmentedControlValueChanged),
            for: .valueChanged
        )
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.updateSelectedDayType(sender.selectedSegmentIndex)
    }
    
    private func setupBindings() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.timetableView.activityIndicator.startAnimating()
                } else {
                    self?.timetableView.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)
        
        viewModel.$filteredDepartures
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.timetableView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error",
                                    message: message,
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension TimetableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredDepartures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimetableCell", for: indexPath)
        let departure = viewModel.filteredDepartures[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(departure.time) - \(departure.destination)"
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Service No: "
    }
} 
