import Foundation

class SampleStrategy: Strategy {
    let ma1Indicator = MovingAverage(window: 2)
    let ma2Indicator = MovingAverage(window: 4)
    let signal = Signal()

    var datasets: [String: Dataset] { ["ma1": Dataset(data: ma1Indicator.values), "ma2": Dataset(data: ma2Indicator.values) ] }

    func setup(context: Context) {
        context.add(indicator: ma1Indicator)
        context.add(indicator: ma2Indicator)
    }

    func loop(context: Context) {
        signal.set(value: ma1Indicator.value > ma2Indicator.value)
        print("\(context.index) \(signal.change)")
    }
}

@main
struct Main {
    static func main() async {
        let backtester = Backtester(data: [1, 2, 3, 4, 5])
        let result = backtester.run(strategy: SampleStrategy(), cash: 1_000)
        print(result.datasets)
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
