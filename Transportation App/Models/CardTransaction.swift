//
//  CardTransaction.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 23.02.2025.
//

import UIKit

struct CardTransaction {
    let serviceNumber: String
    let date: Date
    let amount: Double
    let type: String
    
    var isLoadBalance: Bool {
        return type == "Load Balance"
    }
} 
