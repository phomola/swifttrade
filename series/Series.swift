import Foundation

final class Series {
    let values: [Float64]

    init(values: [Float64]) {
        self.values = values
    }

    func minus(_ y: Float64) -> Series {
        var values = [Float64]()
        values.reserveCapacity(values.count)
        for x in self.values {
            values.append(x - y)
        }
        return Series(values: values)
    }

    func pow(_ y: Float64) -> Series {
        var values = [Float64]()
        values.reserveCapacity(values.count)
        for x in self.values {
            values.append(_DarwinFoundation1.pow(x, y))
        }
        return Series(values: values)
    }

    func cummax() -> Series {
        var values = [Float64]()
        values.reserveCapacity(values.count)
        var max = -Float64.greatestFiniteMagnitude
        for x in self.values {
            if x > max {
                max = x
            }
            values.append(max)
        }
        return Series(values: values)
    }

    func div(_ other: Series) -> Series {
        var values = [Float64]()
        values.reserveCapacity(values.count)
        for i in 0..<self.values.count {
            let x = self.values[i]
            let y = other.values[i]
            values.append(x / y)
        }
        return Series(values: values)
    }

    func min() -> Float64 {
        var min = Float64.greatestFiniteMagnitude
        for x in values {
            if x < min {
                min = x
            }
        }
        return min
    }

    func sum() -> Float64 {
        var sum = 0.0
        for x in values {
            sum += x
        }
        return sum
    }

    func filter(_ predicate: (Float64) -> Bool) -> Series {
        var values = [Float64]()
        values.reserveCapacity(values.count)
        for x in self.values {
            if predicate(x) {
                values.append(x)
            }
        }
        return Series(values: values)
    }

    func mean() -> Float64 {
        return sum() / Float64(values.count)
    }

    func std() -> Float64 {
        return sqrt(minus(self.mean()).pow(2).sum() / Float64(values.count - 1))
    }
}
