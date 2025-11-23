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

class Signal {
    var previousValue: Bool?
    var currentValue: Bool?
    
    func set(value: Bool) {
        previousValue = currentValue
        currentValue = value
    }

    enum Change {
        case up
        case down
        case unchanged
        case undetermined
    }

    var change: Change {
        if let previousValue = previousValue {
            if currentValue! && !previousValue { return .up }
            if !currentValue! && previousValue { return .down }
            return .unchanged
        }
        return .undetermined
    }
}

class Context {
    var cash: Float64
    var asset: Float64 = 0.0
    var index: Int = 0
    var value: Float64 = 0.0
    var indicators: [Indicator] = []

    init(cash: Float64) {
        self.cash = cash
    }

    func add(indicator: Indicator) {
        indicators.append(indicator)
    }

    // func buy(for amount: Float64) -> Bool {}
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

    func run(strategy: Strategy, cash: Float64) -> Result {
        let context = Context(cash: cash)
        strategy.setup(context: context)
        for (index, value) in data.enumerated() {
            for indicator in context.indicators {
                indicator.add(value: value)
            }
            context.index = index
            context.value = value
            strategy.loop(context: context)
        }  
        return Result(datasets: strategy.datasets)
    }
}
