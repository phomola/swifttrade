import Foundation

class Dataset: CustomStringConvertible {
    var data: [Float64]

    init(data: [Float64]) {
        self.data = data
    }

    func add(value: Float64) {
        data.append(value)
    }

    var description: String { data.description }
}

class Portfolio {
    var assets: [String: Float64] = [:]
}

class Context {
    let portfolio: Portfolio
    var indicators: [Indicator] = []

    init(portfolio: Portfolio) {
        self.portfolio = portfolio
    }

    func add(indicator: Indicator) {
        indicators.append(indicator)
    }
}

protocol Strategy {
    var datasets: [String: Dataset] { get }
    func setup(context: Context)
    func loop(context: Context)
}

class Backtester {
    let data: [Float64]
    
    init(data: [Float64]) {
        self.data = data
    }

    init(candles: [Candle]) {
        var data: [Float64] = []
        data.reserveCapacity(candles.count)
        for candle in candles {
            data.append(candle.close)
        }
        self.data = data
    }

    struct Result {
        var datasets: [String: Dataset]
    }

    func run(strategy: Strategy) -> Result {
        let portfolio = Portfolio()
        let context = Context(portfolio: portfolio)
        strategy.setup(context: context)
        for value in data {
            for indicator in context.indicators {
                indicator.add(value: value)
            }
            strategy.loop(context: context)
        }  
        return Result(datasets: strategy.datasets)
    }
}
