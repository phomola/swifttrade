import Foundation

protocol Indicator {
    func add(data: Float64, timestamp: Date)
    var value: Float64 { get }
}
