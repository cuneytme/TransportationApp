final class MenuViewModel {
    private let user: User
    
    var didSelectProfile: (() -> Void)?
    var didSelectAbout: (() -> Void)?
    
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
} 