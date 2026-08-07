//
//  SymbolData.swift
//  SwiftTrade
//
//  Created by Petr Homola on 02/11/2025.
//

import Foundation
import SwiftData

@Model
final class SymbolData {
    var timestamp: Date = Date.now
    var symbol: String = ""
    
    init(timestamp: Date, symbol: String) {
        self.timestamp = timestamp
        self.symbol = symbol
    }
}
