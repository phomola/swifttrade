import Foundation
import JavaScriptCore

@objc protocol IndicatorJS: JSExport {
    var value: Float64 { get }
}

@objc protocol Indicator: IndicatorJS {
    var value: Float64 { get }
    var values: [Float64] { get }
    func add(value: Float64)
}

class MovingAverage: NSObject, Indicator {
    var data: [Float64] = []
    let window: Int
    var value: Float64 = 0.0
    var values: [Float64] = []

    init(window: Int) {
        self.window = window
    }

    func add(value: Float64) {
        data.append(value)
        if data.count <= window {
            self.value = data.reduce(0) { $0 + $1 } / Float64(data.count)
        } else {
            self.value = data[(data.count - window)..<data.count].reduce(0) { $0 + $1 } / Float64(window)
        }
        values.append(self.value)
    }

    override var description: String { "moving average indicator (window=\(window))" }
}