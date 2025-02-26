//
//  MenuView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//



import UIKit

final class MenuView: UIView {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appPrimary
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: -2, height: 0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 5
        view.layer.zPosition = 1000
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "person.circle.fill", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.setTitle("Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let infoButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "info.circle.fill", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.setTitle("Info", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var delegate: MenuViewDelegate?
    var viewModel: MenuViewModel? {
        didSet {
            setupBindings()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGestureRecognizers()
        self.layer.zPosition = 999
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(dimmedView)
        addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(profileButton)
        stackView.addArrangedSubview(infoButton)
        
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: topAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 250),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            profileButton.heightAnchor.constraint(equalToConstant: 44),
            infoButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        containerView.transform = CGAffineTransform(translationX: 250, y: 0)
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped))
        dimmedView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        containerView.addGestureRecognizer(panGesture)
    }
    
    private func setupBindings() {
        guard let viewModel = viewModel else { return }
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
    }
    
    @objc private func profileButtonTapped() {
        viewModel?.handleProfileSelection()
        delegate?.menuViewDidSelectProfile()
        hide { [weak self] in
            self?.delegate?.menuViewDidTapDimmedView(self!)
        }
    }
    
    @objc private func infoButtonTapped() {
        viewModel?.handleInfoSelection()
        delegate?.menuViewDidSelectInfo()
        hide { [weak self] in
            self?.delegate?.menuViewDidTapDimmedView(self!)
        }
    }
    
    @objc private func dimmedViewTapped() {
        viewModel?.handleDismissMenu()
        delegate?.menuViewDidTapDimmedView(self)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: containerView)
        
        switch gesture.state {
        case .changed:
            guard translation.x >= 0 else { return }
            containerView.transform = CGAffineTransform(translationX: translation.x, y: 0)
            dimmedView.alpha = 0.5 - (translation.x / 500)
            
        case .ended:
            let velocity = gesture.velocity(in: containerView)
            if translation.x > containerView.frame.width / 2 || velocity.x > 500 {
                viewModel?.handleDismissMenu()
                delegate?.menuViewDidSwipeToDismiss(self)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.containerView.transform = .identity
                    self.dimmedView.alpha = 0.5
                }
            }
            
        default:
            break
        }
    }
    
    func show() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.transform = .identity
            self.dimmedView.alpha = 0.5
        }
    }
    
    func hide(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 250, y: 0)
            self.dimmedView.alpha = 0
        }, completion: { _ in
            completion?()
        })
    }
}

protocol MenuViewDelegate: AnyObject {
    func menuViewDidTapDimmedView(_ menuView: MenuView)
    func menuViewDidSwipeToDismiss(_ menuView: MenuView)
    func menuViewDidSelectProfile()
    func menuViewDidSelectInfo()
} 
