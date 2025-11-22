import Foundation

protocol Indicator {
    var value: Float64 { get }
    func add(value: Float64)
}

class MovingAverage: Indicator {
    var data: [Float64] = []
    var window: Int
    var value: Float64 = 0.0

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
    }
}