//
//  ChartData.swift
//  SwiftTrade
//
//  Created by Petr Homola on 02/11/2025.
//

import Foundation

struct ChartData {
    let candles: [Candle]
    
    var minClose: Float64 {
        var min = Float64.greatestFiniteMagnitude
        for candle in candles {
            if candle.low < min { min = candle.low }
        }
        return min
    }
    
    var maxClose: Float64 {
        var max = -Float64.greatestFiniteMagnitude
        for candle in candles {
            if candle.high > max { max = candle.high }
        }
        return max
    }
}
