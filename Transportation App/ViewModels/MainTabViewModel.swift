import UIKit
import Combine

final class MainTabViewModel {
    private let user: User
    private let menuViewModel: MenuViewModel
    
    @Published private(set) var selectedIndex = 0
    @Published private(set) var viewControllers: [UIViewController] = []
    
    var didRequestShowMenu: (() -> Void)?
    var didRequestShowProfile: (() -> Void)?
    
    init(user: User) {
        self.user = user
        self.menuViewModel = MenuViewModel(user: user)
        setupViewControllers()
        setupMenuBindings()
    }
    
    private func setupMenuBindings() {
        menuViewModel.didSelectProfile = { [weak self] in
            self?.didRequestShowProfile?()
        }
    }
    
    func handleMenuButtonTapped() {
        didRequestShowMenu?()
    }
    
    func setSelectedIndex(_ index: Int) {
        selectedIndex = index
    }
    
    private func setupViewControllers() {
        let homeVC = createNavController(
            for: HomeViewController(user: user),
            title: "Home",
            image: UIImage(systemName: "house")
        )
        
        let mapVC = createNavController(
            for: MapViewController(viewModel: MapViewModel()),
            title: "Near Stops",
            image: UIImage(systemName: "map")
        )
        
        let servicesVC = createNavController(
            for: ServicesViewController(),
            title: "Services",
            image: UIImage(systemName: "bus")
        )
        
        let stopsVC = createNavController(
            for: StopsViewController(),
            title: "Stops",
            image: UIImage(systemName: "mappin.and.ellipse")
        )
        
        let favoritesVC = createNavController(
            for: FavoritesViewController(),
            title: "Favorites",
            image: UIImage(systemName: "heart")
        )
        
        viewControllers = [homeVC, mapVC, servicesVC, stopsVC, favoritesVC]
    }
    
    private func createNavController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage?
    ) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        return navController
    }
    
    func configureMenuButton(_ target: AnyObject?, action: Selector) {
        if let navigationController = viewControllers.first as? UINavigationController {
            navigationController.topViewController?.navigationItem.rightBarButtonItem?.target = target
            navigationController.topViewController?.navigationItem.rightBarButtonItem?.action = action
        }
    }
    
    func createMenuButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3"),
            style: .plain,
            target: nil,
            action: nil
        )
    }
    
    func getUser() -> User {
        return user
    }
    
    func handleProfileSelection() {
        didRequestShowProfile?()
    }
    
    func getMenuViewModel() -> MenuViewModel {
        return menuViewModel
    }
} 
