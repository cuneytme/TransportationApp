//
//  ProfileViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore

final class ProfileViewModel {
    enum UserTitle: String, CaseIterable {
        case student = "Student"
        case personal = "Personal"
        case teacher = "Teacher"
        case disabled = "Disabled"
        case retired = "Retired"
    }
    
    private var user: User
    private let db = Firestore.firestore()
    
    var didLogout: (() -> Void)?
    var didUpdateUser: ((User) -> Void)?
    var didDeleteCard: (() -> Void)?
    var didUpdateTitle: ((String) -> Void)?
    var didError: ((String) -> Void)?
    
    init(user: User) {
        self.user = user
        startListeningToUserUpdates()
    }
    
    private func startListeningToUserUpdates() {
        db.collection("users").document(user.id)
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let document = documentSnapshot,
                      let data = document.data() else {
                    self?.didError?("Error fetching user data")
                    return
                }
                
                let updatedUser = User(data: data)
                self?.user = updatedUser
                self?.didUpdateUser?(updatedUser)
            }
    }
    
    var userInfo: User {
        return user
    }
    
    var userFullName: String {
        return user.fullName
    }
    
    var userEmail: String {
        return user.email
    }
    
    var userTitle: String {
        return user.title
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            didLogout?()
        } catch {
         //
        }
    }
    
    func deleteCard() {
        let db = Firestore.firestore()
        db.collection("users").document(user.id).updateData([
            "cardNumber": FieldValue.delete(),
            "balance": 0.0
        ]) { [weak self] error in
            if let error = error {
    //
                return
            }
            
            DispatchQueue.main.async {
                self?.didDeleteCard?()
            }
        }
    }
    
    func updateTitle(_ title: String) {
        db.collection("users").document(user.id).updateData([
            "title": title
        ]) { [weak self] error in
            if let error = error {
                self?.didError?("Error updating title: \(error.localizedDescription)")
                return
            }
            self?.didUpdateTitle?(title)
        }
    }
    
    var availableTitles: [String] {
        return UserTitle.allCases.map { $0.rawValue }
    }
} 
