//
//  Scripting.swift
//  SwiftTrade
//
//  Created by Petr Homola on 02/11/2025.
//

import Foundation
import JavaScriptCore

@objc protocol FloatArrayJS: JSExport {
    func length() -> Int
    func get(_ index: Int) -> Float64
}

class FloatArray: NSObject, FloatArrayJS {
    var data: [Float64]
    
    init(data: [Float64]) {
        self.data = data
    }
    
    func length() -> Int {
        data.count
    }
    
    func get(_ index: Int) -> Float64 {
        data[index]
    }
    
    override var description: String { data.description }
}

func jsExper() {
    if let context = JSContext(virtualMachine: JSVirtualMachine()) {
        if let function = context.evaluateScript("(function(array) { return array.length() })") {
            print(function)
            if let value = function.call(withArguments: [FloatArray(data: [1, 2, 3])]) {
                print(value)
                if let value = value.toObject() as? FloatArray {
                    print("\(value) \(type(of: value))")
                }
            }
        }
    }
}
