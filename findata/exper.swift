import Foundation

class SampleStrategy: Strategy {
    let ma1Indicator: Indicator
    let ma2Indicator: Indicator
    let signal = Signal()

    var datasets: [String: Dataset] { ["ma1": Dataset(data: ma1Indicator.values), "ma2": Dataset(data: ma2Indicator.values) ] }

    required init(context: Context) {
        ma1Indicator = context.createIndicator(.movingAverage(2))
        ma2Indicator = context.createIndicator(.movingAverage(4))
    }

    func loop(context: Context) {
        signal.set(value: ma1Indicator.value > ma2Indicator.value)
        if signal.change == .up {
            if context.buy(for: context.cash) {
                print("\(context.index): bought, cash \(context.cash), asset \(context.asset), total \(context.asset * context.value)")
            }
        }
        if signal.change == .down {
            if context.sell(volume: context.asset) {
                print("\(context.index): sold, cash \(context.cash), asset \(context.asset), total \(context.asset * context.value)")
            }
        }
    }
}

@main
struct Main {
    static func main() async {
        let code = """
            signal = createSignal()

            function setup(context) {
            ma1Indicator = createMovingAverageIndicator(2)
            ma2Indicator = createMovingAverageIndicator(4)
                addIndicator(context, ma1Indicator)
                addIndicator(context, ma2Indicator)
            }

            function loop(context) {
                setSignal(signal, ma1Indicator.value > ma2Indicator.value)
                if (signal.isUp) {
                    buyFor(context, context.cash)
                }
                if (signal.isDown) {
                    sellVolume(context, context.asset)
                }
            }
            """
        let backtester = Backtester(data: [1, 2, 3, 4, 5])
        if let result = backtester.run(javascript: code, cash: 1_000) {
            print("cash \(result.cash), asset \(result.asset) - \(result.asset * result.value)")
        } else {
            print("failed to run JS strategy")
        }
    }

    static func main2() async {
        let backtester = Backtester(data: [1, 2, 3, 4, 5])
        let result = backtester.run(SampleStrategy.self, cash: 1_000)
        print("cash \(result.cash), asset \(result.asset) - \(result.asset * result.value)")
    }

    static func main3() async {
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
