//
//  HomeViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//

import Foundation
import Firebase
import FirebaseAuth

final class HomeViewModel {
    private let nfcReader = NFCReader()
    private let user: User
    private let db = Firestore.firestore()
    
    var didLogout: (() -> Void)?
    var didUpdateCardReadStatus: ((Bool) -> Void)?
    var didUpdateRegisteredCardInfo: ((String) -> Void)?
    var didTapLoadBalance: (() -> Void)?
    var didTapPayWithQR: (() -> Void)?
    
    var didTapMap: (() -> Void)?
    var didTapStops: (() -> Void)?
    var didTapServices: (() -> Void)?
    
    var didTapRegisterCard: (() -> Void)?
    
    var didUpdateCardInfo: ((String) -> Void)?
    
    init(user: User) {
        self.user = user
        nfcReader.delegate = self
        startListeningToUserUpdates()
    }
    
    private func startListeningToUserUpdates() {
        db.collection("users").document(user.id)
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let document = documentSnapshot,
                      let data = document.data() else {
                    return
                }
                
                let user = User(data: data)
                
                if let cardNumber = user.cardNumber {
                    let buttonInfo = """
                    Name: \(user.fullName)
                    Title:   \(user.title)
                    Balance: £\(String(format: "%.2f", user.balance))
                    
                    
                    
                    Card No: \(cardNumber)
                    """
                    
                    DispatchQueue.main.async {
                        self?.didUpdateCardReadStatus?(true)
                        self?.didUpdateRegisteredCardInfo?(buttonInfo)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.didUpdateCardReadStatus?(false)
                    }
                }
            }
    }
    
    private func checkExistingCard() {
        db.collection("users").document(user.id).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(),
                  let cardNumber = data["cardNumber"] as? String else {
                self?.didUpdateCardReadStatus?(false)
                return
            }
            
            let fullName = data["fullName"] as? String ?? ""
            let title = data["title"] as? String ?? ""
            let balance = data["balance"] as? Double ?? 0.0
            
            let buttonInfo = """
            Name: \(fullName)
            Title: \(title)
            Balance: £\(balance)
            
            
            
            Card No: \(cardNumber)
            """
            self?.didUpdateCardReadStatus?(true)
            self?.didUpdateRegisteredCardInfo?(buttonInfo)
        }
    }
    
    var userName: String {
        return user.fullName
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            didLogout?()
        } catch {
            //
        }
    }
    
    func registerCard() {
        nfcReader.startScanning()
    }
    
    func handleLoadBalanceTapped() {
        didTapLoadBalance?()
    }
    
    func handlePayWithQRTapped() {
        didTapPayWithQR?()
    }
    
    
}

extension HomeViewModel: NFCReaderDelegate {
    func didReadCard(cardNumber: String, cardType: CardType) {
        let buttonInfo = """
        Name: \(user.fullName)
        Title: \(user.title)
        Balance: £\(user.balance)
        
        
        
        Card No: \(cardNumber)
        """
        
        db.collection("users").document(user.id).updateData([
            "cardNumber": cardNumber,
            "balance": 0.0
        ]) { [weak self] error in
            if let error = error {
               //
                return
            }
            
            DispatchQueue.main.async {
                self?.didUpdateCardReadStatus?(true)
                self?.didUpdateRegisteredCardInfo?(buttonInfo)
            }
        }
    }
    
    func didFailWithError(_ error: Error) {
        didUpdateCardReadStatus?(false)
    }
}
