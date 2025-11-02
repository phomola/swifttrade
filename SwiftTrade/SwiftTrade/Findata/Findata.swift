//
//  Findata.swift
//  SwiftTrade
//
//  Created by Petr Homola on 02/11/2025.
//

import Foundation

enum RuntimeError: Error {
    case badUrl
    case badDateTime
}

enum Interval: Identifiable, CustomStringConvertible {
    case hour1
    case day1
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .hour1: return "1 hour"
        case .day1: return "1 day"
        }
    }
}

protocol DataMeta {
    var currency: String { get }
    var fullExchangeName: String { get }
}

struct Candle {
    let timestamp: Date
    let volume: Float64
    let open: Float64
    let close: Float64
    let low: Float64
    let high: Float64
}
