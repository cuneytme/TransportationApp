//
//  LoadBalanceView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 22.02.2025.
//



import UIKit

extension LoadBalanceView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "") as NSString
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        switch textField {
        case cardNumberTextField:
            let cleaned = newText.replacingOccurrences(of: " ", with: "")
            return cleaned.count <= 16
            
        case expiryDateTextField:
            let cleaned = newText.replacingOccurrences(of: "/", with: "")
            return cleaned.count <= 4
            
        case cvvTextField:
            return newText.count <= 3
            
        default:
            return true
        }
    }
} 
