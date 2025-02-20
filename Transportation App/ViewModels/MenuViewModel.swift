final class MenuViewModel {
    private let user: User
    
    var didSelectProfile: (() -> Void)?
    var didSelectAbout: (() -> Void)?
    var didRequestDismissMenu: (() -> Void)?
    
    init(user: User) {
        self.user = user
    }
    
    func handleProfileSelection() {
        didSelectProfile?()
    }
    
    func handleAboutSelection() {
        didSelectAbout?()
    }
    
    func getUser() -> User {
        return user
    }
    
    func handleDismissMenu() {
        didRequestDismissMenu?()
    }
} 