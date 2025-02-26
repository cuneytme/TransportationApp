//
//  LoadBalanceViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//

import Foundation
import FirebaseFirestore

final class LoadBalanceViewModel {
    private let db = Firestore.firestore()
    private var user: User
    
    var didUpdateBalance: ((Double) -> Void)?
    var didCompleteTransaction: (() -> Void)?
    var didError: ((String) -> Void)?
    
    init(user: User) {
        self.user = user
    }
    
    func formatCardNumber(_ number: String) -> String {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        var formatted = ""
        
        for (index, char) in cleaned.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted += " "
            }
            formatted += String(char)
        }
        
        return formatted
    }
    
    func formatExpiryDate(_ text: String) -> String {
        let cleaned = text.replacingOccurrences(of: "/", with: "")
        if cleaned.count >= 2 {
            return cleaned.prefix(2) + "/" + cleaned.dropFirst(2)
        }
        return cleaned
    }
    
    func loadBalance(amount: Double) {
        db.collection("users").document(user.id).getDocument { [weak self] snapshot, error in
            if let error = error {
                self?.didError?(error.localizedDescription)
                return
            }
            
            guard let data = snapshot?.data(),
                  let currentBalance = data["balance"] as? Double else {
                self?.didError?("Could not fetch current balance")
                return
            }
            
            let newBalance = currentBalance + amount
            
            self?.db.collection("users").document(self?.user.id ?? "").updateData([
                "balance": newBalance
            ]) { error in
                if let error = error {
                    self?.didError?(error.localizedDescription)
                    return
                }
                
                let transaction = [
                    "type": "Load Balance",
                    "amount": amount,
                    "date": FieldValue.serverTimestamp(),
                    "serviceNumber": "-"
                ] as [String : Any]
                
                self?.db.collection("users")
                    .document(self?.user.id ?? "")
                    .collection("transactions")
                    .addDocument(data: transaction) { error in
                        if let error = error {
                            self?.didError?(error.localizedDescription)
                            return
                        }
                        
                        self?.user = User(id: self?.user.id ?? "",
                                        email: self?.user.email ?? "",
                                        fullName: self?.user.fullName ?? "",
                                        title: self?.user.title ?? "",
                                        cardNumber: self?.user.cardNumber,
                                        balance: newBalance)
                        
                        self?.didUpdateBalance?(newBalance)
                        self?.didCompleteTransaction?()
                }
            }
        }
    }
} 
