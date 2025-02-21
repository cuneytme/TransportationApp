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
    var didLogout: (() -> Void)?
    
    var didTapMap: (() -> Void)?
    var didTapStops: (() -> Void)?
    var didTapServices: (() -> Void)?
    
    var didTapRegisterCard: (() -> Void)?
    
    var didUpdateCardInfo: ((String) -> Void)?
    
    var didUpdateCardReadStatus: ((Bool) -> Void)?
    var didUpdateRegisteredCardInfo: ((String) -> Void)?
    
    var didTapLoadBalance: (() -> Void)?
    var didTapPayWithQR: (() -> Void)?
    
    init(user: User) {
        self.user = user
        nfcReader.delegate = self
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
        let buttonInfo = "Name: \(user.fullName)\n Card No: \(cardNumber)"
        didUpdateCardReadStatus?(true)
        didUpdateRegisteredCardInfo?(buttonInfo)
    }
    
    func didFailWithError(_ error: Error) {
        didUpdateCardReadStatus?(false)
    }
}
