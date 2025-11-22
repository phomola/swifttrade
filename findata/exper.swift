import Foundation

@main
struct Main {
    static func main() async {
        let indicator = MovingAverage(window: 3)
        for x in [1.0, 2.0, 3.0, 4.0, 5.0] {
            indicator.add(value: x)
            print("\(x) \(indicator.value)")
        }
    }

    static func main2() async {
        do {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM y, HH:mm"
            guard let from = formatter.date(from: "1 Sep 2025, 01:00") else { throw RuntimeError.badDateTime }
            guard let to = formatter.date(from: "5 Sep 2025, 23:00") else { throw RuntimeError.badDateTime }
            let (candles, meta) = try await fetchYahooData(symbol: "AAPL", from: from, to: to, interval: .day1)
            print("\(meta.currency) \(meta.fullExchangeName)")
            for candle in candles {
                print("\(candle.timestamp) \(candle.volume) \(candle.low) \(candle.open) \(candle.close) \(candle.high)")
            }
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
