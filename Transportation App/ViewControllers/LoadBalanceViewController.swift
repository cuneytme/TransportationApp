import UIKit

final class LoadBalanceViewController: UIViewController {
    
    private let loadBalanceView = LoadBalanceView()
    private let viewModel: LoadBalanceViewModel
    
    init(user: User) {
        self.viewModel = LoadBalanceViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = loadBalanceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
        loadBalanceView.loadBalanceButton.addTarget(self, 
                                                  action: #selector(handleLoadBalance), 
                                                  for: .touchUpInside)
        
        viewModel.didUpdateBalance = { [weak self] newBalance in
            let alert = UIAlertController(
                title: "Success",
                message: "Balance successfully loaded. New balance: £\(String(format: "%.2f", newBalance))",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.dismiss(animated: true)
            })
            self?.present(alert, animated: true)
        }
        
        viewModel.didError = { [weak self] error in
            let alert = UIAlertController(
                title: "Error",
                message: error,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    @objc private func handleLoadBalance() {
        guard let amountText = loadBalanceView.amountTextField.text,
              let amount = Double(amountText) else {
            let alert = UIAlertController(
                title: "Invalid Amount",
                message: "Please enter a valid amount",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        viewModel.loadBalance(amount: amount)
    }
} 
