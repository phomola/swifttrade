//
//  Symbol.swift
//  SwiftTrade
//
//  Created by Petr Homola on 02/11/2025.
//

import Foundation

struct Symbol: Identifiable {
    let text: String
    
    var id: String { text }
}
