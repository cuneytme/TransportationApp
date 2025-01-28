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
        homeView.frame = view.bounds
        setupUI()
        setupNavigationBar()
        setupActions()
    }
    
    private func setupUI() {
        
        view.addSubview(homeView)
   
    }
    private func setupActions() {
        homeView.mapButtonAction(self, action: #selector(mapButtonTapped))
    }
    
    private func setupNavigationBar() {
        title = "Main Screen"
        
        let profileButton = UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(showProfile)
        )
        navigationItem.rightBarButtonItem = profileButton
    }
    
  
    
    
    @objc private func showProfile() {
        let profileVC = ProfileViewController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc private func mapButtonTapped() {
        let mapVC = MapViewController()
        navigationController?.pushViewController(mapVC, animated: true)
    }
}
