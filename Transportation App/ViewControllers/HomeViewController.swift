//
//  HomeViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//
import UIKit

final class HomeViewController: UIViewController {
    
    private let user: User
    private let homeView = HomeView()
    private var viewModel: HomeViewModel
    
    init(user: User) {
        self.user = user
        self.viewModel = HomeViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = homeView
        setupNavigationBar()
        setupActions()
    }
    
    private func setupNavigationBar() {
        title = "Main Screen"
        navigationController?.navigationBar.isHidden = false
        
        let profileButton = UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(showProfile)
        )
        navigationItem.rightBarButtonItem = profileButton
    }
    
    private func setupActions() {
        homeView.mapButton.addTarget(self, 
                                   action: #selector(mapButtonTapped), 
                                   for: .touchUpInside)
        homeView.stopsButton.addTarget(self,
                                     action: #selector(stopsButtonTapped),
                                     for: .touchUpInside)
        homeView.servicesButton.addTarget(self,
                                        action: #selector(servicesButtonTapped),
                                        for: .touchUpInside)
    }
    
    @objc private func showProfile() {
        let profileVC = ProfileViewController(user: user)
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc private func mapButtonTapped() {
        let viewModel = MapViewModel()
        let mapVC = MapViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @objc private func stopsButtonTapped() {
        let stopsVC = StopsViewController()
        navigationController?.pushViewController(stopsVC, animated: true)
    }
    
    @objc private func servicesButtonTapped() {
        let servicesVC = ServicesViewController()
        navigationController?.pushViewController(servicesVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}
