//
//  MainTabBarController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 23.02.2025.
//

import UIKit
import Combine

final class MainTabBarController: UITabBarController {
    private let mainTabView = MainTabView()
    private let viewModel: MainTabViewModel
    private var cancellables = Set<AnyCancellable>()
    private var menuViewController: UIViewController?
    private let user: User
    
    init(user: User) {
        self.user = user
        self.viewModel = MainTabViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupNavigationBar()
        AppTheme.shared.configureTabBar(tabBar)
    }
    
    private func setupBindings() {
        viewModel.$viewControllers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewControllers in
                self?.setViewControllers(viewControllers, animated: false)
            }
            .store(in: &cancellables)
        
        viewModel.$selectedIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.selectedIndex = index
            }
            .store(in: &cancellables)
            
        viewModel.didRequestShowMenu = { [weak self] in
            self?.showMenu()
        }
        
        viewModel.didRequestShowProfile = { [weak self] in
            guard let self = self else { return }
            let profileVC = ProfileViewController(user: self.viewModel.getUser())
            let navController = UINavigationController(rootViewController: profileVC)
            self.present(navController, animated: true)
        }
        
        viewModel.didRequestShowInfo = { [weak self] in
            let infoVC = InfoViewController(viewModel: InfoViewModel())
            let navController = UINavigationController(rootViewController: infoVC)
            self?.present(navController, animated: true)
        }
    }
    
    private func setupNavigationBar() {
        let menuButton = viewModel.createMenuButton()
        menuButton.target = self
        menuButton.action = #selector(menuButtonTapped)
        navigationItem.rightBarButtonItem = menuButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .appPrimary
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func menuButtonTapped() {
        viewModel.handleMenuButtonTapped()
    }
    
    private func showMenu() {
        let menuView = MenuView()
        menuView.delegate = self
        menuView.viewModel = viewModel.getMenuViewModel()
        
        let menuVC = UIViewController()
        menuVC.view = menuView
        menuVC.modalPresentationStyle = .overFullScreen
        
        menuViewController = menuVC
        present(menuVC, animated: false) {
            menuView.show()
        }
    }
}

extension MainTabBarController: MenuViewDelegate {
    func menuViewDidTapDimmedView(_ menuView: MenuView) {
        menuView.hide { [weak self] in
            self?.menuViewController?.dismiss(animated: false)
        }
    }
    
    func menuViewDidSwipeToDismiss(_ menuView: MenuView) {
        menuView.hide { [weak self] in
            self?.menuViewController?.dismiss(animated: false)
        }
    }
    
    func menuViewDidSelectProfile() {
        menuViewController?.dismiss(animated: false) { [weak self] in
            self?.viewModel.handleProfileSelection()
        }
    }
    
    func menuViewDidSelectInfo() {
        menuViewController?.dismiss(animated: false) { [weak self] in
            self?.viewModel.handleInfoSelection()
        }
    }
} 
