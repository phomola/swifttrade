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
