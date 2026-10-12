import Foundation

protocol Value: CustomStringConvertible {}

struct IntegerValue: Value {
    let value: Int

    var description: String { "\(value)" }
}

struct FloatValue: Value {
    let value: Double

    var description: String { "\(value)" }
}

struct StringValue: Value {
    let value: String

    var description: String { value }
}
