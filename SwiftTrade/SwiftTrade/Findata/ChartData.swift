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
            if candle.close < min { min = candle.close }
        }
        return min
    }
    var maxClose: Float64 {
        var max = Float64.leastNormalMagnitude
        for candle in candles {
            if candle.close > max { max = candle.close }
        }
        return max
    }
}
