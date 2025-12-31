//
//  Scripting.swift
//  SwiftTrade
//
//  Created by Petr Homola on 02/11/2025.
//

import Foundation
import JavaScriptCore

@objc protocol FloatArrayJS: JSExport {
    var length: Int { get }
    func get(_ index: Int) -> Float64
}

class FloatArray: NSObject, FloatArrayJS {
    var data: [Float64]
    
    init(data: [Float64]) {
        self.data = data
    }
    
    var length: Int {
        data.count
    }
    
    func get(_ index: Int) -> Float64 {
        data[index]
    }
    
    override var description: String { data.description }
}

func jsExper() {
    if let context = JSContext(virtualMachine: JSVirtualMachine()) {
        if let function = context.evaluateScript("(function(array) { return array.length })") {
            if let value = function.call(withArguments: [FloatArray(data: [1, 2, 3])]) {
                if let value = value.toNumber() {
                    print("\(value) \(type(of: value))")
                }
            }
        }
    }
}
