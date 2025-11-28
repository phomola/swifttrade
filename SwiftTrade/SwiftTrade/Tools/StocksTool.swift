//
//  PeriodTool.swift
//  SwiftTrade
//
//  Created by Petr Homola on 23/09/2025.
//

import Foundation
import FoundationModels

@available(iOS 26, *)
struct StocksTool: Tool {
    let name = "stocksTool"
    let description = "Provides prices of stocks."
    
    @Generable
    struct Arguments {
        @Guide(description: "The date and/or time in the yyyy-mm-dd format.")
        let date: String
        @Guide(description: "The ticker symbol.")
        let symbol: String
    }
    
    @Generable
    struct Reply {
        let date: String
        let price: Double
    }
    
    enum ParseError: Error {
        case dateParsingFailed
    }
    
    func call(arguments: Arguments) async throws -> Reply {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print("input: \(arguments.symbol) \(arguments.date)")
        if let date = formatter.date(from: arguments.date) {
            print("parsed input: \(arguments.symbol) \(date)")
            return Reply(date: formatter.string(from: date), price: 123)
        }
        throw ParseError.dateParsingFailed
    }
}
