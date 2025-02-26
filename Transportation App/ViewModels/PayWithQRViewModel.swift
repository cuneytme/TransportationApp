//
//  PayWithQRViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//



import Foundation
import FirebaseFirestore

final class PayWithQRViewModel {
    private let user: User
    private let db = Firestore.firestore()
    private let paymentAmount = 3.0
    
    var didCompletePayment: (() -> Void)?
    var didReceiveError: ((String) -> Void)?
    
    init(user: User) {
        self.user = user
    }
    
    func processPayment() {
        db.collection("users").document(user.id).getDocument { [weak self] snapshot, error in
            guard let self = self,
                  let data = snapshot?.data(),
                  let currentBalance = data["balance"] as? Double else { return }
            
            if currentBalance <= 3.0 {
                self.didReceiveError?("Insufficient balance. Please top up your card.")
                return
            }
            
            let newBalance = currentBalance - self.paymentAmount
            let randomBusNumber = String(Int.random(in: 1...50))
            
            self.db.collection("users").document(self.user.id).updateData([
                "balance": newBalance
            ]) { error in
                if let error = error {
                   //
                } else {
                    
                    self.didCompletePayment?() 
                }
            }
            
            self.db.collection("users")
                .document(self.user.id)
                .collection("transactions")
                .addDocument(data: [
                    "type": "Bus",
                    "amount": self.paymentAmount,
                    "date": Timestamp(date: Date()),
                    "serviceNumber": randomBusNumber
                ])
        }
    }
} 
