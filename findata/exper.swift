import Foundation

class SampleStrategy: Strategy {
    var ma1Indicator = MovingAverage(window: 20)
    var ma1Dataset = Dataset()

    var datasets: [String: Dataset] { ["ma1": ma1Dataset] }

    func setup(context: Context) {
        context.add(indicator: ma1Indicator)
    }

    func loop(context: Context) {
        ma1Dataset.add(value: ma1Indicator.value)
    }
}

@main
struct Main {
    static func main() async {
        let backtester = Backtester(data: [1, 2, 3, 4, 5])
        backtester.run(strategy: SampleStrategy())
        print(backtester.datasets)
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
