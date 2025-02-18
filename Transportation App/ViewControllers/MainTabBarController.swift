import UIKit

final class MainTabBarController: UITabBarController {
    private let user: User
    private let menuViewModel: MenuViewModel
    private var menuViewController: UIViewController?
    
    init(user: User) {
        self.user = user
        self.menuViewModel = MenuViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupMenuViewModel()
        setupTabBar()
        setupViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        AppTheme.shared.configureNavigationBar(navigationController)
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(menuButtonTapped))
        menuButton.tintColor = .white
        navigationItem.rightBarButtonItem = menuButton
        
        navigationItem.title = "Transportation App"
    }
    
    private func setupMenuViewModel() {
        menuViewModel.didSelectProfile = { [weak self] in
            guard let self = self else { return }
            let profileVC = ProfileViewController(user: self.user)
            self.navigationController?.pushViewController(profileVC, animated: true)
            self.dismissMenu()
        }
        
        menuViewModel.didSelectAbout = { [weak self] in
            let alert = UIAlertController(title: "Info",
                                        message: "",
                                        preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
            self?.dismissMenu()
        }
    }
    
    @objc private func menuButtonTapped() {
        if menuViewController == nil {
            showMenu()
        } else {
            dismissMenu()
        }
    }
    
    private func showMenu() {
        let menuView = MenuView(frame: view.frame)
        menuView.delegate = self
        let menuVC = UIViewController()
        menuVC.view = menuView
        menuVC.modalPresentationStyle = .overFullScreen
        
        menuView.profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        menuView.aboutButton.addTarget(self, action: #selector(aboutButtonTapped), for: .touchUpInside)
        
        menuViewController = menuVC
        present(menuVC, animated: false) {
            menuView.show()
        }
    }
    
    private func dismissMenu() {
        guard let menuVC = menuViewController,
              let menuView = menuVC.view as? MenuView else { return }
        
        menuView.hide { [weak self] in
            menuVC.dismiss(animated: false)
            self?.menuViewController = nil
        }
    }
    
    @objc private func profileButtonTapped() {
        menuViewModel.handleProfileSelection()
    }
    
    @objc private func aboutButtonTapped() {
        menuViewModel.handleAboutSelection()
    }
    
    private func setupTabBar() {
        AppTheme.shared.configureTabBar(tabBar)
    }
    
    private func setupViewControllers() {
        let homeVC = createNavController(
            for: HomeViewController(user: user),
            title: "Home",
            image: UIImage(systemName: "house.fill")
        )
        
        let mapViewModel = MapViewModel()
        let mapVC = createNavController(
            for: MapViewController(viewModel: mapViewModel),
            title: "Near Stops",
            image: UIImage(systemName: "map.fill")
        )
        
        let servicesViewModel = ServicesViewModel()
        let servicesVC = createNavController(
            for: ServicesViewController(viewModel: servicesViewModel),
            title: "Services",
            image: UIImage(systemName: "bus.fill")
        )
        
        let stopsViewModel = StopsViewModel()
        let stopsVC = createNavController(
            for: StopsViewController(viewModel: stopsViewModel),
            title: "Stops",
            image: UIImage(systemName: "mappin.circle.fill")
        )
        
        let favoritesViewModel = FavoritesViewModel()
        let favoritesVC = createNavController(
            for: FavoritesViewController(viewModel: favoritesViewModel),
            title: "Favorites",
            image: UIImage(systemName: "heart.fill")
        )
        
        viewControllers = [homeVC, mapVC, servicesVC, stopsVC, favoritesVC]
    }
    
    private func createNavController(for rootViewController: UIViewController,
                                   title: String,
                                   image: UIImage?) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        return navController
    }
}

extension MainTabBarController: MenuViewDelegate {
    func menuViewDidTapDimmedView(_ menuView: MenuView) {
        dismissMenu()
    }
} 
