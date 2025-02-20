import UIKit
import Combine

final class MainTabBarController: UITabBarController {
    private let mainTabView = MainTabView()
    private let viewModel: MainTabViewModel
    private var cancellables = Set<AnyCancellable>()
    private var menuViewController: UIViewController?
    
    init(user: User) {
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
            let profileView = ProfileView()
            profileView.configure(with: self.viewModel.getUser())
            
            let profileVC = UIViewController()
            profileVC.view = profileView
            let navController = UINavigationController(rootViewController: profileVC)
            self.present(navController, animated: true)
        }
    }
    
    private func setupNavigationBar() {
        let menuButton = viewModel.createMenuButton()
        menuButton.target = self
        menuButton.action = #selector(menuButtonTapped)
        navigationItem.rightBarButtonItem = menuButton
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
} 
