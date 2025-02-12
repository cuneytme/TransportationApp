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
    private let viewModel: HomeViewModel
    
    init(user: User) {
        self.user = user
        self.viewModel = HomeViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = false
        
        let profileButton = UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(profileButtonTapped)
        )
        navigationItem.rightBarButtonItem = profileButton
    }
    
    private func setupActions() {
        
        homeView.mapButtonAction(self, action: #selector(mapButtonTapped))
        homeView.stopsButtonAction(self, action: #selector(stopsButtonTapped))
        homeView.servicesButtonAction(self, action: #selector(servicesButtonTapped))
    }
    
    private func setupBindings() {
        viewModel.didTapMap = { [weak self] in
            let mapVC = MapViewController(viewModel: MapViewModel())
            self?.navigationController?.pushViewController(mapVC, animated: true)
        }
        
        viewModel.didTapStops = { [weak self] in
            let stopsVC = StopsViewController()
            self?.navigationController?.pushViewController(stopsVC, animated: true)
        }
        
        viewModel.didTapServices = { [weak self] in
            let servicesVC = ServicesViewController()
            self?.navigationController?.pushViewController(servicesVC, animated: true)
        }
    }
    
    @objc private func profileButtonTapped() {
        let profileVC = ProfileViewController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc private func mapButtonTapped() {
        viewModel.didTapMap?()
    }
    
    @objc private func stopsButtonTapped() {
        viewModel.didTapStops?()
    }
    
    @objc private func servicesButtonTapped() {
        viewModel.didTapServices?()
    }
}
