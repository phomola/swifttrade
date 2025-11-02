import Foundation

struct Candle {
    let timestamp: Date
    let volume: Float64
    let open: Float64
    let close: Float64
    let low: Float64
    let high: Float64
}

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

struct YahooMeta: Decodable {
    let currency: String
    let symbol: String
    let exchangeName: String
    let fullExchangeName: String
    let timezone: String
    let exchangeTimezoneName: String
    let longName: String
    let shortName: String
}

enum RuntimeError: Error {
    case badUrl
    case badDateTime
}

func fetchYahooData(symbol: String, from: Date, to: Date, interval: String) async throws -> ([Candle], YahooMeta) {
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
    for (i, timestamp) in timestamps.enumerated() {
        candles.append(Candle(timestamp: Date(timeIntervalSince1970: Float64(timestamp)), volume: volume[i], open: open[i], close: close[i], low: low[i], high: high[i]))
    }
    return (candles, response.chart.result[0].meta)
}
