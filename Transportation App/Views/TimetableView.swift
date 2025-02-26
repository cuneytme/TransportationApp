//
//  TimetableView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 07.02.2025.
//

import UIKit

final class TimetableView: UIView {
    let segmentedControl: UISegmentedControl = {
        let items = ["Weekday", "Saturday", "Sunday"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = .white
        control.selectedSegmentTintColor = .appPrimary
        control.setTitleTextAttributes([.foregroundColor: UIColor.appPrimary], for: .normal)
        control.setTitleTextAttributes([.foregroundColor: UIColor.buttonColor], for: .selected)
        return control
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(TimetableCell.self, forCellReuseIdentifier: TimetableCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemBlue
        table.separatorStyle = .none
        return table
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    let timelineView: TimelineView = {
        let view = TimelineView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBlue
        addSubview(segmentedControl)
        addSubview(timelineView)
        addSubview(tableView)
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            timelineView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            timelineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            timelineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            timelineView.heightAnchor.constraint(equalToConstant: 24),
            
            tableView.topAnchor.constraint(equalTo: timelineView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
} 
