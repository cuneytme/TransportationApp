//
//  AuthViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//

import Firebase
import FirebaseAuth

final class AuthViewModel {
    var didSignIn: ((User) -> Void)?
    var didError: ((String) -> Void)?
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func signIn(email: String, password: String) {
        
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.didError?(self?.handleAuthError(error) ?? error.localizedDescription)
                return
            }
            
            guard let uid = result?.user.uid else {
                self?.didError?("User information not found")
                return
            }
            
            
            let userRef = self?.db.collection("users").document(uid)
            userRef?.getDocument(source: .server) { snapshot, error in
                if let error = error {
                    print("Firestore error: \(error.localizedDescription)")
                    if let currentUser = Auth.auth().currentUser {
                        let userData: [String: Any] = [
                            "email": currentUser.email ?? "",
                            "fullName": currentUser.displayName ?? "User"
                        ]
                        let user = User(uid: currentUser.uid, dictionary: userData)
                        self?.didSignIn?(user)
                    } else {
                        self?.didError?("User information not found")
                    }
                    return
                }
                
                var userData: [String: Any] = [:]
                
                if let data = snapshot?.data() {
                    userData = data
                } else {
                    if let currentUser = Auth.auth().currentUser {
                        userData = [
                            "email": currentUser.email ?? "",
                            "fullName": currentUser.displayName ?? "User",
                            "createdAt": FieldValue.serverTimestamp(),
                            "updatedAt": FieldValue.serverTimestamp()
                        ]
                        
                      
                    }
                }
                
                print("User information found: \(userData)")
                let user = User(uid: uid, dictionary: userData)
                self?.didSignIn?(user)
            }
        }
    }
    
    private func handleAuthError(_ error: Error) -> String {
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.wrongPassword.rawValue:
            return "Wrong password"
        case AuthErrorCode.invalidEmail.rawValue:
            return "Invalid email"
        case AuthErrorCode.userNotFound.rawValue:
            return "User not found"
        case AuthErrorCode.networkError.rawValue:
            return "The internet connection appears to be offline"
        default:
            return "Not sure what went wrong: \(error.localizedDescription)"
        }
    }
    
    private func checkFirebaseConnection(completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        var isConnected = false
        
        group.enter()
        db.collection("test").document("test").getDocument { (_, error) in
            isConnected = error == nil
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(isConnected)
        }
    }
    
    func signUp(email: String, password: String, fullName: String, completion: @escaping (Result<Void, Error>) -> Void) {
              
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
       }
    }
    
    private func fetchUserData(uid: String) {
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { [weak self] snapshot, error in
            if let error = error {
                self?.didError?(error.localizedDescription)
                return
            }
            
            guard let dictionary = snapshot?.data() else {
                self?.didError?("User information not found")
                return
            }
            
            let user = User(uid: uid, dictionary: dictionary)
            self?.didSignIn?(user)
        }
    }
} 
