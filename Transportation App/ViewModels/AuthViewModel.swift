//
//  AuthViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

final class AuthViewModel {
    var didSignIn: ((User) -> Void)?
    var didError: ((String) -> Void)?
    var didLogin: ((User) -> Void)?
    var didFailLogin: ((String) -> Void)?
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func signUp(email: String, password: String, fullName: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = result?.user else {
                let error = NSError(domain: "", code: -1, 
                                  userInfo: [NSLocalizedDescriptionKey: "User creation failed"])
                completion(.failure(error))
                return
            }
            
            let userData: [String: Any] = [
                "userId": firebaseUser.uid,
                "email": email,
                "fullName": fullName,
                "createdAt": FieldValue.serverTimestamp()
            ]
            
            self?.db.collection("users").document(firebaseUser.uid)
                .setData(userData, merge: true) { error in
                    if let error = error {
                        let user = User(id: firebaseUser.uid,
                                      email: email,
                                      fullName: fullName)
                        completion(.success(user))
                        return
                    }
                    
                    let user = User(id: firebaseUser.uid,
                                  email: email,
                                  fullName: fullName)
                    completion(.success(user))
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }
            
            self?.db.collection("users").document(firebaseUser.uid).getDocument { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = snapshot?.data() {
                    let user = User(data: data)
                    DispatchQueue.main.async {
                        let tabBarController = MainTabBarController(user: user)
                        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                           let window = sceneDelegate.window {
                            window.rootViewController = tabBarController
                            window.makeKeyAndVisible()
                        }
                    }
                    completion(.success(user))
                }
            }
        }
    }
    
    func fetchUserData(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data() else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data not found"])))
                return
            }
            
            
            let user = User(id: userId,
                          email: data["email"] as? String ?? "",
                          fullName: data["fullName"] as? String ?? "")
            completion(.success(user))
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
    
    func retryUserDataSave(user: User, completion: @escaping (Error?) -> Void) {
        let userData: [String: Any] = [
            "userId": user.id,
            "email": user.email,
            "fullName": user.fullName,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(user.id)
            .setData(userData, merge: true) { error in
                if let error = error {
                    completion(error)
                    return
                }
                completion(nil)
        }
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.didFailLogin?(error.localizedDescription)
                return
            }
            
            guard let userId = result?.user.uid else {
                self?.didFailLogin?("User ID not found")
                return
            }
            
            self?.fetchUserData(userId: userId) { result in
                switch result {
                case .success(let user):
                    self?.didLogin?(user)
                case .failure(let error):
                    self?.didFailLogin?(error.localizedDescription)
                }
            }
        }
    }
}
