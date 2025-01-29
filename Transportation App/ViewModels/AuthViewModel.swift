//
//  AuthViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//

import FirebaseAuth

final class AuthViewModel {
    var didSignIn: ((User) -> Void)?
    var didError: ((String) -> Void)?
    
    private let auth = Auth.auth()
    
    func signIn(email: String, password: String) {
        didError?("Loading...")
        
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.didError?(self?.handleAuthError(error) ?? error.localizedDescription)
                return
            }
            
            guard let firebaseUser = result?.user else {
                self?.didError?("User could not be found")
                return
            }
            
            let user = User(uid: firebaseUser.uid, 
                          dictionary: [
                            "email": firebaseUser.email ?? "",
                            "fullName": firebaseUser.displayName ?? ""
                          ])
            
            self?.didSignIn?(user)
        }
    }
    
    func signUp(email: String, password: String, fullName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User could not be created"])))
                return
            }
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = fullName
            
            changeRequest.commitChanges { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
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
}
