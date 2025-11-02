//
//  Findata.swift
//  SwiftTrade
//
//  Created by Petr Homola on 02/11/2025.
//

import Foundation
import SwiftUI

enum RuntimeError: Error {
    case badUrl
    case badDateTime
}

enum Interval: Identifiable {
    case hour1
    case day1
    
    var id: Self { self }
    
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .hour1: return LocalizedStringKey("1hour")
        case .day1: return LocalizedStringKey("1day")
        }
    }
}

protocol DataMeta {
    var currency: String { get }
    var fullExchangeName: String { get }
}

struct Candle: Identifiable {
    let timestamp: Date
    let volume: Float64
    let open: Float64
    let close: Float64
    let low: Float64
    let high: Float64
    
    var id: Date { timestamp }
}
