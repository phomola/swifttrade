import Foundation
import JavaScriptCore

class JSStrategy {
    let context: JSContext
    let setupJS: JSValue
    let loopJS: JSValue
    var datasets: [String: Dataset] { [:] }

    init?(code: String) {
        if let context = JSContext(virtualMachine: JSVirtualMachine()) {
            let movingAverage: @convention(block) (Context, Int) -> Indicator = { context, window in
                context.createIndicator(.movingAverage(window: window))
            }
            context.setObject(movingAverage, forKeyedSubscript: "createMovingAverageIndicator" as NSString)

            let createSignal: @convention(block) (Context, JSValue) -> Signal = { context, block in
                context.createSignal {
                    block.call(withArguments: []).toBool()
                }
            }
            context.setObject(createSignal, forKeyedSubscript: "createSignal" as NSString)

            let buyFor: @convention(block) (Context, Float64) -> Bool = { context, amount in
                context.buy(for: amount)
            }
            context.setObject(buyFor, forKeyedSubscript: "buyFor" as NSString)

            let sellVolume: @convention(block) (Context, Float64) -> Bool = { context, volume in
                context.sell(volume: volume)
            }
            context.setObject(sellVolume, forKeyedSubscript: "sellVolume" as NSString)

            context.evaluateScript(code)
            self.setupJS = context.objectForKeyedSubscript("setup")
            self.loopJS = context.objectForKeyedSubscript("loop")
            self.context = context
        } else {
            return nil
        }
    }

    func setup(context: Context) {
        setupJS.call(withArguments: [context])
    }

    func loop(context: Context) {
        loopJS.call(withArguments: [context])
    }
}
