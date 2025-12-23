//
//  YahooData.swift
//  SwiftTrade
//
//  Created by Petr Homola on 02/11/2025.
//

import Foundation

struct YahooResponse: Decodable {
    let chart: YahooChart
}

struct YahooChart: Decodable {
    let result: [YahooResult]
}

struct YahooResult: Decodable {
    let timestamp: [Int64]
    let indicators: YahooIndicators
    let meta: YahooMeta
}

struct YahooIndicators: Decodable {
    let quote: [YahooQuote]
}

struct YahooQuote: Decodable {
    let volume: [Float64]
    let open: [Float64]
    let close: [Float64]
    let low: [Float64]
    let high: [Float64]
}

struct YahooMeta: DataMeta, Decodable {
    let currency: String
    let symbol: String
    let exchangeName: String
    let fullExchangeName: String
    let timezone: String
    let exchangeTimezoneName: String
    let longName: String
    let shortName: String
}

enum YahooInterval: CustomStringConvertible {
    case hour1
    case day1
    
    init(_ interval: Interval) {
        switch interval {
        case .hour1:
            self = .hour1
        case .day1:
            self = .day1
        }
    }
    
    var description: String {
        switch self {
        case .hour1: return "1h"
        case .day1: return "1d"
        }
    }
}

func fetchYahooData(symbol: String, from: Date, to: Date, interval: Interval) async throws -> ([Candle], DataMeta) {
    let interval = YahooInterval(interval)
    guard let url = URL(string: "https://query1.finance.yahoo.com/v8/finance/chart/\(symbol)?period1=\(Int(from.timeIntervalSince1970))&period2=\(Int(to.timeIntervalSince1970))&interval=\(interval)") else {
        throw RuntimeError.badUrl
    }
    var request = URLRequest(url: url)
    request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
    request.httpMethod = "GET"
    let (data, _) = try await URLSession.shared.data(for: request)
    let response = try JSONDecoder().decode(YahooResponse.self, from: data)
    let timestamps = response.chart.result[0].timestamp
    let volume = response.chart.result[0].indicators.quote[0].volume
    let open = response.chart.result[0].indicators.quote[0].open
    let close = response.chart.result[0].indicators.quote[0].close
    let low = response.chart.result[0].indicators.quote[0].low
    let high = response.chart.result[0].indicators.quote[0].high
    var candles: [Candle] = []
    candles.reserveCapacity(timestamps.count)
    for (i, timestamp) in timestamps.enumerated() {
        if volume[i] > 0 {
            candles.append(Candle(index: i, timestamp: Date(timeIntervalSince1970: Float64(timestamp)), volume: volume[i], open: open[i], close: close[i], low: low[i], high: high[i]))
        }
    }
    return (candles, response.chart.result[0].meta)
}
