//
//  CardHistoryViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 23.02.2025.
//

import UIKit
import FirebaseFirestore

final class CardHistoryViewModel {
    private let user: User
    private let service = TransportService()
    private var transactions: [CardTransaction] = []
    private let db = Firestore.firestore()
    
    var didUpdateTransactions: (([CardTransaction]) -> Void)?
    var didReceiveError: ((String) -> Void)?
    var didUpdateCardInfo: ((String) -> Void)?
    
    init(user: User) {
        self.user = user
        startListeningToTransactions()
        startListeningToUserUpdates()
        addMockTransactions()
    }
    
    private func addMockTransactions() {
        let mockTransactions: [CardTransaction] = [
            CardTransaction(
                serviceNumber: "35",
                date: Date().addingTimeInterval(-86400),
                amount: 3.00,
                type: "Bus"
            ),
            CardTransaction(
                serviceNumber: "41",
                date: Date().addingTimeInterval(-86400),
                amount: 3.00,
                type: "Bus"
            ),
            CardTransaction(
                serviceNumber: "T50",
                date: Date().addingTimeInterval(-86400),
                amount: 3.00,
                type: "Tram"
            )
        ]
        
        for transaction in mockTransactions {
            db.collection("users")
                .document(user.id)
                .collection("transactions")
                .addDocument(data: [
                    "type": transaction.type,
                    "amount": transaction.amount,
                    "date": transaction.date,
                    "serviceNumber": transaction.serviceNumber
                ])
        }
    }
    
    private func startListeningToTransactions() {
        db.collection("users")
            .document(user.id)
            .collection("transactions")
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error in
                if let error = error {
                    self?.didReceiveError?(error.localizedDescription)
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    self?.didReceiveError?("No transactions found")
                    return
                }
                
                var transactions: [CardTransaction] = []
                
                for document in documents {
                    let data = document.data()
                    
                    if let type = data["type"] as? String,
                       let amount = data["amount"] as? Double,
                       let date = (data["date"] as? Timestamp)?.dateValue(),
                       let serviceNumber = data["serviceNumber"] as? String {
                        
                        let transaction = CardTransaction(
                            serviceNumber: serviceNumber,
                            date: date,
                            amount: amount,
                            type: type
                        )
                        transactions.append(transaction)
                    }
                }
                
                self?.transactions = transactions
                self?.didUpdateTransactions?(transactions)
            }
    }
    
    private func startListeningToUserUpdates() {
        db.collection("users").document(user.id)
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let document = documentSnapshot,
                      let data = document.data() else {
                    return
                }
                
                let updatedUser = User(data: data)
                let cardInfo = """
                Name: \(updatedUser.fullName)
                Title: \(updatedUser.title)
                Balance: £\(String(format: "%.2f", updatedUser.balance))
                """
                self?.didUpdateCardInfo?(cardInfo)
            }
    }
    
    var cardInfo: String {
        """
        Name: \(user.fullName)
        Title: \(user.title)
        Balance: £\(String(format: "%.2f", user.balance))
        """
    }
    
    func numberOfTransactions() -> Int {
        return transactions.count
    }
    
    func transaction(at index: Int) -> CardTransaction {
        return transactions[index]
    }
} 
