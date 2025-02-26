//
//  NFCReader.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 20.02.2025.
//


import CoreNFC

enum CardType {
    case plus
    case ultralight
    case creditCard
    case unknown
    
    var description: String {
        switch self {
        case .plus: return "Plus Card"
        case .ultralight: return "Ultralight Card"
        case .creditCard: return "Credit Card"
        case .unknown: return "Unknown Card"
        }
    }
}

protocol NFCReaderDelegate: AnyObject {
    func didReadCard(cardNumber: String, cardType: CardType)
    func didFailWithError(_ error: Error)
}

class NFCReader: NSObject, NFCTagReaderSessionDelegate {
    weak var delegate: NFCReaderDelegate?
    private var session: NFCTagReaderSession?
    private var hasReadCard = false
    
    func startScanning() {
        guard NFCTagReaderSession.readingAvailable else {
            delegate?.didFailWithError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "NFC reading not available"]))
            return
        }
        
        hasReadCard = false
        session = NFCTagReaderSession(pollingOption: [.iso14443, .iso15693], delegate: self)
        session?.begin()
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        if !hasReadCard {
            delegate?.didFailWithError(error)
        }
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let tag = tags.first else { return }
        
        let cardType: CardType
        let cardNumber: String
        
        switch tag {
        case .miFare(let miFareTag):
            if miFareTag.mifareFamily == .plus {
                cardType = .plus
            } else {
                cardType = .ultralight
            }
            cardNumber = miFareTag.identifier.map { String(format: "%02X", $0) }.joined()
            
        case .iso7816(let iso7816Tag):
            cardType = .creditCard
            cardNumber = iso7816Tag.identifier.map { String(format: "%02X", $0) }.joined()
            
        default:
            cardType = .unknown
            cardNumber = "Unknown Card"
        }
        
        hasReadCard = true
        delegate?.didReadCard(cardNumber: cardNumber, cardType: cardType)
        session.invalidate()
    }
} 
