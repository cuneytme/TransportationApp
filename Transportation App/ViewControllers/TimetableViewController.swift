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
        
        viewModel.startTimeUpdates()
        
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
                self?.scrollToCurrentTime()
            }
            .store(in: &cancellables)
        
        viewModel.$currentTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                self?.timetableView.timelineView.updateTime(time)
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
    
    private func scrollToCurrentTime() {
        if let index = viewModel.scrollToCurrentTime() {
            let indexPath = IndexPath(row: index, section: 0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { return }
                
                let timelineBottom = self.timetableView.timelineView.frame.maxY
                
                self.timetableView.tableView.contentInset = UIEdgeInsets(
                    top: timelineBottom,
                    left: 0,
                    bottom: 20,
                    right: 0
                )
                
                self.timetableView.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
}

extension TimetableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredDepartures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimetableCell.identifier, for: indexPath) as? TimetableCell else {
            return UITableViewCell()
        }
        
        let departure = viewModel.filteredDepartures[indexPath.row]
        cell.configure(with: departure.time, destination: departure.destination)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
} 
