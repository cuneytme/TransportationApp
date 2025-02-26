//
//  InfoViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 22.02.2025.
//


import UIKit

final class InfoViewController: UIViewController {
    private let infoView = InfoView()
    private let viewModel: InfoViewModel
    
    init(viewModel: InfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = infoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Info"
        infoView.configure(with: viewModel)
    }
} 
