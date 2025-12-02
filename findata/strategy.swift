import Foundation
import JavaScriptCore

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

@objc protocol SignalJS: JSExport {
    var isUp: Bool { get }
    var isDown: Bool { get }
}

class Signal: NSObject, SignalJS {
    var previousValue: Bool?
    var currentValue: Bool?
    let block: () -> Bool

    init(block: @escaping () -> Bool) {
        self.block = block
    }
    
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
    var isUp: Bool { return change == .up }
    var isDown: Bool { return change == .down }
}

@objc protocol ContextJS: JSExport {
    var cash: Float64 { get }
    var asset: Float64 { get }
    var index: Int { get }
    var value: Float64 { get }
}

enum IndicatorType {
    case movingAverage(window: Int)
}

class Context: NSObject, ContextJS {
    var cash: Float64
    var asset: Float64 = 0.0
    var index: Int = 0
    var value: Float64 = 0.0
    var indicators: [Indicator] = []
    var signals: [Signal] = []

    init(cash: Float64) {
        self.cash = cash
    }

    func add(indicator: Indicator) {
        indicators.append(indicator)
    }

    func add(signal: Signal) {
        signals.append(signal)
    }

    func createIndicator(_ type: IndicatorType) -> Indicator {
        let indicator: Indicator
        switch type {
        case .movingAverage(let window):
            indicator = MovingAverage(window: window)
        }
        add(indicator: indicator)
        return indicator
    }

    func createSignal(block: @escaping () -> Bool) -> Signal {
        let signal = Signal(block: block)
        add(signal: signal)
        return signal
    }

    func buy(for amount: Float64) -> Bool {
        if amount <= cash {
            cash -= amount
            asset += amount / value
            return true
        }
        return false
    }

    func sell(volume: Float64) -> Bool {
        if volume <= asset {
            asset -= volume
            cash += volume * value
            return true
        }
        return false
    }
}

protocol StrategyBase {
    var datasets: [String: Dataset] { get }
    func loop(context: Context)
}

protocol Strategy: StrategyBase {
    init(context: Context)
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
        var cash: Float64
        var asset: Float64
        var value: Float64
    }

    func run(javascript code: String, cash: Float64) -> Result? {
        if let strategy = JSStrategy(code: code) {
            let context = Context(cash: cash)
            strategy.setup(context: context)
            return run(strategy: strategy, context: context)
        } else {
            return nil
        }
    }

    func run<T: Strategy>(_ type: T.Type, cash: Float64) -> Result {
        let context = Context(cash: cash)
        let strategy = type.init(context: context)
        return run(strategy: strategy, context: context)
    }

    func run(strategy: StrategyBase, context: Context) -> Result {
        for (index, value) in data.enumerated() {
            for indicator in context.indicators {
                indicator.add(value: value)
            }
            for signal in context.signals {
                signal.set(value: signal.block())
            }
            context.index = index
            context.value = value
            strategy.loop(context: context)
        }  
        return Result(datasets: strategy.datasets, cash: context.cash, asset: context.asset, value: context.value)
    }
}
